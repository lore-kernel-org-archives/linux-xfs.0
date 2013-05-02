Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D4E317F52
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 20:37:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6944BAC001
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 18:37:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	h9NbWmo9yDMsbJQV for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 18:37:00 -0700 (PDT)
Date: Thu, 2 May 2013 11:36:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix log space reservation calculation if log stripe
	unit is specified
Message-ID: <20130502013632.GV10481@dastard>
References: <51813BA5.3070306@oracle.com>
 <51814578.9060408@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51814578.9060408@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>

On Wed, May 01, 2013 at 11:40:24AM -0500, Mark Tinguely wrote:
> On 05/01/13 10:58, Jeff Liu wrote:
> >Hello,
> >
> >About two weeks ago, Dave has found an issue by running xfstests/297.
> >http://oss.sgi.com/archives/xfs/2013-03/msg00273.html
> >
> >According to our previous discussion, if the log stripe unit is configured, we should
> >take it into account as it will dynamically increase the log reservation twice of it
> >per ticket.
> >
> >This patch is trying to fix it by checking the given log space against the maximum
> >request among those transactions(this procedure is implemented similar to xfsprogs/mkfs/maxres.c),
> >because the fundamental limit is that no single transaction can be larger than half of the log.
> >Also, looks at least another two log stripe unit should be added when calculating the minimum log
> >space, or else I can simply trigger a DEAD LOOP via create large number of files, I think I need
> >some time to digest Dave's comments posted on original bug ticket, i.e.
> >>>>>  The question is this: how much space do we need to reserve. I'm
> >>>>>  thinking a minimum of 4*lsu - 2*lsu for the existing CIL context, and
> >>>>>  another 2*lsu for any queued ticket waiting for space to come
> >>>>>  available.
> >
> >Put simply, with this fix, mount a partition with an improper log space setup vs log stripe
> >unit will failed although mkfs still works. Ah, maybe we can improve the user space xfs_mkfs
> >with some pre-checkup similar to the implementation inside kernel?  Besides that, it will
> >drop a warning to syslog and the suggested log space for the given log stripe unit is shown
> >there, which looks like the following:
> >
> ># mkfs.xfs -f -b size=512 -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b /dev/sdb1
> >meta-data=/dev/sdb1              isize=256    agcount=16, agsize=524288 blks
> >          =                       sectsz=512   attr=2, projid32bit=0
> >data     =                       bsize=512    blocks=8388608, imaxpct=25
> >          =                       sunit=512    swidth=6144 blks
> >naming   =version 2              bsize=4096   ascii-ci=0
> >log      =internal log           bsize=512    blocks=2560, version=2
> >          =                       sectsz=512   sunit=512 blks, lazy-count=1
> >realtime =none                   extsz=4096   blocks=0, rtextents=0
> >
> 
> Shouldn't mkfs.xfs also know it is building a filesystem that cannot
> be mounted?

Yes, it should - this is what mkfs/maxtrres.c does. It looks like some
of this patch came from that code.....

> When mkfs.xfs is given a log stripe unit is greater than 256KB,
> should we divide the specified log stripe unit by 2 until it is
> under 256KB rather than reset to 32KB?

I think if it is specified on the command line, it shoul dbe
rejected. If it's automatically determined from the data device
sunit, then the divide-by-2-until-in-range algorithm seems fine to
me.

> 
> ># mount /dev/sdb1 /xfs1
> >mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
> >        missing codepage or helper program, or other error
> >        In some cases useful info is found in syslog - try
> >        dmesg | tail  or so
> >
> ># dmesg:
> >.......
> >XFS (sdb1): log space of 2560 blocks too small, minimum request 6656
> >XFS (sdb1): log space validation failed
> >XFS (sdb1): log mount failed
> >
> >
> >Tests:
> >Ran some cases in xfstests as well as a few self-defined Bonnie++/FIO tests with above
> >configuration(6656 log blocks), looks the current fix works, at least no crash to me.:)
> >
> >But I have not yet dig into the detailed of how the suggested minimum log space would
> >affect the performance, given that the AIL push thresholds is defined to 25% of the log
> >space, a small logs might introduce IO overheads for pushing AIL too frequently.

That's already a problem of using small logs. That's not something
we need to worry about when trying to determine the minimum valid
log size....

> >In addition, considering the backgroup CIL commit threshold is 1/8 of the log, this would
> >also impact the log IO throughput IMHO.  Maybe we can figure out an optimized log space
> >combine those two cases and drop it to syslog along with the minimum size?

Anyone who cares about metadata performance on their small
filesystems is not going to use a minimum sized log. As it is, on
any filesystem larger than about 50GB using a default log size
(about 25MB for a default mkfs), the log stripe unit simply isn't an
issue...

> I think 1 MB is the smallest log size before we soft hang even
> without stripe units define.

$ sudo mkfs.xfs -f -l size=256b -dsize=1g /dev/vdc
log size 256 blocks too small, minimum size is 512 blocks
$

mkfs won't allow a log size smaller than 2MB for default
configurations.

> >To Dave,
> >
> >Sorry for the delay in drop this patch since I have mentioned that I'll post a fix
> >last night.  However, I have ran into an issue when testing it by creating/removing a
> >tons of files in parallel at that time:(
> 
> The iclog buffers have to be a multiple of the log stripe unit or we
> start punching the lsn in places that it should not. I think the
> idea that was mentioned is to remove the power of two on the iclog
> buffer size and replace with multiple of log stripe unit.
> 
> http://oss.sgi.com/archives/xfs/2013-03/msg00039.html

Right:

| Personally, I'd prefer that logbsize be limited to power-of-2
| multiples of the lsunit or XLOG_MIN_RECORD_BSIZE (if lsunit = 0) as
| allowing arbitrary values to be specified by users leads to a
| testing and bug triage nightmare.

ie I think that the valid values for logbsize are:

32k <= logbsize <= 256k
logbsize = logsunit * 2^N for N that does not violate the first rule.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
