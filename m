Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0JBEDE1187614 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 05:14:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ECF4151745B
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:15:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	GBg5kt4v2dtTd5dW for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 03:15:12 -0800 (PST)
Date: Tue, 19 Jan 2010 22:15:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: make compile warn about char sign mismatches
	again
Message-ID: <20100119111509.GC14035@discord.disaster>
References: <1263861026-13448-1-git-send-email-david@fromorbit.com>
	<1263861026-13448-9-git-send-email-david@fromorbit.com>
	<20100119092939.GG7168@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100119092939.GG7168@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 19, 2010 at 04:29:39AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 19, 2010 at 11:30:26AM +1100, Dave Chinner wrote:
> > The -fno-unsigned-char directive has no effect anymore as the
> > XFs build is clean. However, the kernel build hides pointer sign
> > differences so turn that back on so that we can clean up all the
> > mismatches prior to a userspace code resync.
> 
> Not so happy about turning the warning on so we have local compiler
> warning differences from the rest of the kernel again, but it's not
> that bad, so
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > index 6f26875..9f7c001 100644
> > --- a/fs/xfs/xfs_vnodeops.c
> > +++ b/fs/xfs/xfs_vnodeops.c
> > @@ -2199,7 +2199,8 @@ xfs_symlink(
> >  	if (DM_EVENT_ENABLED(dp, DM_EVENT_SYMLINK)) {
> >  		error = XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dp,
> >  					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
> > -					link_name->name, target_path, 0, 0, 0);
> > +					link_name->name,
> > +					(unsigned char *)target_path, 0, 0, 0);
> >  		if (error)
> >  			return error;
> >  	}
> > @@ -2395,7 +2396,8 @@ std_return:
> >  					dp, DM_RIGHT_NULL,
> >  					error ? NULL : ip,
> >  					DM_RIGHT_NULL, link_name->name,
> > -					target_path, 0, error, 0);
> > +					(unsigned char *)target_path,
> > +					0, error, 0);
> 
> These changes are nowhere mentioned in the changelog.  And they probably
> belong into the patch changing the dmapi events to take unsigned chars.

I though I fixed that. Oh well, I'll fix it up again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
