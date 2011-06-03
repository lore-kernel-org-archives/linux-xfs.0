Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53HLCx8022154 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 12:21:12 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67E96D71D6B
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 10:21:10 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id JlErhcXNO7fFhFVA
	for <xfs@oss.sgi.com>; Fri, 03 Jun 2011 10:21:10 -0700 (PDT)
Received: by wyi11 with SMTP id 11so1706479wyi.26
	for <xfs@oss.sgi.com>; Fri, 03 Jun 2011 10:21:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE86BC1.4080008@redhat.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
	<4DE7A557.9040608@redhat.com>
	<7D3F86FA-5AA9-49B0-9AFE-F597E83C07B4@dilger.ca>
	<20110603003610.GD16306@thunk.org>
	<BANLkTikiE1v6r7sYKSsR_pgqM-dJzQKrzQ@mail.gmail.com>
	<4DE86BC1.4080008@redhat.com>
Date: Fri, 3 Jun 2011 20:21:09 +0300
Message-ID: <BANLkTi=UYvg0ypuOjD5YbWre-_dXnKkDjg@mail.gmail.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
From: "Amir G." <amir73il@users.sourceforge.net>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Ted Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com, sergey57@gmail.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri, Jun 3, 2011 at 8:06 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 6/2/11 11:59 PM, Amir G. wrote:
>> On Fri, Jun 3, 2011 at 3:36 AM, Ted Ts'o <tytso@mit.edu> wrote:
>>> On Thu, Jun 02, 2011 at 11:22:53AM -0600, Andreas Dilger wrote:
>>>> On 2011-06-02, at 8:59 AM, Eric Sandeen wrote:
>>>>> I don't really mind adding ext4dev to FSTYP case statements, it
>>>>> -is- something which blkid could, in theory, still return, and
>>>>> making xfstests cope with that and try to invoke fsck -t ext4dev
>>>>> doesn't bother me too much. =A0It is sadly an fs type embedded into
>>>>> a few tools.
>>>>
>>>> I'm perfectly OK with using ext4dev as a filesystem type that allows t=
esting
>>>> changes to ext4 on a system that is already running ext4 as the root f=
s.
>>>
>>> My take on this is that way too much time has been spent this subject.
>>
>> No doubt.
>>
>>> Being able to use ext4dev is useful, and given that we have all of
>>> this support in our existing system tools, why not use it to make ext4
>>> development more efficient/easy? =A0As a bonus you can build the ext4dev
>>> as a module, and that means you the compile/edit/debug cycle can be
>>> much faster since you can avoid doing a reboot, for those
>>> circumstances where using KVM is not possible/convenient. =A0Personally,
>>> I normally use KVM these days, but I can imagine situations where
>>> using ext4dev would be a better way to go. =A0For example, I'd probably
>>> use KVM on my laptop, but for testing on production servers in a data
>>> center, I'd probably use ext4dev, for a variety of local deployment
>>> considerations that's not worth going into here.
>>>
>>> That being said, whether or not we modify xfstests seems to be a moot
>>> point. =A0In order for me to do my bigalloc development, I've been
>>> patching common.rc so that "/sbin/mkfs.$FSTYP" --> "mkfs.$FSTYP" and
>>> "/sbin/fsck -t $FSTYP" --> "fsck.$FSTYP". =A0It's a 3 line change. =A0N=
ot
>>> a big deal. =A0I've been making this change using /bin/ed after
>>> installing xfstests. =A0So if the XFS folks want to veto this change ---
>>> who cares? =A0It's not hard to make the change locally in order to make
>>> xfstests.
>>>
>>> On the other hand, given that xfstests is using "mkfs.$FSTYP", I don't
>>> see why it's so important that it clings to "fsck -t $FSTYP" instead
>>> of using "fsck.$FSTYP". =A0There's no real benefit to calling the fsck
>>> driver; it's just an extra fork and exec, and xfstests is being
>>> inconsistent by insisting on the use of the fsck driver, but not using
>>> the mkfs driver.
>>>
>>> But that being said, hacking xfstests is not hard, and if Dave and/or
>>> Eric feels strongly about resisting this change, it's not worth a lot
>>> of time, one way or another....
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>>>
>>
>> I blame only myself for not presenting the case correctly.
>> I made it sound like I am trying to push my own private hack upstream.
>> Actually, all 10 people involved in snapshot development clone my xfstes=
ts
>> tree from github, so we have no real need for the upstream change.
>> The reason I was pushing upstream is because I found this feature
>> so useful, I thought other developers may enjoy it as well.
>>
>> Anyone on on this thread not having used ext4dev by next LSF
>> can come to me to claim his beer ;-)
>
> mmm I like beer, I'll see you then! =A0;)
>
> -Eric (tucking this email away for future reference... ;)
>

