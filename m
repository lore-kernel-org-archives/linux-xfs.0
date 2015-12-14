Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B8737CBF
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 18:20:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E4EBF304039
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 16:20:23 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9EUDVznca1DEzfJX for <xfs@oss.sgi.com>;
	Sun, 13 Dec 2015 16:20:17 -0800 (PST)
Date: Mon, 14 Dec 2015 11:20:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests failures with xfs, dax and v4.4-rc3
Message-ID: <20151214002002.GJ26718@dastard>
References: <20151202183438.GA1319@linux.intel.com>
	<20151202202910.GH19199@dastard> <20151202204502.GI19199@dastard>
	<20151202213932.GA7652@linux.intel.com>
	<20151210165458.GA13603@linux.intel.com>
	<20151210223333.GH26718@dastard>
	<20151211042609.GA5360@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151211042609.GA5360@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com, Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>

On Thu, Dec 10, 2015 at 09:26:09PM -0700, Ross Zwisler wrote:
> On Fri, Dec 11, 2015 at 09:33:33AM +1100, Dave Chinner wrote:
> > On Thu, Dec 10, 2015 at 09:54:58AM -0700, Ross Zwisler wrote:
> > > On Wed, Dec 02, 2015 at 02:39:32PM -0700, Ross Zwisler wrote:
> > > > I've verified that this fixes all three failing xfstests reported in this mail.
> > > > Thanks!
> > > 
> > > Hey Dave,
> > > 
> > > Are you planning on pushing this fix for v4.4?
> > 
> > No plans to right now - ENOSPC is a corner case that most users
> > won't be anywhere near, especially for experimental functionality on
> > hardware nobody actually has....
> 
> Really?  I realize that it may be a case that most users won't actually hit,
> but it is a 5 line change that fixes four xfstests regressions between v4.3 and
> v4.4 for my DAX testing...
> 
> Is there a strong reason *not* to push it in the v4.4 cycle?  I'm trying to
> clear up all xfstests differences between DAX and non-DAX, and this would help
> quite a bit.

Against my better judgement, I committed a largely untested,
fundamental change to allocation policy for DAX-on-XFS *inside the
4.4 merge window* justifying it as "it's experimental code" and that
"we needed to get it out there".  IOWs, I've already stretched the
rules and committed stuff I knew wasn't ready or worked 100%
correctly just to keep you guys happy, but I'm not going to continue
to do so. I'm reverting to usual policy of "soak in for-next, use
"cc: stable" tags to get it backported when upstreamed in the next
merge window.

Indeed, from my point of view it's pretty clear that lots of recent
DAX code has been committed prematurely and without sufficient
review and/or testing. This has lead to having to revert chunks of
code and completely rework algorithms, I really don't care if you're
being pushed to "make DAX shit happen fast" - my only concern here
is *don't screw up production filesystems*.

Hence when it comes to making fundamental changes to allocation
behaviour, I've already bent the policy/rules as far as I'm willing
to.  Changes in this area carry an inherent risk of breaking stuff
unrelated to DAX and that is far more important right now than
whether DAX (and experimental feature) works correctly or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
