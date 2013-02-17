Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F1F3D7FF2
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 15:25:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9ED61AC001
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 13:25:53 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GbutpMXHHIBWPjfp for <xfs@oss.sgi.com>;
	Sun, 17 Feb 2013 13:25:52 -0800 (PST)
Date: Mon, 18 Feb 2013 08:25:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: High %user CPU in XFS
Message-ID: <20130217212536.GY26694@dastard>
References: <CAEUQcehy1fy5-W-TA--2emBgL3y9JskqRPCZf1ED5JDbPHqKTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEUQcehy1fy5-W-TA--2emBgL3y9JskqRPCZf1ED5JDbPHqKTQ@mail.gmail.com>
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
To: Subranshu Patel <spatel.ml@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 17, 2013 at 09:20:46PM +0530, Subranshu Patel wrote:
>  I created 2 filesystem on my system (RHEL 6.3, kernel 2.6.32) - XFS
> and EXT4 and mounted them.
> 
> On both the filesystem I executed a program which performed the following:
> - Create large number of directories
> - Removing all the directories
> 
> During the execution of the program, I monitored the %user and %system
> CPU usage (using sar command)
> 
> For EXT4 the %user was 1% and %system was 21%
> For XFS the %user was 20% and %system was 52%
> 
> But I am not able to understand %user consumption, since %user reports
> the CPU usage of the user level (application), shouldn't it be the
> same for both EXT4 and XFS?

Perf is your friend.

> What are the factors that decide the %user component keeping in mind
> that only the filesystem is different?

Page faults, CPU cache misses. XFS has a significantly large icache
and dcache footprint than ext4, so those are the likely causes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
