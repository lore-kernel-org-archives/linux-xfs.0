Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o85D7YCs115893 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 08:07:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A985B1D81E38
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 06:08:12 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	k1ipqJrXWlZU2y9V for <xfs@oss.sgi.com>;
	Sun, 05 Sep 2010 06:08:12 -0700 (PDT)
Date: Sun, 5 Sep 2010 23:08:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS status update for August 2010
Message-ID: <20100905130809.GI705@dastard>
References: <20100902145959.GA27887@infradead.org>
	<20100905074457.GC16004@1wt.eu> <201009051137.07678@zmi.at>
	<20100905104739.GC27623@1wt.eu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100905104739.GC27623@1wt.eu>
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
To: Willy Tarreau <w@1wt.eu>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Sun, Sep 05, 2010 at 12:47:39PM +0200, Willy Tarreau wrote:
> On Sun, Sep 05, 2010 at 11:37:03AM +0200, Michael Monnerie wrote:
> > On Sonntag, 5. September 2010 Willy Tarreau wrote:
> > > I've just installed 2.6.35.4
> > 
> > Try the following mount options: 
> > relatime,logbufs=8,logbsize=256k,attr2,barrier,largeio,swalloc,delaylog

FYI:
	- relatime,logbufs=8,attr=2,barrier are all defaults.
	- largeio only affects stat(2) output if you have
	  sunit/swidth set - unlikely on a laptop drive, and has
	  no effect on unlink performance.
	- swalloc only affects allocation if sunit/swidth are set
	  and has no effect on unlink performance.

> Ah thanks for the info Michael, indeed it's a *lot* better: down from 57s
> to 1.3s !

	- delaylog is the option providing that improvement.

You should keep in mind that delaylog is a brand new experimental
feature (as it warns in dmesg output on mount) and as such has the
potential to eat your data. That being said, I've been running
my laptop and my production machines (except for the backup target)
for a couple of months now with it and haven't had any problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
