Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Sep 2006 08:23:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8SFMvaG006953
	for <linux-xfs@oss.sgi.com>; Thu, 28 Sep 2006 08:22:58 -0700
Message-ID: <451BD844.4000509@melbourne.sgi.com>
Date: Fri, 29 Sep 2006 00:12:20 +1000
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
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

In general (no experience or suggestions for ARM processors), for video streaming:

- preallocate space for the files when writing, see xfsctl(3) and  XFS_IOC_RESVSP

- use direct I/O, the larger the better. ie a MB or more at a time,
  but at least ensure the direct I/O requests are aligned on page or
  filesystem block boundaries, whichever is larger

- use asynchronous I/O or multiple threads to keep the disks busy

David

nagesh kollu wrote:
> hi,,
>   i'm new to xfs ..i want to know the performance details of xfs..
>   how much time it will take to write /read ...can anyone done this on ARM processor...the block size is 2^n only in xfs ..but for video streaming the incoming packet is 188 bytes .the sector size is 512 ...so the i/o buffer size is 188*512 ...how can we do this in xfs....cany anyone send the xfs performance details..
>    
>    
>   thanx!
>   nagesh.k
> 
>  				
> ---------------------------------
>  Find out what India is talking about on  - Yahoo! Answers India 
>  Send FREE SMS to your friend's mobile from Yahoo! Messenger Version 8. Get it NOW
> 
> [[HTML alternate version deleted]]
> 

-- 
David Chatterton
XFS Engineering Manager
SGI Australia
