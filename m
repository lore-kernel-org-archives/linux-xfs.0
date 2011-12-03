Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB39uM7r135609
	for <linux-xfs@oss.sgi.com>; Sat, 3 Dec 2011 03:56:22 -0600
Received: from snt0-omc1-s1.snt0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00F381DC1082
	for <linux-xfs@oss.sgi.com>; Sat,  3 Dec 2011 01:56:20 -0800 (PST)
Received: from snt0-omc1-s1.snt0.hotmail.com (snt0-omc1-s1.snt0.hotmail.com
	[65.55.90.12]) by cuda.sgi.com with ESMTP id TZowEhhqSSxN1Bla
	for <linux-xfs@oss.sgi.com>; Sat, 03 Dec 2011 01:56:20 -0800 (PST)
Message-ID: <SNT135-W2217EB3D3B80A8433A1FA4A4B70@phx.gbl>
From: yangguoquan <ygq51@hotmail.com>
Subject: RE: xfs: validate inode numbers in file handles correctly
Date: Sat, 3 Dec 2011 17:56:20 +0800
In-Reply-To: <20111128111947.GA26454@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>,
	<loom.20111123T134243-580@post.gmane.org>,
	<20111123143045.GA20892@infradead.org>,
	<20111128111947.GA26454@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7069028250435374666=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org
Cc: linux-xfs@oss.sgi.com, pengxihan@gmail.com

--===============7069028250435374666==
Content-Type: multipart/alternative;
	boundary="_e3468a2b-b822-49b5-8ffc-5bc5da83b11e_"

--_e3468a2b-b822-49b5-8ffc-5bc5da83b11e_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit


I have tried this patch, And problem resolved!
Thank you for your help!

 

