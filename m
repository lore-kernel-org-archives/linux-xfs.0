Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:59363 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751020AbdKSWe5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Nov 2017 17:34:57 -0500
Date: Mon, 20 Nov 2017 09:34:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Illegal value 0 for -l sunit option ?
Message-ID: <20171119223453.GM5858@dastard>
References: <alpine.DEB.2.10.1711181547110.14549@gozora.sk>
 <20171118215140.GL5858@dastard>
 <45307a2e-9233-e463-dcad-5b91e5234f4e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45307a2e-9233-e463-dcad-5b91e5234f4e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Vladimir Gozora <c@gozora.sk>, linux-xfs@vger.kernel.org

On Sat, Nov 18, 2017 at 10:23:26PM -0600, Eric Sandeen wrote:
> On 11/18/17 3:51 PM, Dave Chinner wrote:
> > On Sat, Nov 18, 2017 at 04:00:08PM +0100, Vladimir Gozora wrote:
> >> Hello XFS team,
> >>
> >> I'm working on ReaR project (https://github.com/rear/rear) which
> >> aims for bare-metal disaster recovery.
> >> Lately I’ve run across behavior of mkfs.xfs which I don’t really
> >> know if is correct or not.
> >> The thing is that when I try to create XFS file system with
> >> xfsprogs-4.5.0 following commands runs just fine:
> >> mkfs.xfs -f -i size=512 -d agcount=4 -s size=512 -i attr=2 -i
> >> projid32bit=1 -m crc=1 -m finobt=1 -b size=4096 -i maxpct=25 -d
> >> sunit=0 -d swidth=0 -l version=2 -l sunit=0 -l lazy-count=1 -n
> >> size=4096 -n version=2 -r extsize=4096 <destination>
> >> when I try same command with xfsprogs-4.10.0, I get following error:
> >> Illegal value 0 for -l sunit option. value is too small
> > 
> > Yup, old mkfs would accept values that were illegal and could do
> > completly unpredictable things with them. We tightened up the input
> > parsing to only accept valid values xfsprogs in 4.7.0, and in
> > particular this commit is relevant:
> > 
> > commit 2942ff49bdb6df08fb56674215b31c07cfc7c1fd
> > Author: Jan Tulak <jtulak@redhat.com>
> > Date:   Tue Jun 21 12:52:22 2016 +1000
> > 
> >     mkfs: fix -l su minval
> >     
> >     -l su should be in range BBTOB(1) <= L_SU <= XLOG_MAX_RECORD_BSIZE,
> >     because the upper limit is imposed by kernel on iclogbuf: stripe
> >     unit can't be bigger than the log buffer, but the log buffer can
> >     span multiple stripe units. L_SUNIT is changed in the same way.
> >     
> >     Signed-off-by: Jan Tulak <jtulak@redhat.com>
> >     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> >     Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> Honestly, the minimum changed before that - the commit below fixed an
> incorrect minval of XLOG_MIN_RECORD_BSIZE (16k) to "1" -
> which honestly doesn't make much sense to me.

Yeah, that was just plain wrong - I forgot that log stripe unit
could be any integer multiple of the fliesystem block size, not just
the valid sizes of the in-core log buffers. The intent was to remove
the specification of illegal values - many other illegal
values were also caught by that set of commits in 4.7.

> It was 1974d3f1a6495978419d931020f63c9cac8ba230 which changed
> it from accepting min 0 to accepting min XLOG_MIN_RECORD_BSIZE:
> 
>                 { .index = L_SUNIT,
> +                 .minval = BTOBB(XLOG_MIN_RECORD_BSIZE),
> +                 .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
>                   .defaultval = SUBOPT_NEEDS_VAL,
>                 },
> 
> ...
> 
>                                 case L_SUNIT:
> -                                       if (!value || *value == '\0')
> -                                               reqval('l', subopts, L_SUNIT);
>                                         if (lsunit)
>                                                 respec('l', subopts, L_SUNIT);
> -                                       lsunit = getnum(value, 0, 0, false);
> -                                       if (lsunit < 0)
> -                                               illegal(value, "l sunit");
> +                                       lsunit = getnum_checked(value, &lopts,
> +                                                                L_SUNIT);
>                                         lsunitflag = 1;
>                                         break;
> 
> Specifying "0" as a value to mean "no stripe" is how I always
> interpreted these things.

