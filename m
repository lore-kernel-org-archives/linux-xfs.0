Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p51CbUpL119171 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 07:37:30 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F559165CEF8
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 05:37:28 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id iqrr4EQi4dyka99s
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2011 05:37:28 -0700 (PDT)
Received: by wwf26 with SMTP id 26so4723937wwf.32
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2011 05:37:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikQ=V8MJyuAQsZboCorZwnBSzX=Bg@mail.gmail.com>
References: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>
	<4DE5C1FE.8080006@redhat.com>
	<BANLkTikfjitncM=zLpfTrfQkd8VfQAxbUA@mail.gmail.com>
	<4DE5CC8E.1090208@redhat.com> <4DE5CF6C.4080707@redhat.com>
	<BANLkTimoRUrY7xVnamBT=yFPzafhADA=tA@mail.gmail.com>
	<BANLkTikQ=V8MJyuAQsZboCorZwnBSzX=Bg@mail.gmail.com>
Date: Wed, 1 Jun 2011 15:37:27 +0300
Message-ID: <BANLkTikOtoWJBz+PQ0+=e6466zAntA_f_g@mail.gmail.com>
Subject: Re: [PATCH] xfstests: add support for ext4dev FSTYP
From: Amir Goldstein <amir73il@gmail.com>
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
To: sergey ivanov <sergey57@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, XFS <xfs@oss.sgi.com>

