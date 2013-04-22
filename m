Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E90937F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 14:59:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D42768F8092
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 12:59:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KHd4H9bezLZD6Cxi for <xfs@oss.sgi.com>;
	Mon, 22 Apr 2013 12:59:54 -0700 (PDT)
Message-ID: <517596BA.3060408@sandeen.net>
Date: Mon, 22 Apr 2013 14:59:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
References: <516C89DF.4070904@redhat.com>
In-Reply-To: <516C89DF.4070904@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: yongtaofu@gmail.com, xfs@oss.sgi.com

On 4/15/13 6:14 PM, Brian Foster wrote:
> Hi,
> 
> Thanks for the data in the previous thread:
> 
> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
> 
> I'm spinning off a new thread specifically for this because the original
> thread is already too large and scattered to track. As Eric stated,
> please try to keep data contained in as few messages as possible.
> 

Well, it's always simple in the end.  It just took a lot of debugging
to figure out what was happening - we do appreciate your help with that!

We were able to create a local reproducer, and it looks like
this patch fixes things:

commit aae8a97d3ec30788790d1720b71d76fd8eb44b73
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Sat Jan 29 18:43:27 2011 +0530

    fs: Don't allow to create hardlink for deleted file
    
    Add inode->i_nlink == 0 check in VFS. Some of the file systems
    do this internally. A followup patch will remove those instance.
    This is needed to ensure that with link by handle we don't allow
    to create hardlink of an unlinked file. The check also prevent a race
    between unlink and link
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/namei.c b/fs/namei.c
index 83e92ba..33be51a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2906,7 +2906,11 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 		return error;
 
 	mutex_lock(&inode->i_mutex);
-	error = dir->i_op->link(old_dentry, dir, new_dentry);
+	/* Make sure we don't allow creating hardlink to an unlinked file */
+	if (inode->i_nlink == 0)
+		error =  -ENOENT;
+	else
+		error = dir->i_op->link(old_dentry, dir, new_dentry);
 	mutex_unlock(&inode->i_mutex);
 	if (!error)
 		fsnotify_link(dir, inode, new_dentry);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
