Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D31C33CAF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 19:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F18C52073A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 19:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387652AbgAPTMO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 14:12:14 -0500
Received: from mga05.intel.com ([192.55.52.43]:25859 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387645AbgAPTML (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Jan 2020 14:12:11 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 11:12:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,327,1574150400"; 
   d="scan'208";a="424162125"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jan 2020 11:12:11 -0800
Date:   Thu, 16 Jan 2020 11:12:10 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH V2 08/12] fs/xfs: Add lock/unlock mode to xfs
Message-ID: <20200116191210.GG24522@iweiny-DESK2.sc.intel.com>
References: <20200110192942.25021-1-ira.weiny@intel.com>
 <20200110192942.25021-9-ira.weiny@intel.com>
 <20200116092446.GA8446@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116092446.GA8446@quack2.suse.cz>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 10:24:46AM +0100, Jan Kara wrote:
> On Fri 10-01-20 11:29:38, ira.weiny@intel.com wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > XFS requires regular files to be locked while changing to/from DAX mode.
> > 
> > Define a new DAX lock type and implement the [un]lock_mode() inode
> > operation callbacks.
> > 
> > We define a new XFS_DAX_* lock type to carry the lock through the
> > transaction because we don't want to use IOLOCK as that would cause
> > performance issues with locking of the inode itself.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ...
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 492e53992fa9..693ca66bd89b 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -67,6 +67,9 @@ typedef struct xfs_inode {
> >  	spinlock_t		i_ioend_lock;
> >  	struct work_struct	i_ioend_work;
> >  	struct list_head	i_ioend_list;
> > +
> > +	/* protect changing the mode to/from DAX */
> > +	struct percpu_rw_semaphore i_dax_sem;
> >  } xfs_inode_t;
> 
> This adds overhead of ~32k per inode for typical distro kernel.

Wow!

> That's not
> going to fly.

Probably not...

> That's why ext4 has similar kind of lock in the superblock
> shared by all inodes. For read side it does not matter because that's
> per-cpu and shared lock. For write side we don't care as changing inode
> access mode should be rare.

Sounds reasonable to me.  I'll convert it.

Thanks for pointing this out, that would have been bad indeed.
Ira

