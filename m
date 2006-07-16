Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Jul 2006 08:52:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6GFpaDW008577
	for <xfs@oss.sgi.com>; Sun, 16 Jul 2006 08:51:48 -0700
Date: Mon, 17 Jul 2006 01:50:29 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Bonnie getc reading hitting exact 65536 kb/s
Message-ID: <20060716155029.GR15160733@melbourne.sgi.com>
References: <20060715171304.59053A00A8A@smtp.funpic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060715171304.59053A00A8A@smtp.funpic.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "A. Liemen" <maillist@liemen.net>
Cc: xfs@oss.sgi.com

On Sat, Jul 15, 2006 at 07:13:10PM +0200, A. Liemen wrote:
> Hi,
> 
> during some xfs tuning tests I discovered the following phenomenon. 
> Maybe someone can explain it to me:
> 
> Bonnie++ Reading with getc()... hits exactly an almost constant
> 65536 kbyte/s with only ~15% IO usage.
> 
> iostat and bonnie output can be found under:
> 
> http://alexander.liemen.net/bonnie.txt

Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
storage4     40000M 64890  99 229195  39 105826  24 63895  98 350285  38 361.1   0
                    ^^^^^^^^^                       ^^^^^^^^^

It's cpu bound, not I/O bound. It can't go any faster because it's a
single threaded test....

> CPU usage is 100% (on one of the cpus) but i don't think that's the 
> limiting factor since it hits that 16bit value absolut constantly.

What you are seeing is XFS issuing regular sized I/Os at a constant
throughput.

If you really think this is a 16bit ceiling, see what the block I/O tests
report in iostat - you're getting ~230MB/s for write and 350MB/s for read, so
if iostat is has a bug then you'll see it there.

> Also of interest would be why the random seeks are so bad.

Try creating more than 16 files for youre create/read/delete so
that the runtime is somewhat greater than the timer resolution....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
