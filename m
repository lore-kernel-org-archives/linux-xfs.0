Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A11F7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 18:17:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8ACEAC003
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 16:17:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	eCNFzxtorGPxpuAP for <xfs@oss.sgi.com>;
	Fri, 18 Sep 2015 16:17:47 -0700 (PDT)
Date: Sat, 19 Sep 2015 09:17:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How Can I Get Writeback Status When Running fs_mark
Message-ID: <20150918231744.GG26895@dastard>
References: <CAPBX1xLUbxfSSK-SSKY-JtLyUpqZC7uB_iPY64ZuAEYD4KtM3w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPBX1xLUbxfSSK-SSKY-JtLyUpqZC7uB_iPY64ZuAEYD4KtM3w@mail.gmail.com>
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
To: George Wang <xuw2015@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 18, 2015 at 07:06:39PM +0800, George Wang wrote:
> Hi, Dave,
> 
> I read the mail you post for "fs-writeback: drop wb->list_lock during
> blk_finish_plug()",  and I
> adore you very much.
> 
> I'm very curious that how you get the writeback status when running fs_mark.
> 
> I will appreciate very much if you can share the way you get writeback
> status and iops, etc.

http://pcp.io/

Indeed:

http://pcp.io/testimonials.html

> And maybe people in community can use this way to do the same tests as you.
> 
> The following is a part copy of the test result you got:

This is the best way to demonstrate:

https://flic.kr/p/xR9Cwn

That's a screen shot of my "coding and testing" virtual desktop when
running the fsmark test.  (Yes, it's a weird size - I have 3 x 24"
monitors in portrait orientation which gives a 3600x1920 image....)

> FSUse%        Count         Size    Files/sec     App Overhead
>      0        80000         4096     106938.0           543310
>      0       160000         4096     102922.7           476362
>      0       240000         4096     107182.9           538206
>      0       320000         4096     107871.7           619821
>      0       400000         4096      99255.6           622021
>      0       480000         4096     103217.8           609943
>      0       560000         4096      96544.2           640988
>      0       640000         4096     100347.3           676237
>      0       720000         4096      87534.8           483495
>      0       800000         4096      72577.5          2556920
>      0       880000         4096      97569.0           646996
> 
> <RAM fills here, sustained performance is now dependent on writeback>

You can see this from the lower chart that tracks memory usage - all
16GB gets used up pretty quickly, and it matches with changes in
writeback behaviour.

You can also see it from /proc/meminfo and Writeback iops and
throughput you can also get from 'iostat -d -m -x 5', etc. But when
you've got it in pretty, real-time graphs you can easily see
correlations between different behaviours....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
