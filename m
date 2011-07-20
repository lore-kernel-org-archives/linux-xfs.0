Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KMQQiJ251150 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 17:26:27 -0500
Received: from mail-fx0-f47.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7469EE7EA1
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 15:26:25 -0700 (PDT)
Received: from mail-fx0-f47.google.com (mail-fx0-f47.google.com
	[209.85.161.47]) by cuda.sgi.com with ESMTP id 9MkwWYQzFLmjn8qh
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 15:26:25 -0700 (PDT)
Received: by fxg11 with SMTP id 11so2505314fxg.6
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 15:26:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110720213320.GA3304@thunk.org>
References: <20110720175918.GB17971@thunk.org> <4E271F30.6070102@redhat.com>
	<20110720213320.GA3304@thunk.org>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Wed, 20 Jul 2011 18:25:53 -0400
Message-ID: <CAGpXXZJLt2oSBpBXkGz173Big+LRhhVOdKYBaJhqKEXtL9K1SQ@mail.gmail.com>
Subject: Re: Problems building xfsprogs
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
To: Ted Ts'o <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jul 20, 2011 at 5:33 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Jul 20, 2011 at 01:32:16PM -0500, Eric Sandeen wrote:
>>
>> How does it fail? =A0Works here(tm):
>
> It doesn't find the autoconfig macros defined in the m4 directory:
>
> <tytso@tytso-glaptop> {/kbuild/xfstests/xfsprogs-dev} =A0[master]
> 512% autoconf
> autoconf: Undefined macros:
> configure.in:100:AC_PACKAGE_NEED_PTHREADMUTEXINIT
> configure.in:102:AC_HAVE_FADVISE
> configure.in:103:AC_HAVE_MADVISE
> configure.in:104:AC_HAVE_MINCORE
> configure.in:105:AC_HAVE_SENDFILE
> configure.in:106:AC_HAVE_GETMNTENT
> configure.in:107:AC_HAVE_GETMNTINFO
> configure.in:108:AC_HAVE_FALLOCATE
> configure.in:109:AC_HAVE_FIEMAP
> configure.in:110:AC_HAVE_BLKID_TOPO($enable_blkid)
> configure.in:112:AC_TYPE_PSINT
> configure.in:113:AC_TYPE_PSUNSIGNED
> configure.in:114:AC_TYPE_U32
> configure.in:115:AC_SIZEOF_POINTERS_AND_LONG
> configure.in:116:AC_MANUAL_FORMAT
> configure.in:3:AC_CONFIG_MACRO_DIR([m4])
> configure.in:7:AC_PROG_LIBTOOL
> configure.in:89:AC_PACKAGE_GLOBALS(xfsprogs)
> configure.in:90:AC_PACKAGE_UTILITIES(xfsprogs)
> configure.in:91:AC_MULTILIB($enable_lib64)
> configure.in:93:AC_PACKAGE_NEED_AIO_H
> configure.in:94:AC_PACKAGE_NEED_LIO_LISTIO
> configure.in:96:AC_PACKAGE_NEED_UUID_H
> configure.in:97:AC_PACKAGE_NEED_UUIDCOMPARE
> configure.in:99:AC_PACKAGE_NEED_PTHREAD_H
>
> Maybe you have all of these autoconf macros stuffed in some
> distro-supplied global m4 directory?
>
>> > b) By default xfsprogs builds with DEBUG, and this causes building
>> > libxfs/xfs_ialloc.c to blow up since there a reference of
>> > xfs_stack_trace() which is undefined under a #ifdef DEBUG. =A0The way =
to
>> > fix this is to build with DEBUG=3D-DNDEBUG, but it took me an hour or
>> > two figure this out....
>>
>> Odd, libxfs/Makefile has:
>>
>> DEBUG =3D -DNDEBUG
>
> Yeah, but include/builddefs{.in}, DEBUG is defined to @debug_build@,
> which is -DDEBUG, and then GCFLAGS is set to $(OPTIMIZER) $(DEBUG) ...,
>
> and the override in libxfs/Makefile doesn't change the value of
> GCFLAGS, at least not for gmake 3.81.
>
>> But to be honest, the DEBUG stuff has been a thorn in my side for Fedora
>> too, with the extra CFLAGS it sets, something gets goobered up by
>> default, and I build with -DNDEBUG for those packages too.
>>
>> I just haven't sorted it out yet ....
>>
>> So things to look into, but can you also describe how building xfstests
>> fails for you when you have all the ubuntu xfsprogs-related packages
>> installed?
>
> Yeah, working on it. =A0I'm starting from scratch so I can have a shell
> script that can build all of this by hand, instead of manually fixing
> these things one at a time as I've done in the past...

This little shell script is part of the openSUSE qa test (or soon will
be).  ie. Every opensuse distro build is run through automated qa
tests.  The testing team is working on adding in xfstests specifically
for btrfs at present.

I don't know exactly what packages are installed when the below runs,
but it should be a fairly basic set of packages since its just a QA
basic functionality run.

=3D=3D=3D
#!/bin/sh
tmp=3D/tmp/xfs_playground
export TEST_DEV=3D/dev/vdb
export TEST_DIR=3D$tmp/test
export SCRATCH_DEV=3D/dev/vdc
export SCRATCH_MNT=3D$tmp/scratch
export FSTYP=3Dbtrfs

grep -q susetest /etc/hosts || echo "10.0.2.15 susetest.zq1.de
susetest" >> /etc/hosts # workaround factory bug # TODO: drop later

sudo zypper -n install sudo git gcc libtool automake gettext-tools
libattr-devel libacl-devel libuuid-devel btrfsprogs
mkdir -p $tmp $TEST_DIR $SCRATCH_MNT
cd $tmp

#git clone git://oss.sgi.com/xfs/xfs   #(this step may not be needed?)
git clone git://oss.sgi.com/xfs/cmds/xfsprogs
git clone git://oss.sgi.com/xfs/cmds/xfstests

(
	cd xfsprogs
	make
	sudo make install-qa
)
cd xfstests
make


mkfs.$FSTYP $TEST_DEV
mkfs.$FSTYP $SCRATCH_DEV

mount $TEST_DEV $TEST_DIR
mount $SCRATCH_DEV $SCRATCH_MNT

time ./check -g auto -f quick

umount $TEST_DIR
umount $SCRATCH_MNT

echo "xfstests done" > /dev/ttyS0
=3D=3D=3D=3D

So far the xfstest part of the above seems fine.

It is finding 3 or 4 btrfs failed tests.

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
