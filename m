Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5FEMkbY099970 for <xfs@oss.sgi.com>; Fri, 15 Jun 2012 09:22:46 -0500
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id mwlC0PX5TFPItNlS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Jun 2012 07:22:43 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id
	q5FEMfW0029365
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2012 16:22:41 +0200
Message-ID: <4FDB4530.9080202@itwm.fraunhofer.de>
Date: Fri, 15 Jun 2012 16:22:40 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl> <20120613011950.GN22848@dastard>
	<4FD8552C.4090208@xsnews.nl> <20120614000411.GY22848@dastard>
	<4FD9F5B3.3040901@xsnews.nl> <20120615001602.GF7339@dastard>
	<4FDB1BA6.3030203@itwm.fraunhofer.de>
	<20120615123034.GC19223@dastard>
In-Reply-To: <20120615123034.GC19223@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Whittaker-Williams <matthew@xsnews.nl>, xfs@oss.sgi.com

On 06/15/2012 02:30 PM, Dave Chinner wrote:
> On Fri, Jun 15, 2012 at 01:25:26PM +0200, Bernd Schubert wrote:
>> On 06/15/2012 02:16 AM, Dave Chinner wrote:
>>> Oh, I just noticed you are might be using CFQ (it's the default in
>>> dmesg). Don't - CFQ is highly unsuited for hardware RAID - it's
>>> hueristically tuned to work well on sngle SATA drives. Use deadline,
>>> or preferably for hardware RAID, noop.
>>
>> I'm not sure if noop is really a good recommendation even with hw
>> raid, especially if the the request queue size is high. This week I
>> did some benchmarks with a high rq write size (triggered with
>> sync_file_range(..., SYNC_FILE_RANGE_WRITE) ) and with noop
>> concuring reads then almost entirely got stalled.
>> With deadline read/write balance was much better, although writes
>> still had been preferred (with sync_file_range() and without). I
>> always thought deadline prefers reads and I hope I find some time
>> later on to investigate further what was going on.
>> Test had been on a netapp E5400 hw raid, so rather high end hw raid.
>
> Sounds like a case of the IO scheduler queue and/or CTQ being too
> deep.

Hmm yes probably. With a small request queue and the usage of 
sync_file_range(..., SYNC_FILE_RANGE_WRITE) we only have a small page 
cache buffer. And sync_file_range is required to get perfect IO sizes as 
given by max_sectors_kb.  Without sync_file_range IOs have more or less 
random size, but very rarely aligned to the raid-stripe-size (and yes, 
mkfs.xfs options are correctly set). That is another issue I need to 
find time to investigate.


Cheers,
Bernd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
