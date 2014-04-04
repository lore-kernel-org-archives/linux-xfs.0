Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17FF77FB8
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 16:12:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0863C304062
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 14:12:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8iBCHPl8ZFhZtzMO for <xfs@oss.sgi.com>;
	Fri, 04 Apr 2014 14:12:40 -0700 (PDT)
Date: Sat, 5 Apr 2014 08:12:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfstests: updated to cf1ed54
Message-ID: <20140404211224.GX17603@dastard>
References: <20140404090357.GW17603@dastard>
	<CAL3q7H6q7M-hrvniaVkAm_L6aSHANmnfdTKGEHHLFqXUhWfY5w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL3q7H6q7M-hrvniaVkAm_L6aSHANmnfdTKGEHHLFqXUhWfY5w@mail.gmail.com>
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
To: Filipe David Manana <fdmanana@gmail.com>
Cc: lczerner@redhat.com, linux-ext4@vger.kernel.org, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Apr 04, 2014 at 02:07:16PM +0100, Filipe David Manana wrote:
> On Fri, Apr 4, 2014 at 10:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> > Hi folks,
> >
> > The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
> > just been updated. Patches often get missed, so please check if your
> > outstanding patches were in this update. If they have not been in
> > this update, please resubmit them to xfs@oss.sgi.com so they can be
> > picked up in the next update.
> >
> > The new head of the master branch is commit:
> >
> > cf1ed54 check: fix RESULT_BASE typo in check script
> >
> > The major new functionality worth mentioning in this update is the
> > new config file format from Lukas. The existing format config files
> > should continue to work without change, but the new format is much
> > richer and allows specification of multiple different configurations
> > to run test under. Hence testing multiple mount an dmkfs
> > configurations becomes as simple as iterating the configurations
> > in the config file.
> 
> Hi,
> 
> I might be missing something, but after checking out these changes, I
> am no longer able to run btrfs tests. Example:
> 
> $ ./check btrfs/041
> common/config: Error: $SCRATCH_DEV should be unset when $SCRATCH_DEV_POOL is set
> Passed all 0 tests
> 
> $ cat local.config
> export TEST_DEV=/dev/sdb
> export TEST_DIR=/home/fdmanana/btrfs-tests/dev
> export SCRATCH_MNT="/home/fdmanana/btrfs-tests/scratch_1"
> export SCRATCH_DEV_POOL="/dev/sdc /dev/sdd"

OK, that'll be a bug in the new config file parsing code. Lukas,
can you have a look at this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
