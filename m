Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 May 2007 22:32:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4E5W1fB012122
	for <xfs@oss.sgi.com>; Sun, 13 May 2007 22:32:03 -0700
Date: Mon, 14 May 2007 15:35:31 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: Review: Concurrent Multi-File Data Streams - centisecs
Message-ID: <DB1970150957C36FEE7BB4E1@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <46468148.7000708@sandeen.net>
References: <20070511003606.GB85884050@sgi.com> <p73sla1ev7o.fsf@bingen.suse.de>
 <46468148.7000708@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Yeah, I thought we were told off in the past for not using centisecs
and so Nathan changed stuff so it was in centisecs.

Looking in logs and bug db....

----------------
xfs_sysctl.c
revision 1.28
date: 2004/05/14 03:13:52;  author: nathans;  state: Exp;  lines: +7 -7
modid: xfs-linux:xfs-kern:171825a
Export/import tunable time intervals as centisecs not jiffies.

Description:

Not sure what we were smoking when we made these interfaces
converse with userspace in terms of jiffies, I guess it was
just more expedient at the time.  Time to clean this up so
regular humans know what time intervals they're asking for,
and so that the interface works consistently for different
HZ values.

The kernel pdflush daemon in 2.6 uses centisecs, so we may
as well make our units consistent with that (since that guy
plays a big role in flushing our data & it is likely to be
tuned along with any XFS-specific parameter changes).

cheers.

On Tue, May 11, 2004 at 03:40:57PM -0700, Andrew Morton wrote:
> bart@samwel.tk wrote:
> >
> > The laptop mode control script incorrectly guesses XFS_HZ=1000.
>
> aargh.  XFS is broken.  It shouldn't be exposing jiffy-based tunables into
> /proc, or `mount -o remount' or whatever.
>
> It would be much better to rework XFS so that these user-visible tunables
> are in units of milliseconds, centiseconds or whatever.
>
> Is this possible, please?
>
> If so, please make the /proc filename reflect the tunable's units:
>
>       /proc/sys/fs/xfs/lm_sync_centisecs
>       /proc/sys/fs/xfs/age_buffer_centisecs
>       etc.
>
> thanks.
----------------------------

--Tim





--On 12 May 2007 10:08:56 PM -0500 Eric Sandeen <sandeen@sandeen.net> wrote:

> Andi Kleen wrote:
>
>> Also centisecs is a really ugly unit whose use should be probably not propagated.
>>
>> -Andi
>
> Hmm at one point I thought the preferred unit for this sort of tuneable *was* centisecs.  What's
> the unit du jour?
>
> [root@neon ~]# sysctl -a  |grep cent
> vm.dirty_expire_centisecs = 2999
> vm.dirty_writeback_centisecs = 499
> fs.xfs.age_buffer_centisecs = 1500
> fs.xfs.xfsbufd_centisecs = 100
> fs.xfs.xfssyncd_centisecs = 3000
>
> I think xfs was following the vm lead at one point.
>
> -Eric
