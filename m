Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FF0D7CA2
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 16:26:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7423AC002
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 14:26:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5nRN2Rb7TSRQKOdZ for <xfs@oss.sgi.com>;
	Fri, 29 Jan 2016 14:26:07 -0800 (PST)
Date: Sat, 30 Jan 2016 09:25:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Random write result differences between RAID device and XFS
Message-ID: <20160129222553.GK20456@dastard>
References: <56AB44AF.8020807@purplehaze.ch>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56AB44AF.8020807@purplehaze.ch>
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
To: Christian Affolter <c.affolter@purplehaze.ch>
Cc: xfs@oss.sgi.com

On Fri, Jan 29, 2016 at 11:53:35AM +0100, Christian Affolter wrote:
> Hi everyone,
> 
> I'm trying to understand the differences of some bandwidth and IOPs test
> results I see while running a random-write full-stripe-width aligned fio
> test (using libaio with direct IO) on a hardware RAID 6 raw device
> versus on the same device with the XFS file system on top of it.
> 
> On the raw device I get:
> write: io=24828MB, bw=423132KB/s, iops=137, runt= 60085msec
> 
> With XFS on top of it:
> write: io=14658MB, bw=249407KB/s, iops=81, runt= 60182msec

Now repeat with a file that is contiguously allocated before you
start. And also perhaps with the "swalloc" mount option.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
