Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A94067F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 16:47:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 87DDB8F8074
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 14:47:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	o3Jc0KFBLeXKF5Pz for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 14:47:50 -0700 (PDT)
Date: Sat, 21 Mar 2015 08:47:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: default to CRC enabled filesystems
Message-ID: <20150320214719.GJ28621@dastard>
References: <1426720967-8215-1-git-send-email-david@fromorbit.com>
	<550AE35D.40006@sandeen.net> <20150319231323.GK10105@dastard>
	<550C3C39.8050400@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <550C3C39.8050400@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Mar 20, 2015 at 10:26:49AM -0500, Eric Sandeen wrote:
> On 3/19/15 6:13 PM, Dave Chinner wrote:
> > On Thu, Mar 19, 2015 at 09:55:25AM -0500, Eric Sandeen wrote:
> 
> ...
> 
> >> Problem here is that if both are explicitly specified, one is ignored, rather
> >> than letting the user know they've selected an invalid set of options:
> > 
> > Yup, I explicitly made that choice: turning off CRCs immediately
> > turns off all functionality dependent on it. Especially as the
> > number of errors being thrown by xfstests when run with
> > MKFS_OPTIONS="-m crc=0".
> > 
> >> # mkfs/mkfs.xfs -dfile,name=fsfile,size=1g -m crc=0,finobt=1
> >> meta-data=fsfile                 isize=256    agcount=4, agsize=65536 blks
> >>          =                       sectsz=512   attr=2, projid32bit=1
> >>          =                       crc=0        finobt=0
> >> ...
> > 
> >> This might require a "finobtflag" to keep track of whether it's user-specified,
> >> as we do with other options?
> > 
> > I *hate* the profusion of flags in mkfs just to detect this sort of
> > thing. This is a clear case where "do what I mean" rather than "do
> > what I say" is the prefered behaviour - the current code is a
> > horrible mess because it tries handle every weird combination of "do
> > what I say" with some error message.
> > 
> > I'll change it to add the stupid error message back in and go and
> > write all the patches for xfstests not to fail because we changed
> > mkfs defaults...
> 
> Oops, I accidentally missed reply-all last time.
> 
> I just think that silently changing an explicitly-specified option seems
> like a bad idea.
> 
> Perhaps if defaults are specified before getopt, the getopt handlers can
> flag the incorrect combination, and bail without the extra flag.
> 
> I don't see how this requires xfstests rework, though?

About 50 tests fail with:

xfs/031 6s ... - output mismatch (see /home/dave/src/xfstests-dev/results//xfs_v4/xfs/031.out.bad)
    --- tests/xfs/031.out       2014-01-20 16:57:33.000000000 +1100
    +++ /home/dave/src/xfstests-dev/results//xfs_v4/xfs/031.out.bad     2015-03-18 18:41:36.000000000 +1100
    @@ -38,6 +38,7 @@
     done
     
     === twenty entries (block form)
    +warning: finobt not supported without CRC support, disabled.
     Repairing, iteration 1
     Phase 1 - find and verify superblock...
     Phase 2 - using <TYPEOF> log
    ...
    (Run 'diff -u tests/xfs/031.out /home/dave/src/xfstests-dev/results//xfs_v4/xfs/031.out.bad'  to see the entire diff)

When run with MKFS_OPTIONS="-m crc=0".

i.e. finobt is not specified, but mkfs issues warnings about it.

I've reworked the patch, anyway, so there's no need to continue the
discussion on this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
