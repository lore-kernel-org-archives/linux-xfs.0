Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4OAIWRB065874 for <xfs@oss.sgi.com>; Tue, 24 May 2011 05:18:32 -0500
Received: from mail-pw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7D67D12644
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 03:18:31 -0700 (PDT)
Received: from mail-pw0-f53.google.com (mail-pw0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id zIH8RObPz3b1NTlf
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 03:18:31 -0700 (PDT)
Received: by pwj5 with SMTP id 5so3467988pwj.26
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 03:18:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110524075404.GG32466@dastard>
References: <BANLkTikNMrFzxJF4a86ZM55r3D=ThPFmOw@mail.gmail.com>
	<20110524000243.GB32466@dastard>
	<BANLkTinJecB+CB-n0Au=yaUFLDiDUwhzwg@mail.gmail.com>
	<20110524075404.GG32466@dastard>
From: Nuno Subtil <subtil@gmail.com>
Date: Tue, 24 May 2011 03:18:11 -0700
Message-ID: <BANLkTikj_ZY9g3mSmKAAv=qRaSvNQN=B3A@mail.gmail.com>
Subject: Re: XFS umount issue
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, May 24, 2011 at 00:54, Dave Chinner <david@fromorbit.com> wrote:

...

>> > Ok, so there's nothing here that actually says it's an unmount
>> > error. More likely it is a vmap problem in log recovery resulting in
>> > aliasing or some other stale data appearing in the buffer pages.
>> >
>> > Can you add a 'xfs_logprint -t <device>' after the umount? You
>> > should always see something like this telling you the log is clean:
>>
>> Well, I just ran into this again even without using the script:
>>
>> root@howl:/# umount /dev/md5
>> root@howl:/# xfs_logprint -t /dev/md5
>> xfs_logprint:
>> =A0 =A0 data device: 0x905
>> =A0 =A0 log device: 0x905 daddr: 488382880 length: 476936
>>
>> =A0 =A0 log tail: 731 head: 859 state: <DIRTY>
>>
>>
>> LOG REC AT LSN cycle 1 block 731 (0x1, 0x2db)
>>
>> LOG REC AT LSN cycle 1 block 795 (0x1, 0x31b)
>
> Was there any other output? If there were valid transactions between
> the head and tail of the log xfs_logprint should have decoded them.

There was no more output here.

>
>> I see nothing in dmesg at umount time. Attempting to mount the device
>> at this point, I got:
>>
>> [ =A0764.516319] XFS (md5): Mounting Filesystem
>> [ =A0764.601082] XFS (md5): Starting recovery (logdev: internal)
>> [ =A0764.626294] XFS (md5): xlog_recover_process_data: bad clientid 0x0
>
> Yup, that's got bad information in a transaction header.
>
>> [ =A0764.632559] XFS (md5): log mount/recovery failed: error 5
>> [ =A0764.638151] XFS (md5): log mount failed
>>
>> Based on your description, this would be an unmount problem rather
>> than a vmap problem?
>
> Not clear yet. I forgot to mention that you need to do
>
> # echo 3 > /proc/sys/vm/drop_caches
>
> before you run xfs_logprint, otherwise it will see stale cached
> pages and give erroneous results..

I added that before each xfs_logprint and ran the script again. Still
the same results:

...
+ mount /store
+ cd /store
+ tar xf test.tar
+ sync
+ umount /store
+ echo 3
+ xfs_logprint -t /dev/sda1
xfs_logprint:
    data device: 0x801
    log device: 0x801 daddr: 488384032 length: 476936

    log tail: 2048 head: 2176 state: <DIRTY>


LOG REC AT LSN cycle 1 block 2048 (0x1, 0x800)

LOG REC AT LSN cycle 1 block 2112 (0x1, 0x840)
+ mount /store
mount: /dev/sda1: can't read superblock

Same messages in dmesg at this point.

> You might want to find out if your platform needs to (and does)
> implement these functions:
>
> flush_kernel_dcache_page()
> flush_kernel_vmap_range()
> void invalidate_kernel_vmap_range()
>
> as these are what XFS relies on platforms to implement correctly to
> avoid cache aliasing issues on CPUs with virtually indexed caches.

Is this what /proc/sys/vm/drop_caches relies on as well?

flush_kernel_dcache_page is empty, the others are not but are
conditionalized on the type of cache that is present. I wonder if that
is somehow not being detected properly. Wouldn't that cause other
areas of the system to misbehave as well?

Nuno

>
>> I've tried adding a sync before each umount, as well as testing on a
>> plain old disk partition (i.e., without going through MD), but the
>> problem persists either way.
>
> The use of sync before unmount implies it is not an unmount problem,
> and ruling out MD is also a good thing to know.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