On Wed, Jun 1, 2011 at 2:48 PM, sergey ivanov <sergey57@gmail.com> wrote:
> On Wed, Jun 1, 2011 at 2:37 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> On Wed, Jun 1, 2011 at 8:34 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> > On 6/1/11 12:22 AM, Eric Sandeen wrote:
>> >> On 5/31/11 11:56 PM, Amir Goldstein wrote:
>> >>> On Wed, Jun 1, 2011 at 7:37 AM, Eric Sandeen <sandeen@redhat.com>
>> >>> wrote:
>> >>>> On 5/31/11 10:13 PM, Amir Goldstein wrote:
>> >>>>> From: Amir Goldstein <amir73il@users.sf.net>
>> >>>>>
>> >>>>> blkid knows to identify the ext4dev FSTYP of a partition that was
>> >>>>> formatted with mkfs.ext4dev.
>> >>>>> quota tools and various util-linux utils are also aware of ext4dev,
>> >>>>> so ext4dev shares the same capabilities as ext4.
>> >>>>>
>> >>>>> While testing on Fedora 15, we encoutered a buggy fsck utility,
>> >>>>> which
>> >>>>> invokes fsck.ext4, even though it was called with -t ext4dev
>> >>>>> argument.
>> >>>>> In our setup fsck.ext4dev knows about new fs features that fsck.ex=
t4
>> >>>>> doesn't know, so the generic_fs_check fails.
>> >>>>> Since we have no real use of the extra capabilities provided by fs=
ck
>> >>>>> util,
>> >>>>> we decided to invoke fsck.$FSTYP directly to avoid this issue.
>> >>>>
>> >>>> Adding ext4dev to every case seems harmless enough. =A0TBH I though=
t I
>> >>>> had
>> >>>> it there already but I guess not.
>> >>>>
>> >>>> I'm less certain of the change from fsck -t $FSTYP to fsck.$FSTYP
>> >>>>
>> >>>> What issue are you avoiding? =A0wouldn't fsck -t ext4dev invoke
>> >>>> fsck.ext4dev anyway?
>> >>>>
>> >>>> It seems like it should be harmless, but I don't understand how it
>> >>>> helps you.
>> >>>>
>> >>>
>> >>> As I wrote in the patch description, the fsck utility in Fedora 15
>> >>> invokes
>> >>> fsck.ext4 for some reason when calling fsck -t ext4dev.
>> >>
>> >> Oh, right.
>> >>
>> >>> this fails because fsck.ext4 doesn't know the snapshot feature.
>> >>> I didn't debug fsck utility for that. it seemed pointless.
>> >>
>> >> Did you file a bug with Fedora? =A0I'd rather fix the root cause than
>> >> work around it...
>> >> Feel free to cc: me on the bug.
>>
>> No, I didn't file a bug.
>> In any case, it was Sergey, who tested and reported the problem on F15.
>>
>> Would you agree to fix the problem in xfstests now, so that F15 users can
>> test ext4dev and fix the bug in fsck regardless?
>>
>> >
>> > RHEL6 does the same; mkfs.ext4dev then fsck -t ext4dev invokes
>> > fsck.ext4; but this
>> > is because blkid identifies it as ext4, not ext4dev, despite the test_=
fs
>> > flag being set.
>> >
>> > ISTR this is due to some tortured logic about when ext4dev isn't
>> > ext4dev, but
>> > I don't remember the details... I don't know if this is the same
>> > situation
>> > you're seeing; just to double check - does blkid correctly identify it
>> > as ext4dev
>> > on F15?
>>
>>
>> For me (on Ubuntu) blkid identifies ext4dev, but maybe the tortured logic
>> finds unknown features a justification for declaring ext4dev?
>> Segrey, can you answer the question for F15?
>> Did you set FSTYP to ext4dev manually or did blkid identified it for you?
>
> Amir, Fedora's fsck behaves differently on ext4dev and next4. When I made
> next4 partition on Fedora-15 by
> {{{
> mkfs =A0-t next4 /dev/sdd9
> }}}
> it requires "export FSTYP=3Dnext4" to be defined and exported in local.co=
nf.
> It mounts partition with
> {{{
> mount -t next4 /dev/sdd9 /mnt/sdd9
> }}}
> But on attempt to fsck it calls wrong fsck, as you reported:
> {{{
> [seriv@pimbra xfstests]$ sudo fsck -t next4 /dev/sdd9
> fsck from util-linux 2.19.1
> e2fsck 1.41.14 (22-Dec-2010)
> /dev/sdd9 has unsupported feature(s): FEATURE_C7 FEATURE_C8 FEATURE_R7
> e2fsck: Get a newer version of e2fsck!
> }}}
> And the problem can be easily traced to this wrong call:
> {{{
> [seriv@pimbra xfstests]$ sudo strace -o /var/log/fsck.strace fsck -t next4
> /dev/sdd9
> fsck from util-linux 2.19.1
> e2fsck 1.41.14 (22-Dec-2010)
> /dev/sdd9 has unsupported feature(s): FEATURE_C7 FEATURE_C8 FEATURE_R7
> e2fsck: Get a newer version of e2fsck!
> [seriv@pimbra xfstests]$ grep sbin /var/log/fsck.strace
> execve("/sbin/fsck", ["fsck", "-t", "next4", "/dev/sdd9"], [/* 17 vars */=
])
> =3D 0
> stat("/sbin/fsck.ext4", {st_mode=3DS_IFREG|0755, st_size=3D194280, ...}) =
=3D 0
> }}}
> But it's not the case for ext4dev, with it I even don't need "-t ext4dev",
> it is recognized by blkid:
> {{{
> [seriv@pimbra xfstests]$ sudo mkfs -t ext4dev /dev/sdd9
> mke2fs 1.41.14-next3-1.0.13-7 (24-May-2011)
> [skip]
> This filesystem will be automatically checked every 27 mounts or
> 180 days, whichever comes first. =A0Use tune2fs -c or -i to override.
> [seriv@pimbra xfstests]$ sudo mount /dev/sdd9 /mnt/sdd9
> [seriv@pimbra xfstests]$ mount | grep sdd9
> /dev/sdd9 on /mnt/sdd9 type ext4dev (rw)
> [seriv@pimbra xfstests]$ sudo umount /dev/sdd9
> [seriv@pimbra xfstests]$ sudo fsck /dev/sdd9
> fsck from util-linux 2.19.1
> e2fsck 1.41.14-next3-1.0.13-7 (24-May-2011)
> The test_fs flag is set (and ext4 is available). =A0Clear<y>?
> }}}
> and at this point in another session
> {{{
> [seriv@pimbra xfstests]$ pgrep -f -l fsck
> 4365 sudo fsck /dev/sdd9
> 4366 fsck /dev/sdd9
> 4367 fsck.ext4dev /dev/sdd9
> }}}
> So I'd like this patch to be applied to xfstests to be able to use it on =
the
> different filesystems, - if not, then why have this FSTYP and not rely up=
on
> blkid
> --

To make a long story a bit shorter, there was no intention to set
FSTYP manually,
that was only a temporary hack to make next4 clone work, but since ext4dev =
is
identified by blkid and respected by fsck/mkfs/mount, we are going to
work with it
and not with next4.

So I understood the problem incorrectly and the patch to xfstests doesn't n=
eed
to change fsck -t $FSTYP to fsck.$FSTYP.
I will resend the patch without this change.

Amir.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
