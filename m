Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB399C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 23:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0FDF2067D
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 23:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgG2XVj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 19:21:39 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:43229 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbgG2XVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 19:21:39 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8AA5AD7F054;
        Thu, 30 Jul 2020 09:21:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k0vO7-0001KV-2E; Thu, 30 Jul 2020 09:21:31 +1000
Date:   Thu, 30 Jul 2020 09:21:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Yasunori Goto <y-goto@fujitsu.com>
Cc:     "Li, Hao" <lihao2018.fnst@cn.fujitsu.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "ira.weiny@intel.com" <ira.weiny@intel.com>
Subject: Re: Can we change the S_DAX flag immediately on XFS without dropping
 caches?
Message-ID: <20200729232131.GC2005@dread.disaster.area>
References: <9dc179147f6a47279d801445f3efeecc@G08CNEXMBPEKD04.g08.fujitsu.local>
 <20200728022059.GX2005@dread.disaster.area>
 <573feb69-bc38-8eb4-ee9b-7c49802eb737@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <573feb69-bc38-8eb4-ee9b-7c49802eb737@fujitsu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=_fcLz_GkVchqeGo6EiQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 29, 2020 at 11:23:21AM +0900, Yasunori Goto wrote:
> Hi,
> 
> On 2020/07/28 11:20, Dave Chinner wrote:
> > On Tue, Jul 28, 2020 at 02:00:08AM +0000, Li, Hao wrote:
> > > Hi,
> > > 
> > > I have noticed that we have to drop caches to make the changing of S_DAX
> > > flag take effect after using chattr +x to turn on DAX for a existing
> > > regular file. The related function is xfs_diflags_to_iflags, whose
> > > second parameter determines whether we should set S_DAX immediately.
> > Yup, as documented in Documentation/filesystems/dax.txt. Specifically:
> > 
> >   6. When changing the S_DAX policy via toggling the persistent FS_XFLAG_DAX flag,
> >      the change in behaviour for existing regular files may not occur
> >      immediately.  If the change must take effect immediately, the administrator
> >      needs to:
> > 
> >      a) stop the application so there are no active references to the data set
> >         the policy change will affect
> > 
> >      b) evict the data set from kernel caches so it will be re-instantiated when
> >         the application is restarted. This can be achieved by:
> > 
> >         i. drop-caches
> >         ii. a filesystem unmount and mount cycle
> >         iii. a system reboot
> > 
> > > I can't figure out why we do this. Is this because the page caches in
> > > address_space->i_pages are hard to deal with?
> > Because of unfixable races in the page fault path that prevent
> > changing the caching behaviour of the inode while concurrent access
> > is possible. The only way to guarantee races can't happen is to
> > cycle the inode out of cache.
> 
> I understand why the drop_cache operation is necessary. Thanks.
> 
> BTW, even normal user becomes to able to change DAX flag for an inode,
> drop_cache operation still requires root permission, right?

Step back for a minute and explain why you want to be able to change
the DAX mode of a file -as a user-.

> So, if kernel have a feature for normal user can operate drop cache for "a
> inode" with
> its permission, I think it improve the above limitation, and
> we would like to try to implement it recently.

No, drop_caches is not going to be made available to users. That
makes it s trivial system wide DoS vector.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
