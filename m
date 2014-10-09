Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E38117F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 17:30:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D2ACB8F8064
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 15:30:10 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id UAe3B77Yk7C2Cob5
	for <xfs@oss.sgi.com>; Thu, 09 Oct 2014 15:30:09 -0700 (PDT)
Message-ID: <54370C84.4070400@hardwarefreak.com>
Date: Thu, 09 Oct 2014 17:30:28 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: gather write metrics on multiple files
References: <543611CF.6030904@hardwarefreak.com> <543613E7.70508@gmail.com>
	<54361C04.5090404@hardwarefreak.com>
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
> On Thu, Oct 09, 2014 at 12:24:20AM -0500, Stan Hoeppner wrote:
>> On 10/08/2014 11:49 PM, Joe Landman wrote:
>>> On 10/09/2014 12:40 AM, Stan Hoeppner wrote:
>>>> Does anyone know of a utility that can track writes to files in
>>>> an XFS directory tree, or filesystem wide for that matter, and
>>>> gather filesystem blocks written per second data, or simply
>>>> KiB/s, etc?  I need to analyze an application's actual IO
>>>> behavior to see if it matches what I'm being told the
>>>> application is supposed to be doing.
>>>>
>>>
>>> We've written a few for this purpose (local IO probing).
>>>
>>> Start with collectl (looks at /proc/diskstats), and others.  Our
>>> tools go to /proc/diskstats, and use this to compute BW and IOPs
>>> per device.
>>>
>>> If you need to log it for a long time, set up a time series
>>> database (we use influxdb and the graphite plugin).  Then grab
>>> your favorite metrics tool that talks to graphite/influxdb (I
>>> like https://github.com/joelandman/sios-metrics for obvious
>>> reasons), and start collecting data.
>>
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

Just started earlier today.  Turns out the buffer sizes and buffer count are configurable, not hard coded, at least in the test harness.  AIUI the actual application creates variable sized buffers on the fly.  In which case the test harness doesn't accurately simulate the real app.  So the numbers we might achieve optimizing the harness may not reflect reality, same for the storage subsystem tweaks for that matter.  Which brings up a whole other set of questions regarding what we're actually doing....
 
>> I've been playing with bcache for a few days but it actually drops
>> throughput by about 30% no matter how I turn its knobs.  Unless I
>> can get Kent to respond to some of my questions bcache will be a
>> dead end.  I had high hopes for it, thinking it would turn these
>> small random IOs into larger sequential writes.  It may actually
>> be doing so, but it's doing something else too, and badly.  IO
>> times go through the roof once bcache starts gobbling IOs, and
>> throughput to the LUNs drops significantly even though bcache is
>> writing 50-100 MIB/s to the SSD.  Not sure what's causing that.
> 
> Have you tried dm-cache?

Not yet.  I have a feeler out to our Dell rep WRT LSI's CacheCade, since Dell PERCs are OEM LSIs.  Initially it appears it is optimized for read caching as bcache seems to be.  I've tested bcache on 3.12 and 3.17 and its write throughput on the latter is even worse, both being ~30-40 lower than native.  Latency goes through the roof, and iostat shows the distribution across the LUNs is horribly uneven.  Atop that, running iotop at 1 second intervals shows no IO on one LUN or the other for 1-2 seconds at a time.  And when both do show IO the rates are up and down all over the place.  Runnig native IO the rates are constant and the spread between LUNs in 2-3%.  Not sure what the problem is here with bcache, but it certainly doesn't behave as I expected it would.  It's really quite horrible for this workload.  And that's when attempting to push only ~360 MB/s per LUN.

Kent doesn't seem interested in assisting thus far.  Which is a shame.  Having bcache running on hundreds of systems of this caliber would be a feather in his cap, and a validation of his work.  Natively we're currently achieving about 2.3 GB/s write throughput across 14 RAID6 LUNs (12+2) on two controllers in an active-active multipath setup.  If bcache was performing how I'd think it should, with the right number of SSDs I'd think we could be knocking on the 3 GB/s door.

Thanks,
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
