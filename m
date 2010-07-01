Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o610Lg0L156747 for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 19:21:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF45814B426F
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 17:29:24 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	Dr0bbASRspxyQccT for <xfs@oss.sgi.com>;
	Wed, 30 Jun 2010 17:29:24 -0700 (PDT)
Date: Thu, 1 Jul 2010 10:24:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: When it rains it pours....
Message-ID: <20100701002424.GP24712@dastard>
References: <4C2B37D6.50801@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C2B37D6.50801@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Jun 30, 2010 at 05:25:58AM -0700, Linda A. Walsh wrote:
> Due to another bug in lvm, my restore of this partition crashed after running a few
> hours (takes alot longer to restore than to backup).
> 
> So I decided to use the "-R" option to Resume my previously left off dump:
> 
> # xfsrestore -R -p 180 -f /backups/Ishtar/torrents/torrents-100629-0-1611.dump .
>  xfsrestore: using file dump (drive_simple) strategy
>  xfsrestore: version 3.0.4 (dump format 3.0) - Running single-threaded
>  xfsrestore: resuming restore previously begun Wed Jun 30 04:41:57 2010
>  xfsrestore: examining media file 0
>  xfsrestore: seeking past portion of media file already restored
> 
> Looks good so far!..Yup, and..
> 
>  xfsrestore: drive_simple.c:770: do_seek_mark: Assertion `nreadneeded64 <= ( ( intgen_t ) ( ( ( 1ull << ( ( unsigned long long )sizeof( intgen_t ) * ( unsigned long long )8 - ( 1ull + 1ull ))) - 1ull ) * 2ull + 1ull ))' failed.
>  Aborted (core dumped)
> 
> 
> Say what?  Um...is that supposed to be an error message?

No, it's an assert failure. i.e. something a developer considered
fatal and requiring debugging if it ever occurred. It's not an error
message an end user is expected to understand. ;)

> Why can't it just tell me why "'nreadneeded64' > 0xbfffffffffffffd"
> is 'bad', or what it means?

Asserts generally indicate that design constraints or assumptions
have been violated which canbe hard to explain in one line to an end
user....

>From a brief look at the code, it appears that the distance between
the stream offset and the next tape mark is greater than MAXINTGENT.
MAXINTGEN evaluates as 0x7fffffff (more commonly known as INT_MAX).

Normally the file is read mark by mark, but when resuming a restore
we skip from the initial header to the checkpointed file mark in one
step. It seems like marks are normally less that 2GB apart, but
in the case of resuming, the attempt to seek from the header to the
checkpointed mark is way more than 2GB and hence it triggers the
assert.

I'm not sure yet how to fix this - I have't dug into the drive code
in xfs_restore before so it'll take a while to understand well
enough to work out a solution.

In the mean time, I think restarting your restore from scratch is
your best bet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
