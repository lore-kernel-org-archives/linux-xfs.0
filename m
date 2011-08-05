Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p75FfIhO125393 for <xfs@oss.sgi.com>; Fri, 5 Aug 2011 10:41:19 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B1B94C7946
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2011 08:41:14 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id vevsjK9DeBJoGkFc
	for <xfs@oss.sgi.com>; Fri, 05 Aug 2011 08:41:14 -0700 (PDT)
Received: by wwi18 with SMTP id 18so1886278wwi.32
	for <xfs@oss.sgi.com>; Fri, 05 Aug 2011 08:41:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjVPJmXAFDmWM4K6n5b36PutV1JOkRMzLqeipZkY8AhAg@mail.gmail.com>
References: <4E3BA2F7.4080500@oracle.com>
	<CAOQ4uxjVPJmXAFDmWM4K6n5b36PutV1JOkRMzLqeipZkY8AhAg@mail.gmail.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Fri, 5 Aug 2011 11:40:42 -0400
Message-ID: <CAGpXXZKUmrWoj1F3PjwE2Yq0oYx2_0JLX3x_kxRBBA-Uk4h4OQ@mail.gmail.com>
Subject: Re: [PATCH] snapshot, defragment and raid test cases for btrfs
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: Anand Jain <Anand.Jain@oracle.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Aditya Dani <aditya.dani@gmail.com>, Chris Mason <chris.mason@oracle.com>

On Fri, Aug 5, 2011 at 9:53 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Hi Anand,
>
> Can you please post the patch in the body of the message so we can
> comment on it inline.
>
> Aditya is also working on a btrfs snapshots xfstest (currently named
> 257) as part of
> his Google summer of code project.
>
> It would be great if you guys can cooperate your efforts.
>
> BTW, while running Aditya's test, Greg has stumbled upon a btrfs OOPS.
> Greg can provide more details about it.
>
> Cheers,
> Amir.
>
> On Fri, Aug 5, 2011 at 10:59 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>>
>> Hi,
>>
>> =A0Attached is the patch for the xfstests, which adds snapshot,
>> =A0defragment and volume management test cases for the btrfs
>> =A0(257, 258 and 259 respectively).
>>
>> =A0This introduces a new user variable 'DISK_POOL' which should
>> =A0be set to disks for the raid tests.
>>
>> =A0An example of usage of these tests is as below.
>> ------------
>> [root@localhost xfstests]# cat local.config
>> TEST_DEV=3D"/dev/sdd"
>> TEST_DIR=3D/btrfs
>> SCRATCH_DEV=3D"/dev/sde"
>> SCRATCH_MNT=3D/btrfs1
>> DISK_POOL=3D"/dev/sdf /dev/sdg"
>> [root@localhost xfstests]#
>>
>> [root@localhost xfstests]# ./check 257 258 259
>> FSTYP -- btrfs
>> PLATFORM -- Linux/i686 localhost 3.0.0-rc6+
>> MKFS_OPTIONS -- /dev/sde
>> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 /dev/sde /btrfs1
>>
>> 257 8s
>> 258 3s
>> 259 33s
>> Ran: 257 258 259
>> Passed all 3 tests
>> ----------------
>>
>> =A0Thank you.
>>
>> Anand
>>

Anand,

I've only reproduced the oops in 2.6.39 and older using openSUSE 11.4 users=
pace.

I have not tried with 3.0 or newer nor with newer userspace, so it may
or may not have been fixed.

It happened with a openSUSE kernel, so I put it in their bugzilla.

https://bugzilla.novell.com/show_bug.cgi?id=3D705039

Just yesterday, I put the actual full recreate details in the
bugzilla.  They are:

=3D=3D=3D
I was working the xfstests git tree cloned via:

git clone https://github.com/adityadani/xfstests

# Then, get an older commit that apparently has a userspace bug that
triggers a kernel oops.

git checkout 1b712a4512d63502fab6

# Then prep for the test

export TEST_DEV=3D/dev/sda3
export TEST_DIR=3D/xfstests_mnt
export SCRATCH_DEV=3D/dev/sda1
export SCRATCH_MNT=3D/xfstests_mnt_scratch
export FSTYP=3Dbtrfs

umount $TEST_DIR
umount $SCRATCH_MNT

mkfs.btrfs $TEST_DEV
mkfs.btrfs $SCRATCH_DEV

mount $TEST_DEV $TEST_DIR
mount $SCRATCH_DEV $SCRATCH_MNT

# Then run the test

./check 255

I didn't keep the oops, but it seems reproducible enough.

The oops was also put into the kde-oops catcher.
=3D=3D=3D

I don't know what aspect of that test triggers the oops.  But the
latest version of test does not trigger it.

The latest version of that test in Aditya's tree has been changed to
test 256.  Sounds like that will change to at least 260 before it gets
submitted.

Hope that helps,
Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
