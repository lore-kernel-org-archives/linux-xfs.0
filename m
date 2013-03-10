Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 316F77CBF
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 18:03:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FB4D8F804C
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 16:03:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	b0BPzugf1RbuWPNb for <xfs@oss.sgi.com>;
	Sun, 10 Mar 2013 16:03:27 -0700 (PDT)
Date: Mon, 11 Mar 2013 10:03:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests: 301: sparse copy between different
	filesystems/mountpoints on btrfs
Message-ID: <20130310230325.GM23616@dastard>
References: <50F9C331.9000501@oracle.com>
 <513BD2CF.5020204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513BD2CF.5020204@sandeen.net>
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
Cc: Koen De Wit <koen.de.wit@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Mar 09, 2013 at 06:24:47PM -0600, Eric Sandeen wrote:
> On 1/18/13 3:48 PM, Koen De Wit wrote:
> > +}
> > +
> > +_scratch_mount
> > +_create_reflinks_to $TESTDIR2
> > +_scratch_unmount
> > +
> > +mount $TEST_DEV $SCRATCH_MNT
> > +_create_reflinks_to $TESTDIR3
> > +umount $SCRATCH_MNT
> 
> TBH this confuses me, not that it's necessarily wrong (?)
> You mount TEST_DEV on $SCRATCH_MNT which makes my brain hurt a little.
> Then _create_reflinks_to $TESTDIR3 and at that point, um, what's going on,
> what's linking what to where?

Mounting the TEST_DEV on SCRATCH_MNT is almost always a bad thing to
do. The test harness expects TEST_DEV to be mounted on TEST_DIR, not
anywhere else.

If you need multiple scratch filesystems to test cross-device
linkage errors, use loopback devices or make use of the btrfs
scratch device pool...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
