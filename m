Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CF0CC29DFD
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 15:59:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB55B30405F
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 13:59:50 -0700 (PDT)
Received: from mail-ob0-f177.google.com (mail-ob0-f177.google.com
	[209.85.214.177]) by cuda.sgi.com with ESMTP id
	TrtyrrEbvvbMKIIO (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 13:59:48 -0700 (PDT)
Received: by mail-ob0-f177.google.com with SMTP id gq1so1442038obb.8
	for <xfs@oss.sgi.com>; Mon, 05 May 2014 13:59:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140505203633.GW26353@dastard>
References: <CABYiri9j=2ipPhvRtn1g=omEDpTz5VD8O0fPWrBGCm=UsgNavw@mail.gmail.com>
	<20140505203633.GW26353@dastard>
From: Andrey Korolyov <andrey@xdel.ru>
Date: Tue, 6 May 2014 00:59:27 +0400
Message-ID: <CABYiri9WhwjU66eG2ed=3knwWZ63Aa+r6ZXxdMN_8A_Vbg2ULA@mail.gmail.com>
Subject: Re: Fatigue for XFS
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
Cc: "ceph-users@lists.ceph.com" <ceph-users@lists.ceph.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, May 6, 2014 at 12:36 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, May 05, 2014 at 11:49:05PM +0400, Andrey Korolyov wrote:
>> Hello,
>>
>> We are currently exploring issue which can be related to Ceph itself
>> or to the XFS - any help is very appreciated.
>>
>> First, the picture: relatively old cluster w/ two years uptime and ten
>> months after fs recreation on every OSD, one of daemons started to
>> flap approximately once per day for couple of weeks, with no external
>> reason (bandwidth/IOPS/host issues). It looks almost the same every
>> time - OSD suddenly stop serving requests for a short period, gets
>> kicked out by peers report, then returns in a couple of seconds. Of
>> course, small but sensitive amount of requests are delayed by 15-30
>> seconds twice, which is bad for us. The only thing which correlates
>> with this kick is a peak of I/O, not too large, even not consuming all
>> underlying disk utilization, but alone in the cluster and clearly
>> visible. Also there are at least two occasions *without* correlated
>> iowait peak.
>
> So, actual numbers and traces are the only thing that tell us what
> is happening during these events. See here:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> If it happens at almost the same time every day, then I'd be looking
> at the crontabs to find what starts up about that time. output of
> top will also probably tell you what process is running, too. topio
> might be instructive, and blktrace almost certainly will be....
>
>> I have two versions - we`re touching some sector on disk which is
>> about to be marked as dead but not displayed in SMART statistics or (I
>
> Doubt it - SMART doesn't cause OS visible IO dispatch spikes.
>
>> believe so) some kind of XFS fatigue, which can be more likely in this
>> case, since near-bad sector should be touched more frequently and
>> related impact could leave traces in dmesg/SMART from my experience. I
>
> I doubt that, too, because XFS doesn't have anything that is
> triggered on a daily basis inside it. Maybe you've got xfs_fsr set
> up on a cron job, though...
>
>> would like to ask if anyone has a simular experience before or can
>> suggest to poke existing file system in some way. If no suggestion
>> appear, I`ll probably reformat disk and, if problem will remain after
>> refill, replace it, but I think less destructive actions can be done
>> before.
>
> Yeah, monitoring and determining the process that is issuing the IO
> is what you need to find first.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

Thanks Dave,

there are definitely no cron set for specific time (though most of
lockups happened in a relatively small interval which correlates with
the Ceph snapshot operations). In at least one case no Ceph snapshot
operations (including delayed removal) happened and at least two when
no I/O peak was observed. We observed and eliminated weird lockups
related to the openswitch behavior before - we`re combining storage
and compute nodes, so quirks in the OVS datapath caused very
interesting and weird system-wide lockups on (supposedly) spinlock,
and we see 'pure' Ceph lockups on XFS at time with 3.4-3.7 kernels,
all of them was correlated with very high context switch peak.

Current issue is seemingly nothing to do with spinlock-like bugs or
just a hardware problem, we even rebooted problematic node to check if
the memory allocator may stuck at the border of specific NUMA node,
with no help, but first reappearance of this bug was delayed by some
days then. Disabling lazy allocation via specifying allocsize did
nothing too. It may look like I am insisting that it is XFS bug, where
Ceph version is more likely to appear because of way more complicated
logic and operation behaviour, but persistence on specific node across
relaunching of Ceph storage daemon suggests bug relation to the
unlucky byte sequence more than anything else. If it finally appear as
Ceph bug, it`ll ruin our expectations from two-year of close
experience with this product and if it is XFS bug, we haven`t see
anything like this before, thought we had a pretty collection of
XFS-related lockups on the earlier kernels.

So, my understanding is that we hitting neither very rare memory
allocator bug in case of XFS or age-related Ceph issue, both are very
unlikely to exist - but I cannot imagine nothing else. If it helps, I
may collect a series of perf events during next appearance or exact
iostat output (mine graphics can say that the I/O was not choked
completely when peak appeared, that`s all).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
