Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1LFqfpP159190 for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 09:52:41 -0600
Date: Mon, 21 Feb 2011 16:55:20 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v4] Add test 249: Check filesystem FITRIM
 implementation
In-Reply-To: <1298302928.7713.4.camel@doink>
Message-ID: <alpine.LFD.2.00.1102211653210.5715@dhcp-27-109.brq.redhat.com>
References: <1297269377-21893-1-git-send-email-lczerner@redhat.com>
	<alpine.LFD.2.00.1102211352330.8461@dhcp-27-109.brq.redhat.com>
	<1298302928.7713.4.camel@doink>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Mon, 21 Feb 2011, Alex Elder wrote:

> On Mon, 2011-02-21 at 14:37 +0100, Lukas Czerner wrote:
> > On Wed, 9 Feb 2011, Lukas Czerner wrote:
> > 
> > > FITRIM ioctl  is used on a mounted filesystem to discard (or "trim")
> > > blocks which are not in use by the filesystem.  This is useful for
> > > solid-state drives (SSDs) and thinly-provi-sioned storage. This test
> > > helps to verify filesystem FITRIM implementation to assure that it
> > > does not corrupts data.
> > > 
> > > This test creates checksums of all files in xfstests directory and
> > > run several processes which clear its working directory on SCRATCH_MNT,
> > > then copy everything from xfstests into its working directory, create
> > > list of files in working directory and its checksums and compare it with the
> > > original list of checksums. Every process works in the loop so it repeat
> > > remove->copy->check, while fstrim tool is running simultaneously.
> > > 
> > > Fstrim is just a helper tool which uses FITRIM ioctl to actually do the
> > > filesystem discard.
> > > 
> > > I found this very useful because when the FITRIM is really buggy (thus
> > > data-destroying) the 249 test will notice, because checksums will most
> > > likely change.
> > 
> > Hello,
> > 
> > I know that there has been some problems with this in the past, but I
> > would be REALLY pleased if it should just go in already. The test number
> > probably needs to be updated, though.
> 
> Lukas, I will commit this for you.  Either later today or
> tomorrow.  It was ready to go last week but I was preoccupied
> with getting my metadump patch series wrapped up.  I'm done with
> that now (waiting for a review).
> 
> I will update the test number to suit the latest code before I
> commit it.  Thank you for your work on it, and for your patience.
> I'm sorry you've had to wait so long for this.
> 
> 					-Alex

Thanks Alex, I appreciate it.

-Lukas

> 
> > The thing is, that more and more batched discard implementations are
> > popping up and I do not even know if, or how, they are testing it. And
> > I just can not keep pointing them to the patch in the mailing list.
> > 
> > I know that that is probably mainly my fault, because of the
> > imperfections of the test, but *I hope* it should be all sorted out now
> > (except of test number obviously!). Could you please consider merging it
> > in ?
> > 
> > Thanks!
> > -Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
