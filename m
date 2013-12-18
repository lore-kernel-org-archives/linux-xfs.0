Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 024E07F3F
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 15:34:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CBE448F804C
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 13:34:43 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qVJMrUv87EmKbrcF for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 13:34:38 -0800 (PST)
Date: Thu, 19 Dec 2013 08:34:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS_REPAIR on LVM partition
Message-ID: <20131218213434.GK31386@dastard>
References: <CAG97raf61XGnTakrYjcfv9cjM6CTVdEEB3wQK+wOBvpowWO3Cw@mail.gmail.com>
	<20131216000141.GU31386@dastard>
	<CAG97radg3xd8-G2qChh2BOfH8R6N4kWH3qn3ivukxrkFVrt=rA@mail.gmail.com>
	<20131216030537.GX31386@dastard>
	<CAG97racd-UhUqhVLcsbjqZt51iTEaHKaQNMkvQFnznH8X8wOUQ@mail.gmail.com>
	<20131216125402.GB10988@dastard>
	<CAG97raeP-0QEhhYjDX_DDxzS3TN_brRSU6G+j-+V3KEuJ7Ym6Q@mail.gmail.com>
	<CAG97raf7Na5UwzREJ_C9nYJ64r7PPwkhp_qcPiGVnKqu+ujAgw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAG97raf7Na5UwzREJ_C9nYJ64r7PPwkhp_qcPiGVnKqu+ujAgw@mail.gmail.com>
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
To: Rafael Weingartner <rafaelweingartner@gmail.com>
Cc: xfs@oss.sgi.com

[ cc'd the XFS list again - please keep problem triage on the public
lists so that more than one person can help you. ]

On Mon, Dec 16, 2013 at 02:53:03PM -0200, Rafael Weingartner wrote:
> Today, I let the command xfs_repair /dev/... ran till it finished, I got
> the following messages:
> 
> Phase 1 - Find and verify superblock ....
> > Could not verify primary superblock - not enough secondary superblocks
> > with matching geometry!!

The primary superblock dump looked valid, but it it couldn't find
matching secondary superblocks from the contents of the primary that
it found.

> > attempting to find a secondary superblock.....
> > ...
> > ..
> > ...
> > ...
> > found candidate secondary superblock....
> > unable to verify superblock, continuing....

And it found blocks with the correct superbloc magic numbers, but
they don't match the primary superblock that was found.

> > found candidate secondary superblock....
> > unable to verify superblock, continuing...
> > ...
> > ...
> > ..............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................Sorry,
> > could not find valid secondary superblock
> > Exiting now.
> 
> 
> Should I upgrade the xfsprogs and try to run the xfs_repair again?
> Or does that message mean that there is no way of recovering the filesystem?

It's still possible to recover, but more info is needed first.
Can you get xfs_db to dump the primary and a couple of secondary
superblocks?

# xfs_db -c "sb 0" -c p -c "sb 2" -c p -c "sb 7" -c p <dev>

And post the output?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
