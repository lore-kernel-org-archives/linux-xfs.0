Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4OKJ2cX083846 for <xfs@oss.sgi.com>; Thu, 24 May 2012 15:19:02 -0500
Received: from mail-qc0-f181.google.com (mail-qc0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	UOuX7HxiFlJnNMwr (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 May 2012 13:19:00 -0700 (PDT)
Received: by qcsk26 with SMTP id k26so174575qcs.26
	for <xfs@oss.sgi.com>; Thu, 24 May 2012 13:19:00 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 24 May 2012 16:18:59 -0400
Message-ID: <CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
From: Peter Watkins <treestem@gmail.com>
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
To: juergh@gmail.com
Cc: bpm@sgi.com, xfs@oss.sgi.com

Does your kernel have the effect of

0bf6a5bd4b55b466964ead6fa566d8f346a828ee xfs: convert the xfsaild
thread to a workqueue
c7eead1e118fb7e34ee8f5063c3c090c054c3820 xfs: revert to using a
kthread for AIL pushing

In particular, is this code in xfs_trans_ail_push:

       smp_wmb();
       xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn);
       smp_wmb();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
