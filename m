Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Sep 2006 08:17:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8SFHDaG001619
	for <linux-xfs@oss.sgi.com>; Thu, 28 Sep 2006 08:17:14 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2850A462FC9
	for <linux-xfs@oss.sgi.com>; Thu, 28 Sep 2006 08:16:33 -0700 (PDT)
Message-ID: <451BE74F.3030205@sandeen.net>
Date: Thu, 28 Sep 2006 10:16:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: about performace
References: <20060928065113.70796.qmail@web8511.mail.in.yahoo.com>
In-Reply-To: <20060928065113.70796.qmail@web8511.mail.in.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nagesh kollu <nagesh_20k@yahoo.co.in>
Cc: linux-xfs@oss.sgi.com

nagesh kollu wrote:
> hi,,
>   i'm new to xfs ..i want to know the performance details of xfs..
>   how much time it will take to write /read ...can anyone done this on ARM processor...the block size is 2^n only in xfs ..but for video streaming the incoming packet is 188 bytes .the sector size is 512 ...so the i/o buffer size is 188*512 ...how can we do this in xfs....cany anyone send the xfs performance details..

It sounds like you have a very specific environment that would be best
tested and evaluated by... you :)

Yes, the blocksizes are powers of two, but of course you can do any
arbitrary sized write, if that's what you're asking.

-Eric
