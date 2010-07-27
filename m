Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R3P97v160424 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 22:25:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F4DD12BAC2E
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 20:35:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	hwSJEzQXXv7pTIUy for <xfs@oss.sgi.com>;
	Mon, 26 Jul 2010 20:35:29 -0700 (PDT)
Date: Tue, 27 Jul 2010 13:28:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs: cannot (re)set log sunit=0
Message-ID: <20100727032808.GM7362@dastard>
References: <20100726101238.GA7725@darkside.kls.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100726101238.GA7725@darkside.kls.lan>
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
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, xfs@oss.sgi.com

On Mon, Jul 26, 2010 at 12:12:39PM +0200, Mario 'BitKoenig' Holbe wrote:
> Hello,
> 
> I intend to set up a XFS filesystem on a RAID0 (Linux md) with 512k
> Chunk Size. Since I cannot align the log section sunit to 512k, and
> since the filesystem will have not much write activity anyways (in fact,
> it'll be mounted read-only most of the time), I tried not to align the
> log section sunit at all via -l sunit=0, but this does not appear to
> work:

Of course - when you specific a value yourself, it has to be a valid
value and for version 2 logs that minimum value for th lsunit is one
log block.  Given that:

....
> log      =internal log           bsize=4096   blocks=2560, version=2
....
                                   ^^^^^^^^^^
Your log block size is 4k, then:

> Is this a bug or a feature?
> 
> The minimum I was able to limit the log sunit to was -l sunit=8, i.e. 1
> block.

This is the correct minimum you are allowed to specify.

> Is there a difference between sunit=0 and sunit=1 in practice or
> are single log entries aligned to blocks anyways?

sunit=0 is an invalid configuration for a version 2 log. Filesystems
without a data sunit default to a lsunit = 1 log block, so in
practice version 2 logs are always aligned/padded in some way.

> Btw...
> Since the filesystem is mostly read-only, I was also thinking about
> reducing the size of the log section. The planned filesystem will be
> 5.5T or bigger, which results in 2G log section per default. I thought
> about limiting it to 128M or 64M. There will be no concurrent write
> activity on the fs. Together with the zero-alignment, what do you think
> about that?

That'll be fine - the maximum log size until a couple of years ago
was 128MB, and I still do most of my benchmarking with a log that
size....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
