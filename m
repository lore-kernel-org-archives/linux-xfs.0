Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p57EBCmJ027107 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 09:11:12 -0500
Received: from hermes1.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D73B94A636B
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2011 07:11:09 -0700 (PDT)
Received: from hermes1.dur.ac.uk (hermes1.dur.ac.uk [129.234.248.1]) by
	cuda.sgi.com with ESMTP id YBKDZE0cqBMMZ4js for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2011 07:11:09 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <19950.12549.541440.285348@tree.ty.sabi.co.UK>
Date: Tue, 7 Jun 2011 15:09:09 +0100
Subject: Re: I/O hang, possibly XFS, possibly general
In-Reply-To: <201106060929.06814@zmi.at>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
	<19945.24042.711472.158523@tree.ty.sabi.co.UK>
	<201106060929.06814@zmi.at>
From: pg_mh@sabi.co.UK (Peter Grandi)
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

[ ... ]

>> vm/dirty_ratio=2
>> vm/dirty_bytes=400000000
>> 
>> vm/dirty_background_ratio=60
>> vm/dirty_background_bytes=0

> Why dirty_background_ratio=60? This would mean you start to
> write dirty pages only after it reaches 60% of total system
> memory...

Oops, invert 'dirty_background_*' and 'dirty_*', I was writing
from memory and got it the wrong way round. These are BTW my
notes in my 'sysctl.conf', with pointer to a nice discussion:

  # http://www.westnet.com/~gsmith/content/linux-pdflush.htm

  # dirty_ratio
  #   If more than this percentage of active memory is unflushed then
  #   *all* processes that are writing start writing synchronously.
  # dirty_background_ratio
  #   If more than this percentage of active memory is unflushed the
  #   system starts flushing.
  # dirty_expire_centisecs
  #   How long a page can be dirty before it gets flushed.
  # dirty_writeback_centisecs
  #   How often the flusher runs.

  # In 'mm/pagewriteback.c' there is code that makes sure that in effect
  # the 'dirty_background_ratio' must be smaller (half if larger or equal)
  # than the 'dirty_ratio', and other code to put lower limits on
  # 'dirty_writeback_centisecs' and whatever.

> [ ... '*_bytes' and '*_ratio' Maybe you specified both to fit
> older and newer kernels in one example?

Yes. I had written what I thought was a much simpler/neater
change here:

  http://www.sabi.co.uk/blog/0707jul.html#070701

but I currently put in both versions and let the better one win
:-).

>> vm/dirty_expire_centisecs=200
>> vm/dirty_writeback_centisecs=400

> dirty_expire_centisecs to 200 means a sync every 2s, which
> might be good in this specific setup mentioned here,

Not quite, see above. There are times where I think the values
should be the other way round (run the flusher every 2s and
flush pages dirty for more than 4s).

> but not for a generic server.

Uhmmm, I am not so sure. Because I think that flushes should be
related to IO speed, and even on a smaller system 2 seconds of
IO are a lot of data. Quite a few traditional Linux (and Unix)
tunables are set to defaults from a time where hardware was much
slower. I started using UNIX when there was no 'update' daemon,
and I got into the habit which I still have of typing 'sync'
explicitly every now and then, and then when 'update' was
introduced to do 'sync' every 30s there was not a lot of data
one could lose in those 30s.

> That would defeat XFS's in-memory grouping of blocks before
> writeout, and in case of many parallel (slow|ftp) uploads
> could lead to much more data fragmentation, or no?

Well, it depends on what "fragmentation" means here. It is a
long standing item of discussion. It is nice to see a 10GB file
all in one extent, but is it *necessary*?

As long as a file is composed of fairly large contiguous extents
and they are not themselves widely scattered, things are going
to be fine. What matter is the ratio of long seeks to data
reads, and minimizing that is not the same as reducing seeks to
zero.

Now consider two common cases:

  * A file that is written out at speed, say 100-500MB/s. 2-4s
    means that there is an opportunity to allocate 200MB-2GB
    contiguous extents, and with any luck much larger ones.
    Conversely any larger intervals means potentially losing
    200MB-2GB of data. Sure, if they did not want to lose the
    data the user process should be doing 'fdatasync()', but XFS
    in particular is sort of pretty good at doing a mild version
    of 'O_PONIES' where there is a balance between going as fast
    as possible (buffer a lot in memory) and offering *some*
    level of safety (as shown in the tests I did for a fair
    comparison with 'ext3').

  * A file that is written slowly in small chunks. Well,
    *nothing* will help that except preallocate or space
    reservations.

Personally I'd rather have a file system design with space
reservations (on detecting an append-like access pattern) and
truncate-on-close than delayed allocation like XFS; while
delayed allocation seems to work well enough in many cases, it
is not quit "the more the merrier".

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
