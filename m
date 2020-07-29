Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B98DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 16:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446E820809
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 16:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgG2QKs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 12:10:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:56002 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2QKs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Jul 2020 12:10:48 -0400
IronPort-SDR: QCfIgLttXfAgRCOdvyLwih8K9ic/nDJzcMQBzdmVbll4kzZeQ6zCXEO62Bra24d2I4bVUi5gag
 bLn8AFFIYdag==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="151428427"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="151428427"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:10:41 -0700
IronPort-SDR: i7X1v4Hd61tSPtOHwyapVU3DpUiuiiKjbknAuZyuu6ZTZld0mdwSsCKC4UI0xk0/Aw/dKSFeuh
 SD8kUQzhsvYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="290580949"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.147])
  by orsmga006.jf.intel.com with ESMTP; 29 Jul 2020 09:10:40 -0700
Date:   Wed, 29 Jul 2020 09:10:40 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Yasunori Goto <y-goto@fujitsu.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Li, Hao" <lihao2018.fnst@cn.fujitsu.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Subject: Re: Can we change the S_DAX flag immediately on XFS without dropping
 caches?
Message-ID: <20200729161040.GA1250504@iweiny-DESK2.sc.intel.com>
References: <9dc179147f6a47279d801445f3efeecc@G08CNEXMBPEKD04.g08.fujitsu.local>
 <20200728022059.GX2005@dread.disaster.area>
 <573feb69-bc38-8eb4-ee9b-7c49802eb737@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <573feb69-bc38-8eb4-ee9b-7c49802eb737@fujitsu.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
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
> 
> So, if kernel have a feature for normal user can operate drop cache for "a
> inode" with
> its permission, I think it improve the above limitation, and
> we would like to try to implement it recently.
> 
> Do you have any opinion making such feature?
> (Agree/opposition, or any other comment?)

I would not be opposed but there were many hurdles to that implementation.

What is the use case you are thinking of here?

The compromise of dropping caches was reached because we envisioned that many
users would simply want to chose the file mode when a file was created and
maintain that mode through the lifetime of the file.  To that end one can
simply create directories which have the desired dax mode and any files created
in that directory will inherit the dax mode immediately.  So there is no need
to switch the file mode directly as a normal user.

Would that work for your use case?

Ira

> 
> Thanks,
> 
> -- 
> Yasunori Goto
> 
