Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7CAkEKY206801 for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 05:46:14 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6F1D4AE8BB
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 03:46:36 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id lUXRjlGjIBkoRCIP
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 03:46:36 -0700 (PDT)
Received: by bwz4 with SMTP id 4so544130bwz.26
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 03:46:36 -0700 (PDT)
From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Re: observed significant performance improvement using "delaylog" in
Date: Thu, 12 Aug 2010 13:46:30 +0300
MIME-Version: 1.0
Message-Id: <201008121346.30760.eye.of.the.8eholder@gmail.com>
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

> I'm pleased to state that using the experimental "delaylog" mount option 
> (in vanilla linux-2.6.35) we measured a 17% performance increase
> for our benchmark scenario. (Other mount-options in use both before
> and after the "delaylog" option: noatime,nodiratime,nobarrier)

> That's a lot given that XFS was the fastest performing file-system
> for this application already.

> So thanks to all contributing developers for this significant optimization!

I did a benchmark (a simple copy/untar not something fancy) some time ago
and also noticed great improvement.

Here is my post with the results of the benchmark.
http://lordkhelben.wordpress.com/2010/07/08/xfs-delayed-logging/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
