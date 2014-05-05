Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB0E37F6B
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 06:35:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9EF8E8F8035
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 04:34:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CTXPWWbdwj0SUQ31 for
	<xfs@oss.sgi.com>; Mon, 05 May 2014 04:34:54 -0700 (PDT)
Date: Mon, 5 May 2014 07:34:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/5] xfstests: fixes for the free inode btree
Message-ID: <20140505113443.GA11622@laptop.bfoster>
References: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
	<20140502234831.GG26353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140502234831.GG26353@dastard>
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

On Sat, May 03, 2014 at 09:48:31AM +1000, Dave Chinner wrote:
> On Fri, May 02, 2014 at 01:13:57PM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > This series is a few xfstests fixes and addons for the finobt. Patch 1
> > fixes xfs/030 to work correctly on finobt-enabled filesystems. Patches 2
> > and 3 add support for finobt-oriented tests via require functions and
> > repair filter updates. Patch 4 adds a new test for targeted repair of
> > finobt filesystems. Patch 5 adds a stress test that creates/modifies a
> > sparsely allocated set of inodes to effectively exercise the finobt in
> > conjunction with an fsstress workload.
> > 
> > xfs/010 runs very quickly. xfs/013 runs for 5-10 minutes on my smallish
> > VM running against a single spindle, so I've been back and forth on
> > whether it should be part of the auto group. Thoughts, reviews, flames
> > appreciated...
> 
> 5-10 minutes is probably right at the edge for auto, but I think
> that most people won't be testing this any time soon. Hence I'd
> include it by default in the auto group, and if people complain
> about the runtime when they start testing it, we can revist that
> choice. FWIW, I'd also include it in the metadata group so that it
> gets exercised when people run that group....
> 

Ok, sounds good. It actually runs closer to 5 minutes than 10 when I
simply move to a separate (still single) spindle, so it's probably not
that bad. IIRC, it's still probably not the longest running test I've
seen in auto. I believe you have an SSD test setup, so I'm curious how
the workload looks if you get a a chance to run it there. :)

> I had a quick eyeball of the changes, and nothing major stood out.
> The only thing I noticed was a missing "wait" in the _cleanup
> function of xfs/013 after killing all the fsstress processes. It
> should probably using killall -9 as well. If we don't wait, then the
> unmount will fail and if the fsstress processes don't die it will
> affect every test after that...
> 

Indeed, thanks.

> I'll probably have more suggestions once I've run the tests ;)
> 

Ok. FWIW, the parameters of the stress test (# files, # iters, etc.)
were mostly determined empirically to provide a good workout for the
finobt in a reasonable amount of time. The test started out as open
coded for loops to do linking and random new creations, but that turned
out far too slow when tuned to be effective. The hard link cp and
smaller file replacement loop after the fact turned out to be much
faster. fsstress was added after that as it appeared to amplify the
operations on the finobt without adding too much time to the test. Any
thoughts on the parameters or broader test(s) are appreciated...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
