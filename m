Return-Path: <SRS0=4IRk=BR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4928EC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Aug 2020 17:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19D8A2086A
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Aug 2020 17:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgHGRJF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Aug 2020 13:09:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:51408 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgHGRJD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Aug 2020 13:09:03 -0400
IronPort-SDR: egnsQHfJpfxqTWiheuprvckyjyY0cpnE/4n7vmw89sVCZ8/hX6rN944HzoVvs48aSHTLuMzmsA
 lAx5nxbnJoAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9706"; a="154290822"
X-IronPort-AV: E=Sophos;i="5.75,446,1589266800"; 
   d="scan'208";a="154290822"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 10:09:02 -0700
IronPort-SDR: 6PljnrE0hdnnASZnjTGzrPXjmcsGyKCtPQIhUNnadDY7UhhQX9hTxwgCQDOX+KObR4UXupEmRC
 tt8dqECEQ3bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,446,1589266800"; 
   d="scan'208";a="333600808"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.147])
  by orsmga007.jf.intel.com with ESMTP; 07 Aug 2020 10:09:02 -0700
Date:   Fri, 7 Aug 2020 10:09:02 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Yasunori Goto <y-goto@fujitsu.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Li, Hao" <lihao2018.fnst@cn.fujitsu.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Subject: Re: Can we change the S_DAX flag immediately on XFS without dropping
 caches?
Message-ID: <20200807170858.GU1573827@iweiny-DESK2.sc.intel.com>
References: <9dc179147f6a47279d801445f3efeecc@G08CNEXMBPEKD04.g08.fujitsu.local>
 <20200728022059.GX2005@dread.disaster.area>
 <573feb69-bc38-8eb4-ee9b-7c49802eb737@fujitsu.com>
 <20200729232131.GC2005@dread.disaster.area>
 <0d380010-cccd-162d-32bc-07d094cb152d@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d380010-cccd-162d-32bc-07d094cb152d@fujitsu.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 31, 2020 at 06:59:32PM +0900, Yasunori Goto wrote:
> On 2020/07/30 8:21, Dave Chinner wrote:
> > On Wed, Jul 29, 2020 at 11:23:21AM +0900, Yasunori Goto wrote:
> > > Hi,
> > > 
> > > On 2020/07/28 11:20, Dave Chinner wrote:
> > > > On Tue, Jul 28, 2020 at 02:00:08AM +0000, Li, Hao wrote:
> > > > > Hi,
> > > > > 
> > > > > I have noticed that we have to drop caches to make the changing of S_DAX
> > > > > flag take effect after using chattr +x to turn on DAX for a existing
> > > > > regular file. The related function is xfs_diflags_to_iflags, whose
> > > > > second parameter determines whether we should set S_DAX immediately.
> > > > Yup, as documented in Documentation/filesystems/dax.txt. Specifically:
> > > > 
> > > >    6. When changing the S_DAX policy via toggling the persistent FS_XFLAG_DAX flag,
> > > >       the change in behaviour for existing regular files may not occur
> > > >       immediately.  If the change must take effect immediately, the administrator
> > > >       needs to:
> > > > 
> > > >       a) stop the application so there are no active references to the data set
> > > >          the policy change will affect
> > > > 
> > > >       b) evict the data set from kernel caches so it will be re-instantiated when
> > > >          the application is restarted. This can be achieved by:
> > > > 
> > > >          i. drop-caches
> > > >          ii. a filesystem unmount and mount cycle
> > > >          iii. a system reboot
> > > > 
> > > > > I can't figure out why we do this. Is this because the page caches in
> > > > > address_space->i_pages are hard to deal with?
> > > > Because of unfixable races in the page fault path that prevent
> > > > changing the caching behaviour of the inode while concurrent access
> > > > is possible. The only way to guarantee races can't happen is to
> > > > cycle the inode out of cache.
> > > I understand why the drop_cache operation is necessary. Thanks.
> > > 
> > > BTW, even normal user becomes to able to change DAX flag for an inode,
> > > drop_cache operation still requires root permission, right?
> > Step back for a minute and explain why you want to be able to change
> > the DAX mode of a file -as a user-.
> 
> 
> For example, there are 2 containers executed in a system, which is named as
> container A and container B, and these host gives FS-DAX files to each
> containers.
> If the user of container A would like to change DAX-off for tuning, then he
> will stop his application
> and change DAX flag, but the flag may not be changed.
> 
> Then he will "need" to ask host operator to execute drop_cache, and the
> operator did it.
> As a result, not only container A, but also container B get the impact of
> drop_cache.
> 
> Especially, if this is multi tenant container system, then I think this is
> not acceptable.
> 
> Probably, there are 2 problems I think.
> 1) drop_cache requires root permission.
> 2) drop_cache has too wide effect.
> 
> > 
> > > So, if kernel have a feature for normal user can operate drop cache for "a
> > > inode" with
> > > its permission, I think it improve the above limitation, and
> > > we would like to try to implement it recently.
> > No, drop_caches is not going to be made available to users. That
> > makes it s trivial system wide DoS vector.
> 
> The current drop_cache feature tries to drop ALL of cache (page cache and/or
> slab cache).
> Then, I agree that normal user should not drop all of them.
> 
> But my intention was that drop cache of ONE file which is changed dax flag,
> (and if possible, drop only the inode cache.)
> Do you mean it will be still cause of weakness against DoS attack?
> If so, I should give up to solve problem 1) at least.

FWIW changing the on disk flag automatically flags the inode to be dropped as
soon as all references are done.

See:

2c567af418e3 fs: Introduce DCACHE_DONTCACHE
dae2f8ed7992 fs: Lift XFS_IDONTCACHE to the VFS layer

But from a users perspective you just don't know when that will happen.  The
system just can't guarantee it.  The best the user can do is stop taking
references to the file and close all references, and periodically check the
state.  But this will take a reference so...  Kind of a catch-22 here...  :-(

Ira

> 
> 
> Thanks,
> 
> > 
> > Cheers,
> > 
> > Dave.
> 
> -- 
> Yasunori Goto
> 
