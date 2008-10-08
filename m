Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 12:43:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m98Jh87I020064
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 12:43:09 -0700
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F3514CE413
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 12:44:47 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id C1a56RlBM6gZvoY5 for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 12:44:47 -0700 (PDT)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by ishtar.tlinx.org (8.14.1/8.12.10/SuSE Linux 0.7) with ESMTP id m98JifEX009043
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 12:44:42 -0700
Message-ID: <48ED0DA9.7070002@tlinx.org>
Date: Wed, 08 Oct 2008 12:44:41 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfsaild centisecs /proc wakeup control?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

I was looking at powertop again recently, and noticed xfsbufd and xfsaild at the top
of the wakeup list. 
xfsbufd can be tuned with /proc/sys/fs/xfs/xfsbufd_centisecs along with 3 other
time-related tunables.  However, I don't see one for xfsaild.  Is that an oversight?
