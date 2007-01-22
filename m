Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Jan 2007 23:59:02 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0M7wtqw012650
	for <xfs@oss.sgi.com>; Sun, 21 Jan 2007 23:58:56 -0800
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l0M7w0AW002165
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 16:58:00 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.195])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l0M7sd8I029066
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 16:54:39 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l0M7scd17409 for xfs@oss.sgi.com; Mon, 22 Jan 2007 16:54:38 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l0M7scp12576 for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 16:54:38 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070122.165438.07803072 for <xfs@oss.sgi.com>
	; Mon, 22 Jan 2007 16:54:38 +0900
Message-Id: <200701220754.AA04898@TNESG9305.tnes.nec.co.jp>
Date: Mon, 22 Jan 2007 16:54:30 +0900
Subject: [PATCH]segmentation fault in xfs_io mwrite command #2
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

My previous patch is not enough.
If mmap offset is not 0, segmentation fault occurs in mwrite.
This patch fixes it.

Example:
# xfs_io -f file7 -c "mmap 4096 4096" -c "mwrite"
Segmentation fault

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.18-orgn/io/mmap.c      2006-12-13 13:57:22.000000000 +0900
+++ xfsprogs-2.8.18/io/mmap.c   2007-01-19 16:29:44.000000000 +0900
@@ -562,6 +562,7 @@ mwrite_f(
        if (!start)
                return 0;

+       offset -= mapping->offset;
        if (rflag) {
                for (tmp = offset + length -1; tmp >= offset; tmp--)
                        ((char *)mapping->addr)[tmp] = seed;
