Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 23:20:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5J6KV5q014464
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 23:20:31 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D879BCEE2CD
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 23:21:29 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id sfcEPtG1Nb3qTrNE for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 23:21:29 -0700 (PDT)
Date: Thu, 19 Jun 2008 16:21:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: open sleeps
Message-ID: <20080619062118.GY3700@disturbed>
References: <4859EE54.6050801@vpac.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4859EE54.6050801@vpac.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brian May <brian@vpac.org>
Cc: xfs@oss.sgi.com

On Thu, Jun 19, 2008 at 03:27:48PM +1000, Brian May wrote:
> Hello,
>
> I am having (weird) issues with XFS, in that open(...) on certain files  
> takes 45 seconds to return. After the file has been opened, the next  
> file in the same directory takes 45 seconds. If the file was recently  
> opened it returns immediately.
>
> I thought this was a low level I/O issue, so copied the files in  
> question to a completely independent RAID array  (separate LVM, RAID,  
> controllers, disks), but the problem remains.
>
> More details at thread starting from  
> <http://lists.luv.asn.au/wws/arc/luv-main/2008-06/msg00143.html>.
>
> Any ideas?

# echo t > /proc/sysrq-trigger

when it is hung to get a stack trace of the blocked open call.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
