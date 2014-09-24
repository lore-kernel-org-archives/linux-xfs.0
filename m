Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 814757F4E
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 03:57:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60D62304039
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 01:57:34 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id IkcHB3CGRDXlohY4 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 01:57:27 -0700 (PDT)
Date: Wed, 24 Sep 2014 10:57:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Fix mmap data corruption when blocksize <
	pagesize
Message-ID: <20140924085724.GA21864@quack.suse.cz>
References: <1411484603-17756-1-git-send-email-jack@suse.cz>
	<1411484603-17756-3-git-send-email-jack@suse.cz>
	<20140924084519.GA21987@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20140924084519.GA21987@quack.suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, linux-mm@kvack.org, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 24-09-14 10:45:19, Jan Kara wrote:
> On Tue 23-09-14 17:03:23, Jan Kara wrote:
> > Use block_create_hole() when hole is being created in a file so that
> > ->page_mkwrite() will get called for the partial tail page if it is
> > mmaped (see the first patch in the series for details).
>   Just out of curiosity I did a change similar to this one for ext4 to XFS
> and indeed it fixed generic/030 test failures for XFS with blocksize 1k.
  Just for reference attached the patch I was testing - I can resend with
proper changelog etc. if people are fine with this approach.

								Honza

> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/inode.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 3aa26e9117c4..fdcb007c2c9e 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4536,8 +4536,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
> >  				ext4_orphan_del(NULL, inode);
> >  				goto err_out;
> >  			}
> > -		} else
> > +		} else {
> > +			loff_t old_size = inode->i_size;
> > +
> >  			i_size_write(inode, attr->ia_size);
> > +			block_create_hole(inode, old_size, inode->i_size);
> > +		}
> >  
> >  		/*
> >  		 * Blocks are going to be removed from the inode. Wait
> > -- 
> > 1.8.1.4
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--MGYHOYXEY6WxJCY8
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-xfs-Fix-mmap-data-corruption.patch"

>From ceedc36b1c99c25ebb55c88f6ab059347b52f4ec Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 24 Sep 2014 10:18:25 +0200
Subject: [PATCH] xfs: Fix mmap data corruption

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 72129493e9d3..19ce64bfb4f7 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -848,6 +848,8 @@ xfs_setattr_size(
 	if (error)
 		return error;
 	truncate_setsize(inode, newsize);
+	if (oldsize < newsize)
+		block_create_hole(inode, oldsize, newsize);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
-- 
1.8.1.4


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--MGYHOYXEY6WxJCY8--
