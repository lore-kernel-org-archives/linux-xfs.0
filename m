Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED54D7F6B
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:39:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9D178F8040
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 16:39:55 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CaArk0XUnRXeU2N7 for <xfs@oss.sgi.com>;
	Sun, 11 Oct 2015 16:39:53 -0700 (PDT)
Date: Mon, 12 Oct 2015 10:37:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v10 23/46] xfs: Make xfs_set_mode non-static
Message-ID: <20151011233740.GZ27164@dastard>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-24-git-send-email-andreas.gruenbacher@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444604337-17651-24-git-send-email-andreas.gruenbacher@gmail.com>
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
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Mon, Oct 12, 2015 at 12:58:34AM +0200, Andreas Gruenbacher wrote:
> From: Andreas Gruenbacher <agruenba@redhat.com>
> 
> Make xfs_set_mode non-static and move it from xfs_acl.c into xfs_inode.c.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
.....
> +++ b/fs/xfs/xfs_inode.c
> @@ -3587,3 +3587,21 @@ xfs_iflush_int(
>  corrupt_out:
>  	return -EFSCORRUPTED;
>  }
> +
> +int
> +xfs_set_mode(struct inode *inode, umode_t mode)
> +{
> +	int error = 0;
> +
> +	if (mode != inode->i_mode) {
> +		struct iattr iattr;
> +
> +		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
> +		iattr.ia_mode = mode;
> +		iattr.ia_ctime = current_fs_time(inode->i_sb);
> +
> +		error = xfs_setattr_nonsize(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
> +	}
> +
> +	return error;
> +}

Now needs a comment to explain that this function has a special
"called only from ACL modification" context associated with it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
