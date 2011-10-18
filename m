Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9I09hpr032921 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 19:09:43 -0500
Received: from e31.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E19C61C87ED1
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 17:09:42 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id RG45oBEgKekCIvoN for
	<xfs@oss.sgi.com>; Mon, 17 Oct 2011 17:09:42 -0700 (PDT)
Received: from /spool/local by us.ibm.com with XMail ESMTP
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 17 Oct 2011 18:09:42 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9I09XDM158088 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 18:09:33 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p9I09Xkk029606
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 18:09:33 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 17 Oct 2011 19:09:32 -0500
Message-Id: <20111018000932.14942.11597.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC PATCH 0/3] Allow pquota and gquota to be used together
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Hello All,

Few weeks back I asked for some work on XFS. Christoph suggested
me to make changes to allow pquota and gquota to be used
simultaneously in a filesystem.

All the xfs quota tests ran successfully. Currently running
the full suite.

I am currently working on the user space changes. In the mean
while I wanted to get some feedback on it.

Here are the changes. 

These changes expect the pquotino to be already present in the
disk with a version bit. IOW, only mkfs has the ability to 
create a filesystem with this specific information.

Also, when older superblocks are read, it will be written back
the same way. i.e, no semantic change to the superblock.

1. Expand the on disk XFS_OQUOTA_* to in core XFS_GQUOTA_.* and
   XFS_PQUOTA_.*. But always store as XFS_OQUOTA_.* on disk.

2. Wherever gquota is used, introduce pquota, simply by way of
   defining a macro for pquota(This is to make the changes
   simple and easy to follow).

3. Start using a new field pquotino in on-disk super block, when
   an appropriate version bit is set.

Thanks & Regards,

chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