> Date: Mon, 28 Nov 2011 06:19:47 -0500
> From: hch@infradead.org
> To: ygq51@hotmail.com
> Subject: Re: xfs: validate inode numbers in file handles correctly
> CC: linux-xfs@oss.sgi.com; pengxihan@gmail.com
> 
> Guoquan and hank,
> 
> are you using 32-bit or 64-bit kernels? I just noticed we have a
> problem with exporting 64-bit inodes on 32-bit kernel because the
> VFS i_ino field is just 32-bits long. The patch below would fix
> that issue.
> 
> --- xfs.orig/fs/xfs/linux-2.6/xfs_export.c 2011-11-28 12:11:08.923630697 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_export.c 2011-11-28 12:13:21.766244360 +0100
> @@ -61,6 +61,8 @@ xfs_fs_encode_fh(
> struct fid *fid = (struct fid *)fh;
> struct xfs_fid64 *fid64 = (struct xfs_fid64 *)fh;
> struct inode *inode = dentry->d_inode;
> + struct inode *parent;
> + struct xfs_inode *ip = XFS_I(inode);
> int fileid_type;
> int len;
> 
> @@ -98,22 +100,24 @@ xfs_fs_encode_fh(
> switch (fileid_type) {
> case FILEID_INO32_GEN_PARENT:
> spin_lock(&dentry->d_lock);
> - fid->i32.parent_ino = dentry->d_parent->d_inode->i_ino;
> - fid->i32.parent_gen = dentry->d_parent->d_inode->i_generation;
> + parent = dentry->d_parent->d_inode;
> + fid->i32.parent_ino = XFS_I(parent)->i_ino;
> + fid->i32.parent_gen = parent->i_generation;
> spin_unlock(&dentry->d_lock);
> /*FALLTHRU*/
> case FILEID_INO32_GEN:
> - fid->i32.ino = inode->i_ino;
> + fid->i32.ino = ip->i_ino;
> fid->i32.gen = inode->i_generation;
> break;
> case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
> spin_lock(&dentry->d_lock);
> - fid64->parent_ino = dentry->d_parent->d_inode->i_ino;
> - fid64->parent_gen = dentry->d_parent->d_inode->i_generation;
> + parent = dentry->d_parent->d_inode;
> + fid64->parent_ino = XFS_I(parent)->i_ino;
> + fid64->parent_gen = parent->i_generation;
> spin_unlock(&dentry->d_lock);
> /*FALLTHRU*/
> case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
> - fid64->ino = inode->i_ino;
> + fid64->ino = ip->i_ino;
> fid64->gen = inode->i_generation;
> break;
> }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
 		 	   		  
--_e3468a2b-b822-49b5-8ffc-5bc5da83b11e_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: 8bit

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
font-size: 10pt;
font-family:Î¢ÈíÑÅºÚ
}
--></style>
</head>
<body class='hmmessage'><div dir='ltr'>
I have tried this patch, And problem resolved!<BR>
Thank you for your help!<BR>
<BR>&nbsp;<BR>
<DIV>
&gt; Date: Mon, 28 Nov 2011 06:19:47 -0500<BR>&gt; From: hch@infradead.org<BR>&gt; To: ygq51@hotmail.com<BR>&gt; Subject: Re: xfs: validate inode numbers in file handles correctly<BR>&gt; CC: linux-xfs@oss.sgi.com; pengxihan@gmail.com<BR>&gt; <BR>&gt; Guoquan and hank,<BR>&gt; <BR>&gt; are you using 32-bit or 64-bit kernels? I just noticed we have a<BR>&gt; problem with exporting 64-bit inodes on 32-bit kernel because the<BR>&gt; VFS i_ino field is just 32-bits long. The patch below would fix<BR>&gt; that issue.<BR>&gt; <BR>&gt; --- xfs.orig/fs/xfs/linux-2.6/xfs_export.c 2011-11-28 12:11:08.923630697 +0100<BR>&gt; +++ xfs/fs/xfs/linux-2.6/xfs_export.c 2011-11-28 12:13:21.766244360 +0100<BR>&gt; @@ -61,6 +61,8 @@ xfs_fs_encode_fh(<BR>&gt; struct fid *fid = (struct fid *)fh;<BR>&gt; struct xfs_fid64 *fid64 = (struct xfs_fid64 *)fh;<BR>&gt; struct inode *inode = dentry-&gt;d_inode;<BR>&gt; + struct inode *parent;<BR>&gt; + struct xfs_inode *ip = XFS_I(inode);<BR>&gt; int fileid_
 type;<BR>&gt; int len;<BR>&gt; <BR>&gt; @@ -98,22 +100,24 @@ xfs_fs_encode_fh(<BR>&gt; switch (fileid_type) {<BR>&gt; case FILEID_INO32_GEN_PARENT:<BR>&gt; spin_lock(&amp;dentry-&gt;d_lock);<BR>&gt; - fid-&gt;i32.parent_ino = dentry-&gt;d_parent-&gt;d_inode-&gt;i_ino;<BR>&gt; - fid-&gt;i32.parent_gen = dentry-&gt;d_parent-&gt;d_inode-&gt;i_generation;<BR>&gt; + parent = dentry-&gt;d_parent-&gt;d_inode;<BR>&gt; + fid-&gt;i32.parent_ino = XFS_I(parent)-&gt;i_ino;<BR>&gt; + fid-&gt;i32.parent_gen = parent-&gt;i_generation;<BR>&gt; spin_unlock(&amp;dentry-&gt;d_lock);<BR>&gt; /*FALLTHRU*/<BR>&gt; case FILEID_INO32_GEN:<BR>&gt; - fid-&gt;i32.ino = inode-&gt;i_ino;<BR>&gt; + fid-&gt;i32.ino = ip-&gt;i_ino;<BR>&gt; fid-&gt;i32.gen = inode-&gt;i_generation;<BR>&gt; break;<BR>&gt; case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:<BR>&gt; spin_lock(&amp;dentry-&gt;d_lock);<BR>&gt; - fid64-&gt;parent_ino = dentry-&gt;d_parent-&gt;d_inode-&gt;i_ino;<BR>&gt; - fid64-&gt;parent_gen =
  
 dentry-&gt;d_parent-&gt;d_inode-&gt;i_generation;<BR>&gt; + parent = dentry-&gt;d_parent-&gt;d_inode;<BR>&gt; + fid64-&gt;parent_ino = XFS_I(parent)-&gt;i_ino;<BR>&gt; + fid64-&gt;parent_gen = parent-&gt;i_generation;<BR>&gt; spin_unlock(&amp;dentry-&gt;d_lock);<BR>&gt; /*FALLTHRU*/<BR>&gt; case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:<BR>&gt; - fid64-&gt;ino = inode-&gt;i_ino;<BR>&gt; + fid64-&gt;ino = ip-&gt;i_ino;<BR>&gt; fid64-&gt;gen = inode-&gt;i_generation;<BR>&gt; break;<BR>&gt; }<BR>&gt; <BR>&gt; _______________________________________________<BR>&gt; xfs mailing list<BR>&gt; xfs@oss.sgi.com<BR>&gt; http://oss.sgi.com/mailman/listinfo/xfs<BR></DIV> 		 	   		  </div></body>
</html>
--_e3468a2b-b822-49b5-8ffc-5bc5da83b11e_--


--===============7069028250435374666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7069028250435374666==--
