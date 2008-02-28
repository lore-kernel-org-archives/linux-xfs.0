Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Feb 2008 19:14:53 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1S3EgSw018433
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 19:14:46 -0800
Date: Thu, 28 Feb 2008 14:16:33 +1100
Subject: Re: Linux XFS filesystem corruption (XFS_WANT_CORRUPTED_GOTO)
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <Pine.LNX.4.64.0802221718430.13471@toro.qb3.berkeley.edu> <47C343D1.30304@sandeen.net> <Pine.LNX.4.64.0802251447390.20825@toro.qb3.berkeley.edu> <Pine.LNX.4.64.0802271441390.19923@toro.qb3.berkeley.edu>
Message-ID: <op.t67spv073jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802271441390.19923@toro.qb3.berkeley.edu>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: slaton <slaton@berkeley.edu>, xfs-oss <xfs@oss.sgi.com>

On Thu, 28 Feb 2008 09:44:04 +1100, slaton <slaton@berkeley.edu> wrote:

> Hi,
>
> I'm still hoping for some help with this. Is any more information needed
> in addition to the ksymoops output previously posted?
>
> In particular i'd like to know if just remounting the filesystem (to
> replay the journal), then unmounting and running xfs_repair is the best
> course of action. In addition, i'd like to know what recommended
> kernel/xfsprogs versions to use for best results.

I would get xfsprogs 2.9.4 (2.9.6 is not a good version with your kernel),
ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/xfsprogs_2.9.4-1.tar.gz

To be on the safe side, either make an entire copy of your drive to
another device, or run "xfs_metadump -o /dev/sda1" to capture
a metadata (no file data) of your filesystem.

Then run xfs_repair (mount/unmount maybe required if the log is dirty).

If the filesystem is in a bad state after the repair (eg. everything in
lost+found), email the xfs_repair log and request further advise.

Regards,
Barry.


> thanks
> slaton
>
> Slaton Lipscomb
> Nogales Lab, Howard Hughes Medical Institute
> http://cryoem.berkeley.edu
>
> On Mon, 25 Feb 2008, slaton wrote:
>
>> Thanks for the reply.
>>
>> > Are you hitting http://oss.sgi.com/projects/xfs/faq.html#dir2 ?
>>
>> Presumably not - i'm using 2.6.17.11, and that information indicates the
>> bug was fixed in 2.6.17.7.
>>
>> I've attached the output from running ksymoops on messages.1. First
>> crash/trace (Feb 21 19:xx) corresponds to the original XFS event; the
>> second (Feb 22 15:xx) is the system going down when i tried to unmount  
>> the
>> volume.
>>
>> Here are the additional syslog msgs corresponding to the Feb 22 15:xx
>> crash.
>>
>> Feb 22 15:47:13 qln01 kernel: grsec: From 10.0.2.93: unmount of  
>> /dev/sda1
>> by /bin/umount[umount:18604] uid/euid:0/0 gid/egid:0/0, parent
>> /bin/bash[bash:31972] uid/euid:0/0 gid/egid:0/0
>> Feb 22 15:47:14 qln01 kernel: xfs_force_shutdown(sda1,0x1) called from
>> line 338 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff88173ce4
>> Feb 22 15:47:14 qln01 kernel: xfs_force_shutdown(sda1,0x1) called from
>> line 338 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff88173ce4
>> Feb 22 15:47:28 qln01 kernel: BUG: soft lockup detected on CPU#0!
>>
>> thanks
>> slaton
>
>
