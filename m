Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 18:47:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2A1kmX0020563
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 18:46:50 -0700
Received: from mail.g-house.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF137F4DF52
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2008 18:47:18 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75]) by cuda.sgi.com with ESMTP id GK1F8vBT0BIl4aV8 for <xfs@oss.sgi.com>; Sun, 09 Mar 2008 18:47:18 -0700 (PDT)
Date: Mon, 10 Mar 2008 02:46:38 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
In-Reply-To: <20080309213441.GQ155407@sgi.com>
Message-ID: <alpine.DEB.1.00.0803100235230.9443@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com

On Mon, 10 Mar 2008, David Chinner wrote:
> Oh, dm-crypt. Well, I'd definitely start looking there. XFS has a
> history of exposing dm-crypt bugs, and these hangs appear to be I/O
> congestion/scheduling related and not XFS.

Yeah, I noticed that too, thanks for verifying this: during the 2nd bisect 
run, the box locked up hard when I accessed the device-mapper. I'm using a 
wrapper script to set up my luks/dm-crypt devices and still have to find 
out which command exactly triggers the lockup. So, maybe the hard lockup 
and the hangs are not so unrelated after all...oh well.

> Also, we haven't changed
> anything related to plug/unplug of block devices in XFS recently, so
> that also points to some other change as well...

Thanks for your assistance, David, I really appreciate it. I'll try to 
find out more about this dm-crypt thingy....

Christian.
-- 
BOFH excuse #396:

Mail server hit by UniSpammer.
