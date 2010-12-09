Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9B9cUx238856 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 05:09:38 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B6921D80E8
	for <xfs@oss.sgi.com>; Thu,  9 Dec 2010 03:11:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2oaAii4xP99OmyQL for
	<xfs@oss.sgi.com>; Thu, 09 Dec 2010 03:11:26 -0800 (PST)
Date: Thu, 9 Dec 2010 12:11:20 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] Add test 248: Check filesystem FITRIM implementation
In-Reply-To: <alpine.LFD.2.00.1012091148140.2731@dhcp-lab-213.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.1012091206080.2731@dhcp-lab-213.englab.brq.redhat.com>
References: <1290780743-12112-1-git-send-email-lczerner@redhat.com>
	<4D0065E6.6010009@sandeen.net>
	<alpine.LFD.2.00.1012091148140.2731@dhcp-lab-213.englab.brq.redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: hch@infradead.org, Eric Sandeen <sandeen@sandeen.net>, esandeen@redhat.com, xfs@oss.sgi.com

On Thu, 9 Dec 2010, Lukas Czerner wrote:

> On Wed, 8 Dec 2010, Eric Sandeen wrote:
> 
> > On 11/26/10 8:12 AM, Lukas Czerner wrote:
> > > FITRIM ioctl  is used on a mounted filesystem to discard (or "trim")
> > > blocks which are not in use by the filesystem.  This is useful for
> > > solid-state drives (SSDs) and thinly-provi-sioned storage. This test
> > > helps to verify filesystem FITRIM implementation to assure that it
> > > does not corrupts data.
> > > 
> > > This test creates checksums of all files in /usr/share/doc directory and
> > > run several processes which clear its working directory on SCRATCH_MNT,
> > > then copy everything from /usr/share/doc into its working directory, create
> > > list of files in working directory and its checksums and compare it with the
> > > original list of checksums. Every process works in the loop so it repeat
> > > remove->copy->check, while fstrim tool is running simultaneously.
> > > 
> > > Fstrim is just a helper tool which uses FITRIM ioctl to actually do the
> > > filesystem discard.
> > > 
> > > I found this very useful because when the FITRIM is really buggy (thus
> > > data-destroying) the 248 test will notice, because checksums will most
> > > likely change.
> > > 
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> -snip-
> 
> > > +
> > > +fstrim_loop()
> > > +{
> > > +	trap "_destroy_fstrim; exit \$status" 2 15
> > > +	fsize=$(df | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $2}')
> > > +
> > > +	while true ; do
> > > +		step=1048576
> > > +		start=0
> > > +		$here/src/fstrim $SCRATCH_MNT &
> > > +		fpid=$!
> > > +		wait $fpid
> > > +		while [ $start -lt $fsize ] ; do
> > > +			$here/src/fstrim -s ${start}k -l ${step}k $SCRATCH_MNT &
> > > +			fpid=$!
> > > +			wait $fpid
> > > +			start=$(( $start + $step ))
> > > +		done
> > 
> > I may be dense here but 
> > 
> > a) why do you background and then immediately wait?
> > b) does this start a whole-device trim followed by several
> > smaller range-trims?

I forgot about this one. The reason for this is, that this way we can
get better test coverage of the kernel code, because the code path of
smaller trims (especially not ag-aligned) might be slightly different,
so we test that case as well.

-Lukas

> > 
> > I could do with some comments, I suppose.
> 
> Hi Eric,
> 
> all the waiting is done because Bash is incredibly stupid. As you know,
> fstrim_loop is run at background and when the test is over, or when it
> is killed (with ^C), because of trap, it tries to kill fstrim_loop.
> However, it does not kill currently running commands, so fstrim might be
> still running making it impossible to umount the SCRATCH_MNT.
> 
> So this way, I can kill the running process directly. I believe I am not
> the first one running into this troubles, so maybe there is a better way
> ?
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
