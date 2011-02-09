Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p19CAhI3233259 for <xfs@oss.sgi.com>; Wed, 9 Feb 2011 06:10:43 -0600
Date: Wed, 9 Feb 2011 13:13:09 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v3] Add test 249: Check filesystem FITRIM
 implementation
In-Reply-To: <1297167619.7351.29.camel@doink>
Message-ID: <alpine.LFD.2.00.1102091309560.32212@dhcp-27-109.brq.redhat.com>
References: <1296762207-17265-1-git-send-email-lczerner@redhat.com>
	<1297167619.7351.29.camel@doink>
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
Cc: hch@infradead.org, Lukas Czerner <lczerner@redhat.com>, esandeen@redhat.com, xfs@oss.sgi.com

On Tue, 8 Feb 2011, Alex Elder wrote:

> On Thu, 2011-02-03 at 20:43 +0100, Lukas Czerner wrote:
> > FITRIM ioctl  is used on a mounted filesystem to discard (or "trim")
> > blocks which are not in use by the filesystem.  This is useful for
> > solid-state drives (SSDs) and thinly-provi-sioned storage. This test
> > helps to verify filesystem FITRIM implementation to assure that it
> > does not corrupts data.
> > 
> > This test creates checksums of all files in xfstests directory and
> > run several processes which clear its working directory on SCRATCH_MNT,
> > then copy everything from xfstests into its working directory, create
> > list of files in working directory and its checksums and compare it with the
> > original list of checksums. Every process works in the loop so it repeat
> > remove->copy->check, while fstrim tool is running simultaneously.
> > 
> > Fstrim is just a helper tool which uses FITRIM ioctl to actually do the
> > filesystem discard.
> > 
> > I found this very useful because when the FITRIM is really buggy (thus
> > data-destroying) the 249 test will notice, because checksums will most
> > likely change.
> 
> This sounds like a good test.  I ran it and it failed, but I
> couldn't really tell why.  Turns out the ioctl() returned
> ENOTSUP, which is fine.  But the test shouldn't work quite
> that way.
> 
> Based on this very small experience, I have a few comments,
> below.  I glanced at the C code also, and have a few suggestions
> but they're not that important.
> 
> 					-Alex
> 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  249          |  170 ++++++++++++++++++++++++++++++++++++++
> >  249.out      |    3 +
> >  group        |    3 +-
> >  src/Makefile |    2 +-
> >  src/fstrim.c |  257 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 433 insertions(+), 2 deletions(-)
> >  create mode 100644 249
> >  create mode 100644 249.out
> >  create mode 100644 src/fstrim.c
> > 
> > diff --git a/249 b/249
> > new file mode 100644
> > index 0000000..9943176
> > --- /dev/null
> > +++ b/249
> > @@ -0,0 +1,170 @@
> > +#!/bin/bash
> > +# FS QA Test No. 248
> 
> Unfortunately for you, you'll need to change the number yet again.
> (When the time comes to commit it I'll update the number for you
> if needed.)  I made it number 252 for my own testing.  Remember
> to change the name as well as the content of the test and its
> output file.
> 

One more thing though. Where did you get the number 252 ? This patch
still apply cleanly on the top of the master branch. I am using this
repo: 

git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

Shall I use a different one ? Which one is the most up-to-date ?

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
