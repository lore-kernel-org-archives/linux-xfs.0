Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1K2Jrb7052045 for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 20:19:54 -0600
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E10C61DD5B04
	for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 18:22:35 -0800 (PST)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id ppCFxe2GvovykecP
	for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 18:22:35 -0800 (PST)
Received: by vws8 with SMTP id 8so3056436vws.26
	for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 18:22:34 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 20 Feb 2011 11:22:34 +0900
Message-ID: <AANLkTindiB_D7shZKkrdkePM=xaAXCe1HAX5tPy87SCy@mail.gmail.com>
Subject: First 128KB of XFS partition is NULL.
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
To: xfs@oss.sgi.com

Dear All,
I have received a corrupted disk from team testing XFS, when I look
hexdump of partiton. Its 0000 in first 128KB.
Our kernel is 2.6.30.9 however we have backported XFS from 2.6.34,
Arch MIP with VIPT cache.
This arch previously had many issues but after properly implementing
"xfs: fix xfs to work with Virtually Indexed architectures " most
problem resolved.

Can anyone make guess in what case first 128KB may become NULL, I seem
to be impossible because file system does not modify all 128KB at the
begining of partition at once.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
