Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8466C7FA5
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 17:09:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FBA2AC003
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 15:09:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9LlpOj5hgcgHCpBe for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 15:08:58 -0700 (PDT)
Date: Fri, 5 Jun 2015 08:08:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150604220833.GU24666@dastard>
References: <CABppvi437S9e+DEFOi6ECPu8=AnEK0V=5rRmU5Of1_XtWiQbfA@mail.gmail.com>
	<20150410131245.GK15810@dastard>
	<CABppvi68E6n+pr6X8TMOBhicVB4mrJbyyvm89r56rRVqSjf1Zg@mail.gmail.com>
	<20150603035719.GO24666@dastard>
	<CABppvi4AzQyaUm25_ombXR0Om04mUcHKtFd0ug_iKRxqa+NsOg@mail.gmail.com>
	<20150604003546.GS24666@dastard> <20150604012530.GG9143@dastard>
	<20150604020339.GI9143@dastard> <20150604062337.GK9143@dastard>
	<CABppvi6dbiOVDJq+gVMOMNhMZ5Lf2kEvtiQdOzxfhq9fLDrPVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi6dbiOVDJq+gVMOMNhMZ5Lf2kEvtiQdOzxfhq9fLDrPVQ@mail.gmail.com>
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
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 04, 2015 at 12:26:19AM -0700, Shrinand Javadekar wrote:
> I made two changes based on the suggestions above:
> 
> 1. Reverted the agcount back to the default: 4.
> 2. Bumped the directory block size to 8k (-n size=8k)
> 
> This definitely has made things better. My throughput for one run of
> my 40GB (5GB on each disk) test has gone up from ~70MB/s to 88MB/s.
> The pauses started off being very small : ~1 sec. Right now, with 20GB
> data in each disk, I see the pauses are ~4 seconds.
> 
> I ran echo w > /proc/sysrq-trigger as soon as the system went into one
> of these pauses. Attached here is the output of dmesg after that. I'm

Ok, it didn't catch anything blocked, just dumped scheduler info for
each CPU. But the fact the changes had a positive impact means we
are probably on the right track.

> going to run a test overnight to see how it performs. Especially, how
> big do the pauses get as more and more data is written into the
> system.
> 
> Also, unfortunately, I don't have a kernel dev setup ready to try out
> the patch immediately. I will try and setup the environment to try it
> out.

Ok, I'll be doing more testing here on it, but it would be great if
you could see what difference it makes and report back. No hurry,
such a change is probably too late for the next merge window, so
there's plenty of time to get it right...

Thanks for all the time you've spent triaging this problem so far!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
