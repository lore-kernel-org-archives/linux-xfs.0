Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C29E7F3F
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2014 01:03:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1A9EF8F8039
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2014 23:03:02 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id FPZPPk9ykOhgWiMB
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2014 23:03:01 -0700 (PDT)
Message-ID: <544202AE.3000003@hardwarefreak.com>
Date: Sat, 18 Oct 2014 01:03:26 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: gather write metrics on multiple files
References: <543611CF.6030904@hardwarefreak.com>
	<543613E7.70508@gmail.com>	<54361C04.5090404@hardwarefreak.com>
	<20141009211339.GD4376@dastard>
In-Reply-To: <20141009211339.GD4376@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/09/2014 04:13 PM, Dave Chinner wrote:
...
>> I'm told we have 800 threads writing to nearly as many files
>> concurrently on a single XFS on a 12+2 spindle RAID6 LUN.
>> Achieved data rate is currently ~300 MiB/s.  Some of these are
>> files are supposedly being written at a rate of only 32KiB every
>> 2-3 seconds, while some (two) are ~50 MiB/s.  I need to determine
>> how many bytes we're writing to each of the low rate files, and
>> how many files, to figure out RMW mitigation strategies.  Out of
>> the apparent 800 streams 700 are these low data rate suckers, one
>> stream writing per file.  
>>
>> Nary a stock RAID controller is going to be able to assemble full
>> stripes out of these small slow writes.  With a 768 KiB stripe
>> that's what, 24 seconds to fill it at 2 seconds per 32 KiB IO?
> 
> Raid controllers don't typically have the resources to track
> hundreds of separate write streams at a time. Most don't have the
> memory available to track that many active write streams, and those
> that do probably can't proritise writeback sanely given how slowly
> most cachelines would be touched. The fast writers would simply tune
> over the slower writer caches way too quickly.
> 
> Perhaps you need to change the application to make the slow writers
> buffer stripe sized writes in memory and flush them 768k at a
> time...

All buffers are now 768K multiples--6144, 768, 768, and I'm told the app should be writing out full buffers.  However I'm not seeing the throughput increase I should given the amount that the RMWs should have decreased, which, if my math is correct, should be about half (80) the raw actuator seek rate of these drives (7.2k SAS).  Something isn't right.  I'm guessing it's the controller firmware, maybe the test app, or both.  The test app backs off then ramps up when response times at the controller go up and back down.  And it's not super accurate or timely about it.  The lowest interval setting possible is 10 seconds.  Which is way too high when a controller goes into congestion.

Does XFS give alignment hints with O_DIRECT writes into preallocated files?  The filesystems were aligned at make time w/768K stripe width, so each prealloc file should be aligned on a stripe boundary.  I've played with the various queue settings, even tried deadline instead of noop hoping more LBAs could be sorted before hitting the controller.  Can't seem to get a repeatable increase.  I've nr_requests at 524288, rq_affinity 2, read_ahead_kb 0 since reads are <20% of the IO, add_random 0, etc.  Nothing seems to help really.

Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
