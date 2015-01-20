Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8CE407F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 10:53:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B3DE304048
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 08:53:41 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id D1sh86DlOCGkokQu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 08:53:40 -0800 (PST)
Date: Tue, 20 Jan 2015 17:53:38 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/17] quota: Switch ->get_dqblk() and ->set_dqblk() to
	use bytes as space units
Message-ID: <20150120165338.GC3648@quack.suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-8-git-send-email-jack@suse.cz>
	<20150119090720.GG27474@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150119090720.GG27474@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, cluster-devel@redhat.com, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon 19-01-15 01:07:20, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 18dc721ca19f..f718ba1f2ccb 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -559,18 +559,4 @@ typedef struct xfs_swapext
> >  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
> >  
> >  
> > -#ifndef HAVE_BBMACROS
> > -/*
> > - * Block I/O parameterization.	A basic block (BB) is the lowest size of
> > - * filesystem allocation, and must equal 512.  Length units given to bio
> > - * routines are in BB's.
> > - */
> > -#define BBSHIFT		9
> > -#define BBSIZE		(1<<BBSHIFT)
> > -#define BBMASK		(BBSIZE-1)
> > -#define BTOBB(bytes)	(((__u64)(bytes) + BBSIZE - 1) >> BBSHIFT)
> > -#define BTOBBT(bytes)	((__u64)(bytes) >> BBSHIFT)
> > -#define BBTOB(bbs)	((bbs) << BBSHIFT)
> > -#endif
> 
> Please don't move these defintions around and just opencode them in
> the quota code.
  I have moved the definitions because Dave asked me to use them in the XFS
parts of quota code (maybe he didn't realize that to be able to use them I
have to move the definitions somewhere where quota code can include them).
Dave? I personally don't care which variant will get used...

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
  Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
