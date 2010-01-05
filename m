Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o050lXP9160693 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 18:47:33 -0600
Received: from radon.netxsys.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE8F7EC72D0
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 16:48:23 -0800 (PST)
Received: from radon.netxsys.com (radon.netxsys.com [204.16.202.162]) by
	cuda.sgi.com with ESMTP id PyfXqyV2LNNg9cbL for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2010 16:48:23 -0800 (PST)
Received: from [205.233.151.7] (Oxygen.NetXSys.Com [205.233.151.7])
	by radon.netxsys.com (Postfix) with ESMTP id 87F48C000091
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 19:48:22 -0500 (EST)
Subject: NFS export broke with change from ext3 to xfs
From: Krzysztof Adamski <k@adamski.org>
Date: Mon, 04 Jan 2010 19:48:20 -0500
Message-Id: <1262652500.24160.27.camel@oxygen.netxsys.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2490492035761663451=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2490492035761663451==
Content-Type: multipart/alternative; boundary="=-h5MnDdAbcldGztDVy+58"


--=-h5MnDdAbcldGztDVy+58
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi All,

I just changed one filesystem on my mythbox from ext3 to xfs, and now I
can't get a client machine to NFS mount from it.

This is the export file on the server:
/file-store/nfs-roots/f1/home
f1(rw,no_root_squash,sync,no_subtree_check)
/file-store/nfs-roots/f1/usr
f1(rw,no_root_squash,sync,no_subtree_check)
/file-store/nfs-roots/f1/var
f1(rw,no_root_squash,sync,no_subtree_check)

and on the client(f1) the three filesystems are mount on /home, /usr,
and /var

This worked fine when /file-store on the server was formatted with ext3,
now that it is formatted with xfs I get this message on the client:
mount.nfs: Stale NFS file handle
I get this message 3 times.
Nothing else changed, both systems are Debian Lenny with custom kernel.
Server is 2.6.28, client is 2.6.29.6. NFS is version 3.
The fstab on the server has this:
/dev/mapper/big--raid-file--store       /file-store     xfs
noatime,logbsize=256k,inode64   0       1

The reason for the change of the filesystem was an upgrade of the drives
in the RAID, now the filesystem is 7T instead of 2.4T, 
nothing else was changed. Why did this work with ext3 and does not with
XFS? What can I do to get this to work, short of reverting to ext3?

K

--=-h5MnDdAbcldGztDVy+58
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.18.3">
</HEAD>
<BODY>
Hi All,<BR>
<BR>
I just changed one filesystem on my mythbox from ext3 to xfs, and now I can't get a client machine to NFS mount from it.<BR>
<BR>
This is the export file on the server:<BR>
/file-store/nfs-roots/f1/home&nbsp;&nbsp; f1(rw,no_root_squash,sync,no_subtree_check)<BR>
/file-store/nfs-roots/f1/usr&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; f1(rw,no_root_squash,sync,no_subtree_check)<BR>
/file-store/nfs-roots/f1/var&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; f1(rw,no_root_squash,sync,no_subtree_check)<BR>
<BR>
and on the client(f1) the three filesystems are mount on /home, /usr, and /var<BR>
<BR>
This worked fine when /file-store on the server was formatted with ext3, now that it is formatted with xfs I get this message on the client:<BR>
mount.nfs: Stale NFS file handle<BR>
I get this message 3 times.<BR>
Nothing else changed, both systems are Debian Lenny with custom kernel.<BR>
Server is 2.6.28, client is 2.6.29.6. NFS is version 3.<BR>
The fstab on the server has this:<BR>
/dev/mapper/big--raid-file--store&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /file-store&nbsp;&nbsp;&nbsp;&nbsp; xfs&nbsp;&nbsp;&nbsp;&nbsp; noatime,logbsize=256k,inode64&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<BR>
<BR>
The reason for the change of the filesystem was an upgrade of the drives in the RAID, now the filesystem is 7T instead of 2.4T, <BR>
nothing else was changed. Why did this work with ext3 and does not with XFS? What can I do to get this to work, short of reverting to ext3?<BR>
<BR>
K
</BODY>
</HTML>

--=-h5MnDdAbcldGztDVy+58--


--===============2490492035761663451==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2490492035761663451==--
