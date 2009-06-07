Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n57Itdrh184660
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 13:55:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 918762DA993
	for <linux-xfs@oss.sgi.com>; Sun,  7 Jun 2009 11:55:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Kqg1jZZCvqfJmgoC for
	<linux-xfs@oss.sgi.com>; Sun, 07 Jun 2009 11:55:59 -0700 (PDT)
Date: Sun, 7 Jun 2009 14:55:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Message-ID: <20090607185558.GA753@infradead.org>
References: <20090520003745.GA27491@samad.com.au>
	<20090604112657.GA10738@infradead.org>
	<h0gtcd$136u$1@osprey.mgras.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <h0gtcd$136u$1@osprey.mgras.de>
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
To: Martin Spott <Martin.Spott@mgras.net>
Cc: linux-xfs@oss.sgi.com

On Sun, Jun 07, 2009 at 05:28:45PM +0000, Martin Spott wrote:
> reconnect_path: npd != pd
> reconnect_path: npd != pd
> reconnect_path: npd != pd
> [...]
> 
> 
> ....  I'm unable to find any helpful information in this context.
> Anything I could try - this sunday evening ?

That warning is what really makes me freak out, as it really, really
shouldn't happen.  Can you see if it gives any additional useful output
with the patch below?


Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c	2009-06-07 20:40:09.085814403 +0200
+++ linux-2.6/fs/exportfs/expfs.c	2009-06-07 20:54:47.550942377 +0200
@@ -88,6 +88,14 @@ find_disconnected_root(struct dentry *de
 	return dentry;
 }
 
+static void dump_dentry(struct dentry *dentry, const char *var)
+{
+	printk("%s: dentry 0x%p inode 0x%p ino %lld name %s\n",
+		var, dentry, dentry->d_inode,
+		dentry->d_inode ?
+			(unsigned long long)dentry->d_inode->i_ino : 0,
+		dentry->d_name.name);
+}
 
 /*
  * Make sure target_dir is fully connected to the dentry tree.
@@ -187,8 +195,11 @@ reconnect_path(struct vfsmount *mnt, str
 			 */
 			if (npd == pd)
 				noprogress = 0;
-			else
+			else {
 				printk("%s: npd != pd\n", __func__);
+				dump_dentry(npd, "npd");
+				dump_dentry(pd, "pd");
+			}
 			dput(npd);
 			dput(ppd);
 			if (IS_ROOT(pd)) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