Well, if anyone doesn't like beer, here are my low-tech ext4dev clone
scripts ;-)

ext4: scripts to clone and build ext4dev fs with default config options

diff --git a/clone_ext4dev.sh b/clone_ext4dev.sh
new file mode 100755
index 0000000..b5ae2c4
--- /dev/null
+++ b/clone_ext4dev.sh
@@ -0,0 +1,18 @@
+#!/bin/sh
+
+rm -rf fs/ext4dev
+mkdir -p fs/ext4dev
+cp -a fs/ext4/*.h fs/ext4dev
+cp -a fs/ext4/*.c fs/ext4dev
+cp -a fs/ext4/Kconfig fs/ext4dev
+cp -a fs/ext4/Makefile fs/ext4dev
+cp -a include/trace/events/ext4.h fs/ext4dev/ext4dev_events.h
+cd fs/ext4dev
+rm *.mod.c 2>/dev/null
+mv ext4_extents.h ext4dev_extents.h
+mv ext4_jbd2.h ext4dev_jbd2.h
+mv ext4_jbd2.c ext4dev_jbd2.c
+mv ext4.h ext4dev.h
+sed -f ../../ext4dev.sed -i *
+cd ..
+tar cfz ../ext4dev_module.tar.gz ext4dev/
diff --git a/ext4dev.sed b/ext4dev.sed
new file mode 100644
index 0000000..2ec2761
--- /dev/null
+++ b/ext4dev.sed
@@ -0,0 +1,3 @@
+s/ext4/ext4dev/g
+s/Ext4/Ext4dev/g
+s/EXT4/EXT4DEV/g
diff --git a/make_ext4dev.sh b/make_ext4dev.sh
new file mode 100755
index 0000000..495929f
--- /dev/null
+++ b/make_ext4dev.sh
@@ -0,0 +1,11 @@
+#!/bin/sh
+
+KERNEL=3D$(uname -r)
+KDIR=3D/lib/modules/${KERNEL}/build
+
+sudo cp fs/ext4dev/ext4dev_events.h ${KDIR}/include/trace/events/ext4dev.h
+make -C ${KDIR} M=3D${PWD}/fs/ext4dev modules
+sudo make -C ${KDIR} M=3D${PWD}/fs/ext4dev modules_install
+sudo rmmod ext4dev
+sudo modprobe ext4dev
+
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index c947e36..9981306 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -2,6 +2,13 @@
 # Makefile for the linux ext4-filesystem routines.
 #

+ifndef CONFIG_EXT4_FS
+CONFIG_EXT4_FS?=3Dm
+CONFIG_EXT4_FS_XATTR?=3Dy
+CONFIG_EXT4_FS_POSIX_ACL?=3D$(CONFIG_FS_POSIX_ACL)
+CONFIG_EXT4_FS_SECURITY?=3Dy
+endif
+
 obj-$(CONFIG_EXT4_FS) +=3D ext4.o

 ext4-y :=3D balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-i=
o.o \
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3aa0b72..657d437 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -33,6 +33,18 @@
 #include <linux/compat.h>
 #endif

+#ifndef EXT4_SUPER_MAGIC
+#define EXT4_SUPER_MAGIC EXT3_SUPER_MAGIC
+/* configuration options for standalone module */
+#define CONFIG_EXT4_DEFAULTS_TO_ORDERED
+#define CONFIG_EXT4_FS_XATTR
+#ifdef CONFIG_FS_POSIX_ACL
+#define CONFIG_EXT4_FS_POSIX_ACL
+#endif
+#define CONFIG_EXT4_FS_SECURITY
+#define CONFIG_EXT4_DEBUG
+#endif
+
 /*
  * The fourth extended filesystem constants/structures
  */
---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
