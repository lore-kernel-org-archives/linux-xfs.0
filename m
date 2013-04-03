Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 311717FB0
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 06:41:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7EF94AC003
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 04:41:50 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	iKZWB9cMHWbl2wf9 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 04:41:48 -0700 (PDT)
Date: Wed, 3 Apr 2013 13:41:42 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
	xfstests case #78]
Message-ID: <20130403114142.GP4667@kernel.dk>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
	<247719576.438259.1364882929749.JavaMail.root@redhat.com>
	<20130402070537.GP6369@dastard> <20130402071937.GC3670@kernel.dk>
	<20130402073035.GD3670@kernel.dk>
	<14055702.547701.1364891947331.JavaMail.root@redhat.com>
	<20130402090047.GF3670@kernel.dk>
	<985125161.581860.1364895066584.JavaMail.root@redhat.com>
	<20130402094834.GA4667@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130402094834.GA4667@kernel.dk>
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
To: CAI Qian <caiqian@redhat.com>
Cc: psusi@ubuntu.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Apr 02 2013, Jens Axboe wrote:
> On Tue, Apr 02 2013, CAI Qian wrote:
> > 
> > 
> > ----- Original Message -----
> > > From: "Jens Axboe" <axboe@kernel.dk>
> > > To: "CAI Qian" <caiqian@redhat.com>
> > > Cc: "Dave Chinner" <david@fromorbit.com>, xfs@oss.sgi.com, "LKML" <linux-kernel@vger.kernel.org>
> > > Sent: Tuesday, April 2, 2013 5:00:47 PM
> > > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running xfstests case #78]
> > > 
> > > On Tue, Apr 02 2013, CAI Qian wrote:
> > > > 
> > > > 
> > > > ----- Original Message -----
> > > > > From: "Jens Axboe" <axboe@kernel.dk>
> > > > > To: "Dave Chinner" <david@fromorbit.com>
> > > > > Cc: "CAI Qian" <caiqian@redhat.com>, xfs@oss.sgi.com, "LKML"
> > > > > <linux-kernel@vger.kernel.org>
> > > > > Sent: Tuesday, April 2, 2013 3:30:35 PM
> > > > > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5
> > > > > running xfstests case #78]
> > > > > 
> > > > > On Tue, Apr 02 2013, Jens Axboe wrote:
> > > > > > On Tue, Apr 02 2013, Dave Chinner wrote:
> > > > > > > [Added jens Axboe to CC]
> > > > > > > 
> > > > > > > On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> > > > > > > > Saw on almost all the servers range from x64, ppc64 and s390x with
> > > > > > > > kernel
> > > > > > > > 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks
> > > > > > > > like
> > > > > > > > something new broke this. Log is here with sysrq debug info.
> > > > > > > > http://people.redhat.com/qcai/stable/log
> > > > > > 
> > > > > > CAI Qian, can you try and back the below out and test again?
> > > > > 
> > > > > Nevermind, it's clearly that one. The below should improve the
> > > > > situation, but it's not pretty. A better fix would be to allow
> > > > > auto-deletion even if PART_NO_SCAN is set.
> > > > Jens, when compiled the mainline (up to fefcdbe) with this patch,
> > > > it error-ed out,
> > > 
> > > Looks like I sent the wrong one, updated below.
> > The patch works well. Thanks!
> 
> Thanks for testing! I don't particularly like this stuff in loop,
> though. It's quite nasty and depends on other behaviour. It would be
> prettier if we just had rescan_partitions() do the right thing, and only
> drop partitions and not rescan if NO_PART_SCAN is set.
> 
> Ala the below, dropping the loop change and implementing that change in
> the core code. Phillip, can you check whether this does the right thing
> for your bug too?

Phillip? I'm going to revert the loop change asap, so if you want this
fixed for 3.10, it's about that time to test it out.

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
