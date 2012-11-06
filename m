Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6H6Zvt076866 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 11:06:35 -0600
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id f77cw2AarYHeiyEZ for
	<xfs@oss.sgi.com>; Tue, 06 Nov 2012 09:08:30 -0800 (PST)
Subject: Re: [PATCH v6 09/10] xfs: add minimum file size filtering to
	eofblocks scan
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <5099417E.3080509@sgi.com>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352213447-59791-10-git-send-email-bfoster@redhat.com>
	<5099417E.3080509@sgi.com>
Date: Tue, 06 Nov 2012 17:08:29 +0000
Message-Id: <1352221709.3179.9.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com


On Tue, 2012-11-06 at 10:57 -0600, Mark Tinguely wrote:
> On 11/06/12 08:50, Brian Foster wrote:
> > Support minimum file size filtering in the eofblocks scan. The
> > caller must set the XFS_EOF_FLAGS_MINFILESIZE flags bit and minimum
> > file size value in bytes.
> >
> > Signed-off-by: Brian Foster<bfoster@redhat.com>
> > ---
> >   fs/xfs/xfs_fs.h     |    6 ++++--
> >   fs/xfs/xfs_icache.c |   11 +++++++++--
> >   2 files changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> > index 88eb1bc..082b743 100644
> > --- a/fs/xfs/xfs_fs.h
> > +++ b/fs/xfs/xfs_fs.h
> > @@ -348,7 +348,8 @@ struct xfs_eofblocks {
> >   	uid_t		eof_uid;
> >   	gid_t		eof_gid;
> >   	prid_t		eof_prid;
> > -	__u32		pad[27];
> > +	__u64           eof_min_file_size;
> > +	__u32		pad[25]
>                              ^^
> Glad you bumped it to a unsigned 64 bit value.
> Are __u64 items 64 bits? if so, the pad would be 24
> 

It should probably be:

__u32 pad_align_64;
__u64 eof_min_file_size;
__u32 pad[24];


> >   };
> >
> 
> Looks good.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com?
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
