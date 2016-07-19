Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9FB7C7CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 18:46:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 637B2304043
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 16:46:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PtJ3SlqiFlzQN5Vy for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2016 16:46:35 -0700 (PDT)
Date: Wed, 20 Jul 2016 09:46:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: remove __arch_pack
Message-ID: <20160719234633.GI16044@dastard>
References: <1466754767-10657-1-git-send-email-hch@lst.de>
	<1466754767-10657-4-git-send-email-hch@lst.de>
	<478743f8-774f-d363-2e3e-40cd0963d8a1@sandeen.net>
	<20160718053746.GA16044@dastard> <20160719085208.GA21785@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160719085208.GA21785@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Jul 19, 2016 at 10:52:08AM +0200, Christoph Hellwig wrote:
> 
> On Mon, Jul 18, 2016 at 03:37:46PM +1000, Dave Chinner wrote:
> > > The reason I did this in the first place was a vague notion that unconditional
> > > packing was harmful.
> > > 
> > > http://digitalvampire.org/blog/index.php/2006/07/31/why-you-shouldnt-use-__attribute__packed/
> > > 
> > > "However, it's actively harmful to add the attribute to a structure that's
> > > already going to be laid out with no padding."
> > > ...
> > > "gcc gets scared about unaligned accesses and generates six times as much code
> > > (96 bytes vs. 16 bytes)! sparc64 goes similarly crazy, bloating from 12 bytes
> > > to 52 bytes"
> > > 
> > > I don't know if that's (still) correct or not, but that was the reason
> > > for the selective __pack application way back when.  Might be worth
> > > investigating?
> > 
> > Christoph? The first two ptches are fine, but more info is needed
> > for this one...
> 
> I don't have a sparc64 compiler to test unfortunately.  But I can confirm
> that on x86-64 xfs.o is bit to bit identical with or without the patch.

OK, that's probably good enough to go with for now. Thanks for
following up, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
