Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4I8J6ml227457 for <xfs@oss.sgi.com>; Wed, 18 May 2011 03:19:06 -0500
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 402811E2DE82
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 01:19:04 -0700 (PDT)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	Ka8S5kY3a3zsjTFI for <xfs@oss.sgi.com>;
	Wed, 18 May 2011 01:19:04 -0700 (PDT)
Received: by eyh5 with SMTP id 5so396454eyh.26
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 01:19:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110518063153.GZ19446@dastard>
References: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
	<4DD286E5.8090105@redhat.com>
	<BANLkTi=pZS6sTjS61UmpbOsj+vF+ithVvw@mail.gmail.com>
	<20110518063153.GZ19446@dastard>
Date: Wed, 18 May 2011 11:19:03 +0300
Message-ID: <BANLkTin_POPtikx-4zaVsW181bnXKP6k1Q@mail.gmail.com>
Subject: Re: xfstests: device busy when umount
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, May 18, 2011 at 9:31 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, May 17, 2011 at 06:01:14PM +0300, Amir Goldstein wrote:
>> On Tue, May 17, 2011 at 5:32 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> > On 5/17/11 4:03 AM, Yongqiang Yang wrote:
>> >> Hi,
>> >>
>> >> I noticed that all tests which contain 'device busy' errors have
>> >> falloc operations. =A0Does the error have something to do with falloc?
>
> <shrug>
>
> Perhaps a bit more detail about what you are testing, how you've set
> up xfstests, etc, and some analysis of the problem is in order first?

<shrug>^2

Let me make it simple:

amir@qalab:~/xfstests$ uname -a
Linux qalab 2.6.39-rc7+ #11 SMP Mon May 16 12:08:52 IDT 2011 x86_64
x86_64 x86_64 GNU/Linux
amir@qalab:~/xfstests$ mount -t ext4
/dev/sdb1 on / type ext4 (rw,errors=3Dremount-ro,commit=3D0)
/dev/sda5 on /mnt/test/ext4 type ext4 (rw,acl,user_xattr)
amir@qalab:~/xfstests$ cat local.config
export DISABLE_UDF_TEST=3D1
export TEST_DEV=3D/dev/sda5
export TEST_DIR=3D/mnt/test/ext4
export SCRATCH_DEV=3D/dev/sda8
export SCRATCH_MNT=3D/mnt/test/scratch
amir@qalab:~/xfstests$ sudo ./check 124
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 qalab 2.6.39-rc7+
MKFS_OPTIONS  -- /dev/sda8
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda8 /mnt/test/scratch

124 9s ... - output mismatch (see 124.out.bad)
--- 124.out     2011-03-01 18:00:49.808338003 +0200
+++ 124.out.bad 2011-05-18 10:47:01.830998615 +0300
@@ -1 +1,4 @@
 QA output created by 124
+umount: /mnt/test/scratch: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
Ran: 124
Failures: 124
Failed 1 of 1 tests
amir@qalab:~/xfstests$ mount -t ext4
/dev/sdb1 on / type ext4 (rw,errors=3Dremount-ro,commit=3D0)
/dev/sda8 on /mnt/test/scratch type ext4 (rw,acl,user_xattr)
/dev/sda5 on /mnt/test/ext4 type ext4 (rw,acl,user_xattr)
amir@qalab:~/xfstests$ sudo umount /mnt/test/scratch/
amir@qalab:~/xfstests$ mount -t ext4
/dev/sdb1 on / type ext4 (rw,errors=3Dremount-ro,commit=3D0)
/dev/sda5 on /mnt/test/ext4 type ext4 (rw,acl,user_xattr)

I am not trying anything special.
Running umount from command line after the test succeeds, so it must
be some kind of race.
As I said, I tried running lsof before umount in common.rc, but it
detected nothing.
Do you have any suggestions for further analysis?

>
>> > cc'ing xfs list since xfs devs maintain xfstests.
>> >
>> > What tests have "device busy" errors? =A0What do the usual investigati=
ve
>> > steps such as "lsof" and "fuser" tell you when this happens?
>>
>> I tried running lsof | grep $TEST_DIR before umount
>> and I tried sleep 1 before umount and it didn't yield anything.
>
> Which usually indicates that you've got some kind of reference
> counting problem preventing the filesystem from being unmounted.

As I demonstrated, the filesystem *can* be unmounted.

>
>> > Are there loop devices that didn't get cleaned up, or processes that
>> > have not terminated?
>> >
>> > What tests have these problems?
>>
>> for me 124 always fails to umount, and 198 and 213 sometimes fails to um=
ount.
>
> What, exactly, are you testing on? test 124 uses XFS_IOC_RESVSP
> directly, not fallocate(), so all it is doing on a non-XFS
> filesystem is iterating a loop that writes a 1MB file, reads it back
> then unlinks it....
>

Tell me about it...

The machine was a clean install of Ubuntu 10.10,
which was recently upgraded to Ubuntu 11.4, but this problem
existed since the beginning.

It is used for nothing but running tests and I only
installed packages required (to my understanding) by xfstests.
I just build xfstests from git (HEAD 30456902).

The kernel is latest 2.6.39-rc7 with ext4 dev branch changed,
but again, the problem existed with any previous/release kernel I tried.

Cheers,
Amir.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
