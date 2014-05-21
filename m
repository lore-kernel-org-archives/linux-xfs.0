Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 20AF57F4E
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 19:23:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DFD2E304048
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 17:23:15 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qenh1LXnZdXrFynW for <xfs@oss.sgi.com>;
	Tue, 20 May 2014 17:23:13 -0700 (PDT)
Date: Wed, 21 May 2014 10:20:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfstests: fixes for the free inode btree
Message-ID: <20140521002037.GL18954@dastard>
References: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
	<20140502234831.GG26353@dastard>
	<20140505113443.GA11622@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140505113443.GA11622@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, May 05, 2014 at 07:34:43AM -0400, Brian Foster wrote:
> On Sat, May 03, 2014 at 09:48:31AM +1000, Dave Chinner wrote:
> > On Fri, May 02, 2014 at 01:13:57PM -0400, Brian Foster wrote:
> > > Hi all,
> > > 
> > > This series is a few xfstests fixes and addons for the finobt. Patch 1
> > > fixes xfs/030 to work correctly on finobt-enabled filesystems. Patches 2
> > > and 3 add support for finobt-oriented tests via require functions and
> > > repair filter updates. Patch 4 adds a new test for targeted repair of
> > > finobt filesystems. Patch 5 adds a stress test that creates/modifies a
> > > sparsely allocated set of inodes to effectively exercise the finobt in
> > > conjunction with an fsstress workload.
> > > 
> > > xfs/010 runs very quickly. xfs/013 runs for 5-10 minutes on my smallish
> > > VM running against a single spindle, so I've been back and forth on
> > > whether it should be part of the auto group. Thoughts, reviews, flames
> > > appreciated...
> > 
> > 5-10 minutes is probably right at the edge for auto, but I think
> > that most people won't be testing this any time soon. Hence I'd
> > include it by default in the auto group, and if people complain
> > about the runtime when they start testing it, we can revist that
> > choice. FWIW, I'd also include it in the metadata group so that it
> > gets exercised when people run that group....
> > 
> 
> Ok, sounds good. It actually runs closer to 5 minutes than 10 when I
> simply move to a separate (still single) spindle, so it's probably not
> that bad. IIRC, it's still probably not the longest running test I've
> seen in auto. I believe you have an SSD test setup, so I'm curious how
> the workload looks if you get a a chance to run it there. :)

FWIW, just running xfs/013 on 2 sata drives in hw RAID1 takes 80-90s
to run xfs/013, so this is fine. However, it runs out of disk space
on a 4GB ramdisk, so it still might need some tweaking...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
