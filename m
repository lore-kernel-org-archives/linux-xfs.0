Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 66B8E7F92
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 02:02:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A990AC003
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 00:02:00 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZArRnsG4uoaNxnpF (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 00:02:00 -0700 (PDT)
Date: Tue, 9 Apr 2013 09:01:39 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
	xfstests case #78]
Message-ID: <20130409070139.GS12244@kernel.dk>
References: <20130402071937.GC3670@kernel.dk> <20130402073035.GD3670@kernel.dk>
	<14055702.547701.1364891947331.JavaMail.root@redhat.com>
	<20130402090047.GF3670@kernel.dk>
	<985125161.581860.1364895066584.JavaMail.root@redhat.com>
	<20130402094834.GA4667@kernel.dk> <20130403114142.GP4667@kernel.dk>
	<515C4D9D.10103@ubuntu.com> <515DE2FE.1080201@ubuntu.com>
	<20130409065519.GH17758@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130409065519.GH17758@dastard>
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
Cc: Phillip Susi <psusi@ubuntu.com>, LKML <linux-kernel@vger.kernel.org>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Tue, Apr 09 2013, Dave Chinner wrote:
> On Thu, Apr 04, 2013 at 04:30:54PM -0400, Phillip Susi wrote:
> > > I have not tested it yet, but I am pretty sure it won't work.  It
> > > looks like the patch changes the BLKRRPART path to go ahead and remove
> > > existing partitions when GENHD_FL_NO_PARTSCAN is set.  loop doesn't
> > > issue the BLKRRPART ioctl when !LO_FLAGS_PARTSCAN so this won't help.
> > >  I think loop needs to set GENHD_FL_NO_PARTSCAN and then issue the
> > > ioctl regardless of the LO_FLAGS_PARTSCAN flag to get the partitions
> > > to be removed.  I will try to test tonight.
> > 
> > After testing, my initial thoughts appeared to have been correct.  I had
> > to modify the patch as follows.  To test, simply do:
> > 
> > truncate -s 10m img
> > losetup /dev/loop0 img
> > parted /dev/loop0
> > mklabel msdos
> > mkpart primary ext2 1m 2m
> > quit
> > ls /dev/loop0*
> > 
> > Note the /dev/loop0p1 node.  Run losetup -d /dev/loop0 and see if it is
> > still there.
> 
> Jens, can we get one of these fixes merged quickly? xfstests is
> unusable on any kernel more recent than 3.9-rc4 because of these
> problems....

Yep, did the revert yesterday and it's going out today.

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