Which you can't actually do for v2 logs.  V2 logs *always* has a
stripe unit set, it's supposed to be a multiple of the filesystem
block size, and it's supposed to be recorded in bytes in the
superblock sb_logsunit.  The thing is, this means that a 4k block
size filesystem would always have a stripe unit of 4k - which is
clearly doesn't - and that would have been a performance regression
vs v1 logs for fsync heavy workloads. I'll come back to this.

ALso, let's not forget that setting lsu = 0 is completely illegal on
devices with a sector size != BBSIZE - the log stripe unit is
supposed to indicate the sector size for such devices, and mkfs will
calculate that automatically based on topology info.

> Not to mention that D_SUNIT accepts 0 without complaint, and  it's
> further compounded/confusing by xfs_info reporting a stripe unit
> of 0 blocks, something it won't accept on a mkfs commandline?
> Makes little sense.

It's perfectly valid to have a zero data stripe unit - it has no
"atomic write" configuration infomration encoded in it. That's why
it's not valid to have a zero log stripe unit for v2 logs - it's
critical information for correct log behaviour.  Let's go
back to the mkfs commit that introduced V2 logs:

commit 73bf5988043fcb9d8981a1d8fb4f9936ba0a0551
Author: Steve Lord <lord@sgi.com>
Date:   Tue Jun 18 20:32:20 2002 +0000

    Bump revision number of version 2 log support

[.....]

+       if (logversion == 2)
+               sbp->sb_logsunit = (lsunit == 0) ? 1 : lsunit;
+       else
+               sbp->sb_logsunit = 0;


IOWs, mkfs has always written a non-zero value into sb_logsunit, and
it's always been a value of 1 when no log stripe unit has been
specified. What's that value of 1 mean, though? It's not a multiple
of the filesystem block size - it's a hack to make v2 logs use a
stripe unit of a single sector. i.e. all the code treats a v2 log
with a sb_logsunit == 1 as though it is a v1 log.  e.g.  when
calculating stripe unit alignemnt padding of log writes in
xlog_sync():

       /* Round out the log write size */
        if (v2 && log->l_mp->m_sb.sb_logsunit > 1) {
                /* we have a v2 stripe unit to use */
                count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
        } else {
                count = BBTOB(BTOBB(count_init));
        }

IOWs, a value of 1 effectively means "use the v1 padding limits".

So, what does XFS_IOC_FSGEOMETRY tell userspace:

        if (new_version >= 4) {
                geo->flags |=
                        (xfs_sb_version_haslogv2(&mp->m_sb) ?
                                XFS_FSOP_GEOM_FLAGS_LOGV2 : 0);
                geo->logsunit = mp->m_sb.sb_logsunit;
        }

It tell userspace whatever is in the superblock.

And what does xfs_info then output?

	 "", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,

Yeah, it assumes the number is in bytes and a multiple of block
size.  IOWs, a log stripe unit of 0 indicates basic block stripe
alignment (i.e. none) for both v1 and v2 logs without a stripe unit
configured. 

Just because xfs_info reports a value of "X" for some paramter, it
does not mean that value of "X" is a valid mkfs CLI parameter.
You can't say "no log stripe unit" on a v2 log. At best we can
define "lsu=0/lsunit=0" to mean "use the default" but then people
are going to complain that "I set it to 0 but mkfs is reporting
4096 and I can't change it".

To summaries: a log stripe value of 0 is illegal, a value of 1 means
means "behave like a v1 log", and any other value means
"use this byte count as the stripe unit".

> I'm not really convinced that a minval of 1 is correct.  The commitlog
> changes the minval but speaks only to the rationale for the maxval, so
> it's no help.

The information is all there in the git history... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
