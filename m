Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24BItOS162026 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 05:18:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E7B01D12C02
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 03:20:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	1nzM72J8kraaJ0I9 for <xfs@oss.sgi.com>;
	Thu, 04 Mar 2010 03:20:21 -0800 (PST)
Date: Thu, 4 Mar 2010 22:20:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100304112018.GG14317@discord.disaster>
References: <4B8F871C.60802@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B8F871C.60802@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 04, 2010 at 11:10:36AM +0100, Michael Weissenbacher wrote:
> Hi XFS-List!
> We recently had two hangs on one of our servers, which seem to be  
> related to XFS. We managed to capture the dmesg output before  
> hard-resetting the machine. It seems that those hangs are caused by  
> xfs_fsr which was running at that time. This is a mail server with  
> millions of files. The underlying file system was already checked with  
> xfs_repair without finding errors.
> Is there anything i could try to rectify or at least narrow down this  
> problem?

Can you run the trace through ksymoops so that we get function names
rather than numbers that don't mean anything?

Also, can you tell us what kernel version and distro you are
running, as well as the version of xfs_fsr? These will help tell us
if it is a new or known problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
