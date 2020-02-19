Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D911DC34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCDBD2467A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgBSEKf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 23:10:35 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57800 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726826AbgBSEKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 23:10:35 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1456C7EAFAA;
        Wed, 19 Feb 2020 15:10:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j4Ggz-0005k3-8Z; Wed, 19 Feb 2020 15:10:33 +1100
Date:   Wed, 19 Feb 2020 15:10:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 23/31] xfs: properly type the buffer field in struct
 xfs_fsop_attrlist_handlereq
Message-ID: <20200219041033.GK10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-24-hch@lst.de>
 <20200217235315.GY10776@dread.disaster.area>
 <20200218153924.GB21780@lst.de>
 <20200219005847.GG9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219005847.GG9506@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=QyZR4WbsfNoAadtN2jQA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 04:58:47PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 18, 2020 at 04:39:24PM +0100, Christoph Hellwig wrote:
> > On Tue, Feb 18, 2020 at 10:53:16AM +1100, Dave Chinner wrote:
> > > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > > index ae77bcd8c05b..21920f613d42 100644
> > > > --- a/fs/xfs/libxfs/xfs_fs.h
> > > > +++ b/fs/xfs/libxfs/xfs_fs.h
> > > > @@ -597,7 +597,7 @@ typedef struct xfs_fsop_attrlist_handlereq {
> > > >  	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
> > > >  	__u32				flags;	/* which namespace to use */
> > > >  	__u32				buflen;	/* length of buffer supplied */
> > > > -	void				__user *buffer;	/* returned names */
> > > > +	struct xfs_attrlist __user	*buffer;/* returned names */
> > > >  } xfs_fsop_attrlist_handlereq_t;
> > > 
> > > This changes the userspace API, right? So, in theory, it could break
> > > compilation of userspace applications that treat it as an attrlist_t
> > > and don't specifically cast the assignment because it's currently
> > > a void pointer?
> > 
> > IFF userspace was using this header it would change the API.  But
> > userspace uses the libattr definition exclusively.
> 
> Assuming most userspace will use libhandle (and not call the ioctl
> directly) then this "shouldn't" be a problem because libhandle treats
> the attrlist buffer as a void pointer.

There's a lot of "if's" there. :/

All I'm asking for is that the changes are documented as known and
intentional so that we don't end up a couple of years down the track
wondering WTF we were thinking when we made this change...

> (I dunno, how difficult /is/ it to say "program to the library, not the
> kernel ABI" here?)

The xfsctl(3) man page already says this:

       XFS_IOC_PATH_TO_HANDLE
       XFS_IOC_PATH_TO_FSHANDLE
       XFS_IOC_FD_TO_HANDLE
       XFS_IOC_OPEN_BY_HANDLE
       XFS_IOC_READLINK_BY_HANDLE
       XFS_IOC_ATTR_LIST_BY_HANDLE
       XFS_IOC_ATTR_MULTI_BY_HANDLE
       XFS_IOC_FSSETDM_BY_HANDLE
		These are all interfaces that are used to implement
		various libhandle functions (see open_by_handle(3)).
		They  are  all  subject  to change and should not be
		called directly by applications.

and the open_by_handle(3) man page says "use libhandle to access
these functions".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
