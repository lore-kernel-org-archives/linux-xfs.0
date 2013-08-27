Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B4DB29E02
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 16:26:02 -0500 (CDT)
Date: Tue, 27 Aug 2013 16:25:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH v2] xfs: don't leak root inode reference
Message-ID: <20130827212558.GY5262@sgi.com>
References: <20130826204730.GZ7153@sgi.com>
 <20130826212423.GX6023@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130826212423.GX6023@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Tue, Aug 27, 2013 at 07:24:23AM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2013 at 03:47:30PM -0500, Ben Myers wrote:
> > Looks like in 48fde701 we removed the iput of the root inode in
> > xfs_fs_fill_super for the error case.  Add it back.
> > 
> > Signed-off-by: Ben Myers <bpm@sgi.com>
> > 
> > ---
> >  fs/xfs/xfs_super.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > Index: b/fs/xfs/xfs_super.c
> > ===================================================================
> > --- a/fs/xfs/xfs_super.c	2013-08-26 15:36:09.170848579 -0500
> > +++ b/fs/xfs/xfs_super.c	2013-08-26 15:40:19.450817933 -0500
> > @@ -1493,12 +1493,12 @@ xfs_fs_fill_super(
> >  	}
> >  	if (is_bad_inode(root)) {
> >  		error = EINVAL;
> > -		goto out_unmount;
> > +		goto out_iput;
> >  	}
> >  	sb->s_root = d_make_root(root);
> >  	if (!sb->s_root) {
> >  		error = ENOMEM;
> > -		goto out_unmount;
> > +		goto out_iput;
> >  	}
> 
> That's wrong. d_make_root() drops the reference to the inode on
> failure itself, and so the change in 48fde701 is correct and valid.
> 
> The leak on bad inodes (which, AFAICT, can never happen on XFS) has
> been around a lot longer than Al's change - this commit introduced
> it:
> 
> 	2bcf6e9 xfs: start periodic workers later
> 
> with this hunk:
> 
>         if (is_bad_inode(root)) {
>                 error = EINVAL;
> -               goto fail_vnrele;
> +               goto out_syncd_stop;
>         }

Thanks Gents.  Here's another try:

xfs: don't leak root inode reference

Looks like in 2bcf6e9 we removed the iput of the root inode in
xfs_fs_fill_super for the is_bad_inode error case.  Add it back.

Signed-off-by: Ben Myers <bpm@sgi.com>

---

 fs/xfs/xfs_super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_super.c
===================================================================
--- a/fs/xfs/xfs_super.c	2013-08-26 15:43:55.530817462 -0500
+++ b/fs/xfs/xfs_super.c	2013-08-27 16:20:50.100857436 -0500
@@ -1493,7 +1493,7 @@ xfs_fs_fill_super(
 	}
 	if (is_bad_inode(root)) {
 		error = EINVAL;
-		goto out_unmount;
+		goto out_iput;
 	}
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {
@@ -1519,6 +1519,8 @@ out_destroy_workqueues:
  out:
 	return -error;
 
+ out_iput:
+	iput(root);
  out_unmount:
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
