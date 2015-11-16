Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 185517F54
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 02:43:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05D338F8033
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 00:43:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5hYBjKjBv2MwuiTE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 00:43:34 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 0D8F48EFDA
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 08:43:33 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAG8hVmi008258
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 03:43:32 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2] xfs_io: implement inode command
Date: Mon, 16 Nov 2015 09:43:22 +0100
Message-Id: <1447663404-7857-1-git-send-email-cmaiolino@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Implement xfs_io inode command, which can be used to retreive information about
allocated inodes in a xfs filesystem.

Carlos Maiolino (2):
  xfs_io: implement 'inode' command V4
  xfs_io: inode command manpage V1

 io/open.c         | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |  24 +++++++++
 2 files changed, 175 insertions(+)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
