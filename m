Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 16:50:27 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBK0oJGh008520
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 16:50:22 -0800
Message-ID: <4769BD13.5040303@sgi.com>
Date: Thu, 20 Dec 2007 11:53:39 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: mount prob: "log inconsistent or not a log"
References: <20071220000144.GQ19770@msoe.edu>
In-Reply-To: <20071220000144.GQ19770@msoe.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jonathan.Detert@msoe.edu
Cc: xfs@oss.sgi.com

Hi Jonathan,

I'm not giving a high level view but
in regards to the log message about the xfs log :)

Jonathan.Detert@msoe.edu wrote:
> This is what /var/log/messages has to say about the mount attempt:
> -=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS mounting filesystem sdb
> Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: Log inconsistent or not a log (last==0, first!=1)
> Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: empty log check failed
> Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: log mount/recovery failed: error 22
> Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: log mount failed
> -=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> 
Every 512 bytes of the log is stamped with the cycle#.
The cycle# is effectively the number of times the log has wrapped
around. The cycle# is at the start of each sector or near the
start for a log record. The cycle# is used to find where the log
was last written to (the head of the log).
What the message is saying is that the first sector of the log has a
cycle# which is not 1 and the last sector has a cycle# of zero.
Looking at the code (xlog_find_zeroed), the first sector cycle#
is not zero either.
=> first sector cycle# >1
=> last  sectir cycle# == 0
Now this can't really happen.
If the last cycle# is zero then the first cycle# should be 1
(or possibly 0 on irix).

An "xfs_logprint -d /dev/sdb" will show what the cycle#s are
and where the log records are. It might give an idea of the
extent of the corruption.

--Tim
