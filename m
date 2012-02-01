Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q110KpW8145252 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 18:20:51 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id uiyR4OQG4Ab6Ve33
	for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 16:20:50 -0800 (PST)
Message-ID: <4F288561.5040803@hardwarefreak.com>
Date: Tue, 31 Jan 2012 18:20:49 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: File system remain unresponsive until the system is rebooted.
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
	<CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
	<4F27AE92.9060003@hardwarefreak.com>
	<20120131205014.GM9090@dastard>
In-Reply-To: <20120131205014.GM9090@dastard>
Reply-To: stan@hardwarefreak.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 1/31/2012 2:50 PM, Dave Chinner wrote:
> On Tue, Jan 31, 2012 at 03:04:18AM -0600, Stan Hoeppner wrote:
>> On 1/30/2012 11:04 PM, Supratik Goswami wrote:
>>> We are using Amazon EC2 instances.
>>
>>                ^^^^^^^^^^
>> I'd have never thought I would see those words on this list, except
>> maybe as a joke, or as an example of one of the the worst possible
>> platforms for XFS.
> 
> I don't agree with you there. If the workload works best on XFs, it
> doesn't matter what the underlying storage device is. e.g. if it's a
> fsync heavy workload, it will still perform better on XFS on EC2
> than btrfs on EC2...
> 
>> I wish EC2 had been asked about during the QA session after Dave's
>> presentation.  I'm guessing some laughter would have been involved. ;)
> 
> You'd be wrong about that. There are as many good uses of cloud
> services as there are bad ones, yet the same decisions about storage
> need to be made even when services are remotely hosted....

Maybe I should have elaborated a bit.  My thinking is that workloads
that would require XFS, or benefit most from it, are probably going to
need more guarantees WRT bandwidth and IOPS being available
consistently, vs sharing said resources with other systems in the cloud
infrastructure.  Additionally, you have driven the point home many times
WRT tuning XFS to the underlying hardware, specifically stripe
alignment.  I'd bet alignment would be a bit tricky to achieve in a
cloud environment such as EC2.

In summary, I wasn't saying XFS is bad on EC2.  I was simply saying EC2
is probably bad for the typical workloads where XFS best flexes its muscles.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
