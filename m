Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 89F727CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 16:53:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5BE7A304032
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 14:53:41 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GpOT4FNsrHogA9UU for <xfs@oss.sgi.com>;
	Thu, 26 May 2016 14:53:37 -0700 (PDT)
Date: Fri, 27 May 2016 07:53:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: Propagate dentry down to inode_change_ok()
Message-ID: <20160526215304.GO21200@dastard>
References: <1464279600-13009-1-git-send-email-jack@suse.cz>
	<1464279600-13009-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1464279600-13009-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, xfs@oss.sgi.com, Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, May 26, 2016 at 06:19:56PM +0200, Jan Kara wrote:
> To avoid clearing of capabilities or security related extended
> attributes too early, inode_change_ok() will need to take dentry instead
> of inode. Propagate dentry down to functions calling inode_change_ok().
> This is rather straightforward except for xfs_set_mode() function which
> does not have dentry easily available. Luckily that function does not
> call inode_change_ok() anyway so we just have to do a little dance with
> function prototypes.

The idea behind the change is good, but I think the little dance
could be improved as it makes the layering of the code seem weirdly
unbalanced to me. e.g.

xfs_vn_setattr()
  xfs_vn_setattr_size()		<<<< inode_change_ok() here

xfs_vn_setattr()
  xfs_vn_setattr_nonsize()	<<<< inode_change_ok() here
    xfs_setattr_nonsize()

xfs_vn_setattr()
  xfs_vn_setattr_size()
    xfs_vn_setattr_nonsize()	<<<< inode_change_ok() here
      xfs_setattr_nonsize()

And to be more confusing, the externally callable functions for the
rest of the XFS code are now xfs_vn_setattr_size() and
xfs_setattr_nonsize() which now have different calling context
limitations.

I think adding a little symmetric make sense. i.e:

xfs_vn_change_ok(dentry, iattr)
{
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return -EROFS;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	error = inode_change_ok(inode, iattr);
+	if (error)
+		return error;
+
}

xfs_vn_setattr_size(d, i)
{
	xfs_vn_change_ok(d, i)
	xfs_setattr_size(ip, i)
}

xfs_vn_setattr_nonsize(d, i)
{
	xfs_vn_change_ok(d, i)
	xfs_setattr_nonsize(ip, i)
}

xfs_vn_setattr(d, i)
{
	xfs_vn_change_ok(d, i)
	<rest of xfs_vn_setattr unchanged>
}

And remove the inode_change_ok() code from xfs_setattr_size and
xfs_setattr_nonsize() completely.  You've already done this with
xfs_vn_setattr_nonsize() - it just needs to be made symmetric to
keep a clean layering between VFS interfaces and internal XFS
interfaces...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
