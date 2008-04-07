Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 14:25:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m37LO5JZ028236
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 14:24:09 -0700
Received: from fed1rmmtao107.cox.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E2EE95F98C
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2008 14:24:42 -0700 (PDT)
Received: from fed1rmmtao107.cox.net (fed1rmmtao107.cox.net [68.230.241.39]) by cuda.sgi.com with ESMTP id 4l7ZGHRa2NNfKFsQ for <xfs@oss.sgi.com>; Mon, 07 Apr 2008 14:24:42 -0700 (PDT)
Received: from fed1rmimpo02.cox.net ([70.169.32.72])
          by fed1rmmtao107.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20080407212443.LMSL6668.fed1rmmtao107.cox.net@fed1rmimpo02.cox.net>
          for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 17:24:43 -0400
Received: from shin (unknown [192.168.0.199])
	by meru.bbky.org (Postfix) with ESMTP id 2AEC61C025C80
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2008 14:24:42 -0700 (PDT)
From: "Bond Masuda" <bond.masuda@jlbond.com>
Subject: performance problems with XFS and Linux kernel 2.6.24.4
Date: Mon, 7 Apr 2008 14:24:41 -0700
Message-ID: <007001c898f5$cae2f4a0$60a8dde0$@masuda@jlbond.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I am aware of the change regarding barrier/nobarrier in 2.6.17 and above.
However, the performance hit I'm seeing is very severe and much worse than
what I was seeing in 2.6.17 (bundled with latest updates in Fedora Core 4).

I'm currently running Fedora 8 with 2.6.24.4-64.fc8. If I remove nobarrier
mount option, it takes seconds just to write few megabytes and the system
becomes very very sluggish. On 2.6.17 (Fedora 4) without the nobarrier
option it was still usable.

The XFS file system is about 900GB, if that matters.

Is this a known problem? How can I gather more information to figure out
exactly what is going on?

Thanks,
-Bond
