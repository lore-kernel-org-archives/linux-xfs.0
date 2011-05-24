Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4O6TfoT054517 for <xfs@oss.sgi.com>; Tue, 24 May 2011 01:29:41 -0500
Received: from mail-pw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C710162C65E
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 23:29:39 -0700 (PDT)
Received: from mail-pw0-f53.google.com (mail-pw0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 3gJn6gL5lr5tipoZ
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 23:29:39 -0700 (PDT)
Received: by pwj5 with SMTP id 5so3397877pwj.26
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 23:29:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110524000243.GB32466@dastard>
References: <BANLkTikNMrFzxJF4a86ZM55r3D=ThPFmOw@mail.gmail.com>
	<20110524000243.GB32466@dastard>
From: Nuno Subtil <subtil@gmail.com>
Date: Mon, 23 May 2011 23:29:19 -0700
Message-ID: <BANLkTinJecB+CB-n0Au=yaUFLDiDUwhzwg@mail.gmail.com>
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

Thanks for chiming in. Replies inline below:

On Mon, May 23, 2011 at 17:02, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, May 23, 2011 at 02:39:39PM -0700, Nuno Subtil wrote:
>> I have an MD RAID-1 array with two SATA drives, formatted as XFS.
>
> Hi Nuno. it is probably best to say this at the start, too:
>
>> This is on an ARM system running kernel 2.6.39.
>
> So we know what platform this is occurring on.

Will keep that in mind. Thanks.

>
>> Occasionally, doing an umount followed by a mount causes the mount to
>> fail with errors that strongly suggest some sort of filesystem
>> corruption (usually 'bad clientid' with a seemingly arbitrary ID, but
>> occasionally invalid log errors as well).
>
> So reading back the journal is getting bad data?

I'm not sure. XFS claims it found a bad clientid. I'm not too versed
in filesystems to be able to tell for myself :)

>>
>> The one thing in common among all these failures is that they require
>> xfs_repair -L to recover from. This has already caused a few
>> lost+found entries (and data loss on recently written files). I
>> originally noticed this bug because of mount failures at boot, but
>> I've managed to repro it reliably with this script:
>
> Yup, that's normal with recovery errors.
>
>> while true; do
>> =A0 =A0 =A0 mount /store
>> =A0 =A0 =A0 (cd /store && tar xf test.tar)
>> =A0 =A0 =A0 umount /store
>> =A0 =A0 =A0 mount /store
>> =A0 =A0 =A0 rm -rf /store/test-data
>> =A0 =A0 =A0 umount /store
>> done
>
> Ok, so there's nothing here that actually says it's an unmount
> error. More likely it is a vmap problem in log recovery resulting in
> aliasing or some other stale data appearing in the buffer pages.
>
> Can you add a 'xfs_logprint -t <device>' after the umount? You
> should always see something like this telling you the log is clean:

Well, I just ran into this again even without using the script:

root@howl:/# umount /dev/md5
root@howl:/# xfs_logprint -t /dev/md5
xfs_logprint:
    data device: 0x905
    log device: 0x905 daddr: 488382880 length: 476936

    log tail: 731 head: 859 state: <DIRTY>


LOG REC AT LSN cycle 1 block 731 (0x1, 0x2db)

LOG REC AT LSN cycle 1 block 795 (0x1, 0x31b)

I see nothing in dmesg at umount time. Attempting to mount the device
at this point, I got:

[  764.516319] XFS (md5): Mounting Filesystem
[  764.601082] XFS (md5): Starting recovery (logdev: internal)
[  764.626294] XFS (md5): xlog_recover_process_data: bad clientid 0x0
[  764.632559] XFS (md5): log mount/recovery failed: error 5
[  764.638151] XFS (md5): log mount failed

Based on your description, this would be an unmount problem rather
than a vmap problem?

I've tried adding a sync before each umount, as well as testing on a
plain old disk partition (i.e., without going through MD), but the
problem persists either way.

Thanks,
Nuno

>
> $ xfs_logprint -t /dev/vdb
> xfs_logprint:
> =A0 =A0data device: 0xfd10
> =A0 =A0log device: 0xfd10 daddr: 11534368 length: 20480
>
> =A0 =A0log tail: 51 head: 51 state: <CLEAN>
>
> If the log is not clean on an unmount, then you may have an unmount
> problem. If it is clean when the recovery error occurs, then it's
> almost certainly a problem with you platform not implementing vmap
> cache flushing correctly, not an XFS problem.
>
>> I'm not entirely sure that this is XFS-specific, but the same script
>> does run successfully overnight on the same MD array with ext3 on it.
>
> ext3 doesn't use vmapped buffers at all, so won't show such a
> proble,.
>
>> Has something like this been seen before?
>
> Every so often on ARM, MIPS, etc platforms that have virtually
> indexed caches.
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
