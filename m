Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F074729DF8
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 15:36:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 81C58AC006
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 13:36:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6MxnWcJTFEKgrBWM for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 13:36:56 -0700 (PDT)
Date: Tue, 6 May 2014 06:36:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fatigue for XFS
Message-ID: <20140505203633.GW26353@dastard>
References: <CABYiri9j=2ipPhvRtn1g=omEDpTz5VD8O0fPWrBGCm=UsgNavw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABYiri9j=2ipPhvRtn1g=omEDpTz5VD8O0fPWrBGCm=UsgNavw@mail.gmail.com>
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
To: Andrey Korolyov <andrey@xdel.ru>
Cc: "ceph-users@lists.ceph.com" <ceph-users@lists.ceph.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, May 05, 2014 at 11:49:05PM +0400, Andrey Korolyov wrote:
> Hello,
> 
> We are currently exploring issue which can be related to Ceph itself
> or to the XFS - any help is very appreciated.
> 
> First, the picture: relatively old cluster w/ two years uptime and ten
> months after fs recreation on every OSD, one of daemons started to
> flap approximately once per day for couple of weeks, with no external
> reason (bandwidth/IOPS/host issues). It looks almost the same every
> time - OSD suddenly stop serving requests for a short period, gets
> kicked out by peers report, then returns in a couple of seconds. Of
> course, small but sensitive amount of requests are delayed by 15-30
> seconds twice, which is bad for us. The only thing which correlates
> with this kick is a peak of I/O, not too large, even not consuming all
> underlying disk utilization, but alone in the cluster and clearly
> visible. Also there are at least two occasions *without* correlated
> iowait peak.

So, actual numbers and traces are the only thing that tell us what
is happening during these events. See here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

If it happens at almost the same time every day, then I'd be looking
at the crontabs to find what starts up about that time. output of
top will also probably tell you what process is running, too. topio
might be instructive, and blktrace almost certainly will be....

> I have two versions - we`re touching some sector on disk which is
> about to be marked as dead but not displayed in SMART statistics or (I

Doubt it - SMART doesn't cause OS visible IO dispatch spikes.

> believe so) some kind of XFS fatigue, which can be more likely in this
> case, since near-bad sector should be touched more frequently and
> related impact could leave traces in dmesg/SMART from my experience. I

I doubt that, too, because XFS doesn't have anything that is
triggered on a daily basis inside it. Maybe you've got xfs_fsr set
up on a cron job, though...

> would like to ask if anyone has a simular experience before or can
> suggest to poke existing file system in some way. If no suggestion
> appear, I`ll probably reformat disk and, if problem will remain after
> refill, replace it, but I think less destructive actions can be done
> before.

Yeah, monitoring and determining the process that is issuing the IO
is what you need to find first.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
