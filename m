Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAN03IEH180474 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:03:18 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F9EF26EDD8
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:03:16 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	AHL7PkGV6QEbhfdC for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 16:03:16 -0800 (PST)
Received: by iaen33 with SMTP id n33so915791iae.26
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:03:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECC19C3.5070905@sandeen.net>
References: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
	<CAF3hT9AurrVi7xosauVmhQcsbqJgLsxkNYm6dWDNCpB+GR69=w@mail.gmail.com>
	<20111122014114.GJ2386@dastard>
	<CAF3hT9Cu+56WJqzHVu+fMgquddwoMsfW-WC8CvRRBtC4PA3uHw@mail.gmail.com>
	<4ECBEF83.5020607@sandeen.net>
	<CAF3hT9CA23aDfYTF__mVEM7jRq=ZEgqhfX49hK9kcBqM_+h0CQ@mail.gmail.com>
	<4ECC19C3.5070905@sandeen.net>
Date: Tue, 22 Nov 2011 16:03:15 -0800
Message-ID: <CAF3hT9D1hGh0sj-v4S5tjZBAiztO3OwddSK2dgt8QVLkcWP77A@mail.gmail.com>
Subject: Re: EFSCORRUPTED on mount?
From: Gregory Farnum <gregory.farnum@dreamhost.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>

On Tue, Nov 22, 2011 at 1:53 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> And this was the first indication of trouble.
>
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.214692]
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.227313] Pid: 11196, comm:
>> ceph-osd Not tainted 3.1.0-dho-00004-g1ffcb5c-dirty #1
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.235056] Call Trace:
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.237530]
>> [<ffffffff811d606e>] ? xfs_free_ag_extent+0x4e3/0x698
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.243717]
>> [<ffffffff811d6b71>] ? xfs_free_extent+0xb6/0xf9
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.249468]
>> [<ffffffff811d3034>] ? kmem_zone_alloc+0x58/0x9e
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.255220]
>> [<ffffffff812095f9>] ? xfs_trans_get_efd+0x21/0x2a
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.261159]
>> [<ffffffff811e2011>] ? xfs_bmap_finish+0xeb/0x160
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.266993]
>> [<ffffffff811f8634>] ? xfs_itruncate_extents+0xe8/0x1d0
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.273361]
>> [<ffffffff811f879f>] ? xfs_itruncate_data+0x83/0xee
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.279362]
>> [<ffffffff811cb0a2>] ? xfs_setattr_size+0x246/0x36c
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.285363]
>> [<ffffffff811cb1e3>] ? xfs_vn_setattr+0x1b/0x2f
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.291031]
>> [<ffffffff810e7875>] ? notify_change+0x16d/0x23e
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.296776]
>> [<ffffffff810d2982>] ? do_truncate+0x68/0x86
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.302172]
>> [<ffffffff810d2b11>] ? sys_truncate+0x171/0x173
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.307846]
>> [<ffffffff8166c07b>] ? system_call_fastpath+0x16/0x1b
>> Nov 17 16:01:01 cephstore6358 kernel: [ =A0214.314031] XFS (sdg1):
>> xfs_do_force_shutdown(0x8) called from line 3864 of file
>> fs/xfs/xfs_bmap.c. =A0Return address =3D 0xffffffff811e2046
>
> by here it had shut down, and you were just riding along when
> it went kablooey. =A0Any non-xfs error just before this point?

Nope, nothing from anybody else.


On Tue, Nov 22, 2011 at 2:11 PM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> On Tue, Nov 22, 2011 at 10:47:24AM -0800, Gregory Farnum wrote:
>> Barriers on (at least, nobody turned them off); the RAID card is
>> battery-backed; here are megacli dumps:
>> http://pastebin.com/yTskgzWG
>> http://pastebin.com/ekhczycy
>
> I had a lot of of issues with megaraid cards and their unsafe caching
> settings, up to the point that I'd recommend staying away from them
> now. =A0Can you check in the megacli config if the _disk_ write caches
> are enabled? =A0megaraid adapters used to do that a lot, and given that
> the disk cache isn't batter backed it's fairly fatal.
>
> I think in your dump this one might be the culprit given that SATA
> disks outside of a few niches come with a writeback cache policy:
>
> Disk Cache Policy: Disk's Default
>
> try changing that to an explicit writethrough mode - and maybe try
> running a crash data integrity test like
>
> =A0 =A0 =A0 =A0http://www.complang.tuwien.ac.at/anton/hdtest/
>
> on this controller.
We're going to look into this in more detail very shortly. Right now
all I can tell you is that none of the drives ever actually lost
power, so unless something is explicitly telling them to clear their
caches I don't know how the drives could have lost their cache to
cause a problem like this.
But for now I'll just see what I can get by zeroing out the log, and
we'll get back to you again if we manage to reproduce this in a
situation where we can tell you more definitively about the caching
and barriers.
Thanks guys,
-Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
