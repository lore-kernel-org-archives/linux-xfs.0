Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2MsCFn196653 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 17:54:12 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	E8AJ60oDTRG0gTNy for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 15:56:03 -0700 (PDT)
Date: Sat, 3 Nov 2012 09:55:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs filesystem corruption with kernel 2.6.37
Message-ID: <20121102225509.GZ29378@dastard>
References: <CAC=U0a2T_J9Y6WzvWyFfbBSDy__Pr7f4gfQBie2o0VhAm2jCaQ@mail.gmail.com>
	<20121025224713.GF29378@dastard> <34630253.post@talk.nabble.com>
	<20121102012728.GT29378@dastard> <34633803.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <34633803.post@talk.nabble.com>
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
To: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 02, 2012 at 09:34:32AM -0700, Kamal Dasu wrote:
> 
> Dave,
> 
> I see the following. On two different systems with the same want= value.
> Does not seem like a random corruption.
> 
> >attempt to access beyond end of device
> > sda2: rw=0, want=33792081130943048, limit=3147132

0x780dbd80007f248

Once again it's corruption in the upper 32 bits of the 64 bit number.
Those bits should be zero. Perhaps looking at all the trace events
from recovery might give you a closer approximation of where the bad
extent records is found....

> > > Track down where those stray upper bits in the block numbers are
> > > coming from, and you'll have your answer. 
> 
> Where would be the best place to put this check. 

I don't know - you're just just going to have to put cheks
everywhere - from when the extent record is first read from disk, to
where it is modified to where it is backed back into disk format.

> Also on a XFS DEBUG all the asserts seem to be in the unlink (delete path).

No surprise, the failures found when removing open-but-unlinked
files after a crash. i.e. during unlink in the final stage of
recover.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
