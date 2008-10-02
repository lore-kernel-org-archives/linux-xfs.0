Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Oct 2008 08:53:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m92Fr8GV008694
	for <xfs@oss.sgi.com>; Thu, 2 Oct 2008 08:53:09 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A30D4A682D
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2008 08:54:46 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id WdhNA8BxYKRDh9PJ for <xfs@oss.sgi.com>; Thu, 02 Oct 2008 08:54:46 -0700 (PDT)
Message-ID: <48E4EEBC.70105@sandeen.net>
Date: Thu, 02 Oct 2008 10:54:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Which XFS-options for best performance in my case?
References: <001d01c92498$a4bd7b40$ee3871c0$@net>
In-Reply-To: <001d01c92498$a4bd7b40$ee3871c0$@net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tom <T-o-m@gmx.net>
Cc: xfs@oss.sgi.com

Tom wrote:

> After having fine tuned the RAID-controller and the kernel settings, I am
> reaching the following results: Read 465 MB/s; Write 296 MB/s, which I
> benchmarked with "sync; bonnie++ -u 0 -r 4096 -b -d
> /name_of_the_mounted_partition". These figures are not all to good.

not good based on / compared to what?

First I'd start with direct reads & writes from/to your block device,
see how fast that goes, before you jump up to benchmarking the filesystem.

-Eric
