Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5AD17F47
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 01:34:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E5F2AC003
	for <xfs@oss.sgi.com>; Sun, 17 May 2015 23:34:22 -0700 (PDT)
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130]) by
	cuda.sgi.com with ESMTP id N6gE5WgUKQ8iZ0nr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 May 2015 23:34:19 -0700 (PDT)
Message-ID: <555987A2.3050604@foxmail.com>
Date: Mon, 18 May 2015 14:33:06 +0800
From: Wang Sheng-Hui <shhuiw@foxmail.com>
MIME-Version: 1.0
Subject: xfsprogs/mkfs: what's the relationship between max trans res and
	min log size
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>

Hi guys,


In maxtrres.c/max_trans_res, it calls xfs_log_calc_minimum_size to compute the
              maximum transaction reservation

But for xfs_log_calc_minimum_size, it's used to calculate the
              minimum valid log size


The naming max/minimum seems confusing.

Why are they named in such way? What's the relationship between max trans res
and minimun log size, (max trans res) <= (minimun log size)?


Any explanations are welcomed!


Thanks,
Sheng-Hui


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
