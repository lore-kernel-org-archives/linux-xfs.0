Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6T7h1MS033918 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 02:43:01 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1E1CA29FB
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 00:43:00 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id dxmfK34XNCdM4UDR
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 00:43:00 -0700 (PDT)
Received: by vws13 with SMTP id 13so3040403vws.26
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 00:43:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110728145020.GA30785@infradead.org>
References: <CAB4K4y6-2odbRhqn6q7ZDOxqF9oUcj2zKvyCEV6374QGyM-ddA@mail.gmail.com>
	<20110728145020.GA30785@infradead.org>
Date: Fri, 29 Jul 2011 13:12:59 +0530
Message-ID: <CAB4K4y4Ns5woUJyPv_NuW0GYSb5ZcFkqnF-DxRB1MESibc1Knw@mail.gmail.com>
Subject: Re: "xfs: fix error handling for synchronous writes" revisited
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

xfs: fix for hang during synchronous buffer write error

If removed storage while synchronous buffer write underway,
"xfslogd" hangs.

Detailed log http://oss.sgi.com/archives/xfs/2011-07/msg00740.html

Related work bfc60177f8ab509bc225becbb58f7e53a0e33e81
"xfs: fix error handling for synchronous writes"

Given that xfs_bwrite actually does the shutdown already after
waiting for the b_iodone completion and given that we actually
found that calling xfs_force_shutdown from inside
xfs_buf_iodone_callbacks was a major contributor the problem
it better to drop this call.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>

diff -Nurp -X linux/Documentation/dontdiff linux/fs/xfs/xfs_buf_item.c
linux-Dirty/fs/xfs/xfs_buf_item.c
--- linux/fs/xfs/xfs_buf_item.c 2011-06-09 10:05:18.000000000 +0530
+++ linux-Dirty/fs/xfs/xfs_buf_item.c   2011-07-28 15:53:51.000000000 +0530
@@ -1028,7 +1028,6 @@ xfs_buf_iodone_callbacks(
        XFS_BUF_UNDELAYWRITE(bp);

        trace_xfs_buf_error_relse(bp, _RET_IP_);
-       xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);

 do_callbacks:
        xfs_buf_do_callbacks(bp, lip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
