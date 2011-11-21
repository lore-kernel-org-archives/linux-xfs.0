Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALD0xhv261030
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 07:00:59 -0600
Received: from mail-yw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AC091D23342
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 05:00:58 -0800 (PST)
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id ZZgXquEa01STmcrE
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 05:00:58 -0800 (PST)
Received: by ywp18 with SMTP id 18so6171644ywp.26
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 05:00:58 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 21:00:57 +0800
Message-ID: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
Subject: stale NFS file handle problem on XFS inode64
From: hank peng <pengxihan@gmail.com>
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
To: linux-xfs@oss.sgi.com

Hi:
I have a 4TB XFS filesystem mounted with "inode64" option, and I
exported it using NFS v3, on NFS client, I entered a subdirectory and
got "stale NFS file handle" error.
ls -il showed that its inode number exceed 32 bit limit.
NFS server: kernel version is 2.6.35.6
NFS client: kernel version is 2.6.18

Any ideas on how to deal with this problem?

-- 
The simplest is not all best but the best is surely the simplest!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
