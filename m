Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52DHwim199626 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 08:17:58 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0E731ED3E78
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 06:17:55 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id 1vYYncIXngl0xz4N
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 06:17:55 -0700 (PDT)
Received: by wyi11 with SMTP id 11so655273wyi.26
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 06:17:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1106021352330.3931@dhcp-27-109.brq.redhat.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<20110602030802.GR561@dastard>
	<BANLkTi=sPM_AYB4w=N5pWHfws9R3WnfJVw@mail.gmail.com>
	<20110602064040.GS561@dastard>
	<BANLkTinJcvvv2pfXBt7EZ9TXONb9jRe0uQ@mail.gmail.com>
	<alpine.LFD.2.00.1106021352330.3931@dhcp-27-109.brq.redhat.com>
Date: Thu, 2 Jun 2011 16:17:54 +0300
Message-ID: <BANLkTinBL5GbhUg5NLCqmLEfz0nNFrjf-w@mail.gmail.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: sandeen@redhat.com, Theodore Tso <tytso@mit.edu>, xfs@oss.sgi.com, sergey57@gmail.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jun 2, 2011 at 3:10 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Thu, 2 Jun 2011, Amir G. wrote:
>
>> On Thu, Jun 2, 2011 at 9:40 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Thu, Jun 02, 2011 at 06:49:20AM +0300, Amir G. wrote:
>> >> On Thu, Jun 2, 2011 at 6:08 AM, Dave Chinner <david@fromorbit.com> wr=
ote:
>> >> > On Thu, Jun 02, 2011 at 05:33:34AM +0300, Amir G. wrote:
>> >> >> On Thu, Jun 2, 2011 at 5:16 AM, Amir G. <amir73il@users.sourceforg=
e.net> wrote:
>> >> >> > On Thu, Jun 2, 2011 at 2:28 AM, Dave Chinner <david@fromorbit.co=
m> wrote:
>> >> > Personally I think that ext4dev shouldn't be supported at all. A
>> >> > special fstyp iwhile ext4 was being developed was, IMO, a stupid
>> >> > thing to do in the first place, and I was happy when it died. It
>> >> > should not be resurrected and propagated.
>> >> >
>> >> > xfstests assumes that you are using a userspace that is current with
>> >> > the version of the filesystem the kernel supports. If you are
>> >> > running a development/special branch of ext4, then you need to be
>> >> > running a userspace that understands it completely. If all you are
>> >> > doing with the ext4dev fstyp is trying to vector to a different fsck
>> >> > program that supports a new set of feature bits, then IMO you are
>> >> > doing it all wrong.
>> >> >
>> >> > Fundamentally, the filesystem is either ext4 or it isn't. If the
>> >> > features are never going to make it into mainline ext4, then you
>> >> > need a completely different fstype and full userspace support for
>> >> > that fstype. Once you have that, you can add the fstype support to
>> >> > xfstests. However, just using a different fstyp just to set a
>> >> > certain set of feature flags is, again IMO, a pretty stupid way of
>> >> > going about this.
>> >> >
>> >>
>> >> The features are going into mainline, but are not there yet.
>> >
>> > So using feature bits as they were intended is the right thing to
>> > do, isn't it?
>>
>> I am not sure what you mean by that.
>> The fact that to this day fsck.ext2/3/4 have always been the same
>> file (hence support the same feature set) does not mean that they have
>> to be that way by design.
>>
>> on my test system fsck.ext4dev must be used to test ext4dev, which has
>> newer features than ext4.
>
> And that's perfectly fine, you can use whatever you want on you system.
>
>> I fail to see the problem with that.
>>
>> >
>> >> I did not invent the ext4dev standard, which is pretty well supported
>> >> by all relevant tools, but I find it very convenient for the testing.
>> >
>> > As I understand it, ext4dev is deprecated and should not be used for
>> > any new filesystems. When did that status change?
>> >
>> > Or did you just start using it because it's convenient for your
>> > purposes? =A0What happens when someone else decides to use ext4dev for
>> > testing incompatible development features because it is convenient
>> > for them?
>> >
>>
>> The way I see it, ext4dev is a tool for ext4 developers (and testers).
>> Anyone can use it for their own needs and it would be convenient for eve=
ryone.
>> I never suggested that Fedora push my ext4dev utils as a standard packag=
e.
>> But me and my group can use it to test the snapshots feature and Ted
>> and his group can use it to test the allocation clusters feature.
>
> ext4dev is not a tool for ext4 developers. It has been deprecated and
> does not exist anymore, looking at kernel config there is nothing like
> that. If you do not want to have different filesystem for your system
> to be able to test ext4 without breaking your system ,than it is perfectly
> fine to write yourself such helpers. But I do not see any reason for
> pushing this stuff to other tools. In fact it should have been removed
> from everywhere, since it does not exist anymore ... or has something
> changed ? Are we resurrecting ext4dev ? Then we should start somewhere
> else do not you think ?
>

Ted actually brought this up in our ext4 developers meeting on LSF.
He said we could register an ext4 module with the ext4dev external symbols
and it would be useful for testing, since we already have all those tools t=
hat
are aware of ext4dev.

I  am still using a more low-tech method of cloning ext4 (sed) to build
a standalone ext4dev module for testing, but it's the same principle.

>>
>>
>> >> Especially, when I expect my testers to be running a stable
>> >> distro release (i.e. F15 or Ubuntu 11.4) and be able to install
>> >> my experimental ext4dev module and utils, without it affecting
>> >> their (most likely) root ext4/ext3 fs.
>> >
>> > So get them to use an ext3, XFS, reiser or JFS root filesystem if
>> > that's your major concern. That's long been a best practice for
>> > configuring a filesystem test box - don't use the same filesystem
>> > for your root/stable filesystems as the filesytsem you are testing.
>> >
>> > e.g. If you pick ext3 for the root filesystem, then you can test
>> > ext4, btrfs, xfs, etc changes without having to worry about whether
>> > the development module being tested is going to affect your root
>> > filesystem....
>>
>> You make it sound as if I have a flock of testers out there waiting for
>> me to feed them with use cases to test and who abide to my setup
>> instructions.
>>
>> Wake up call! this is not the case for me and for most developers.
>> If I'm lucky, I can get a e few testers who will say:
>> OK, if all I have to do is download this package and run 'make test'
>> I can spare an hour to play with it.
>>
>> So, yes, it's true. There are other ways to accomplish what I am doing,
>> but I am going out of my way to try to make the life of developers and t=
esters
>> easier and you are doing the exact opposite by raising objections to a r=
ather
>> trivial and harmless patch.
>
> What is easier for testers and developers ? I fail to see the reason for
> including non-existing FSTYP into xfstests while it should be forgotten
> by now. Just provide sources with whatever fs name you choose (or just
> patches for ext4 preferably), provide patches to e2fsprogs and patches to
> xfstests if you want people to test with it. And it should be easy for ev=
ery
> tester, or developer to use it, shouldn't it ? Is that a problem ?

Yes, it is a problem. You are thinking in terms of a developer who builds
new kernels on a daily basis.
Back in the time, when I developed next3, I asked some friend and
people in the community
if they could test it.
It turned out that they don't even know how to build a kernel and they
don't want
to invest the time in doing that.
This is when I realized that to get to a wider audience of testers, I
need to make the testing
process E A S Y !

And by E A S Y, I mean:
1. Take a Fedora 15 system
2. download http://next3.sourceforge.net/files/1.0.13/ext4dev_snapshots-1.0=
.13-x86_64.tar.gz
3. tar xfz ext4dev_snapshots-1.0.13-x86_64.tar.gz && cd ext4dev_snapshots-1=
.0.13
4. make && sudo make install && sudo make test

That's it! it takes no more than 5 minutes and your system remains unaffect=
ed
by installed tools.

Now, if the patch in question is accepted to xfstests, testing the
experimental fs would
be as E A S Y as:

5. sudo mkfs.ext4dev -O has_snapshot /dev/sda5
6. sudo mount /dev/sda5 /mnt/test
7. cd ~/xfstests && sudo ./check (assuming those are your
TEST_DEV/TEST_DIR above)


Seriously, guys! This thread is becoming ridiculous.
xfstests is not a tools for an obscure target market - it's for us.
It should be used by developers to test their patches.
Why make it so difficult if I state very clearly that it helps me???

Can I get at least one Yay here? Ted? Eric? Anyone?
And look at the patch for heaven's sake  (which was left behind in the heat
of the discussion) , it's miserably harmless.

Amir.


>From da25ccc0910847b0aaddac1b01f223890244f223 Mon Sep 17 00:00:00 2001
From: Amir Goldstein <amir73il@users.sf.net>
Date: Tue, 31 May 2011 18:43:17 +0300
Subject: [PATCH v3] xfstests: add support for ext4dev FSTYP

blkid knows to identify the ext4dev FSTYP of a partition that was
formatted with mkfs.ext4dev.
quota tools and various util-linux utils are also aware of ext4dev,
so ext4dev shares the same capabilities as ext4.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Tested-by: Sergey Ivanov <sergey57@gmail.com>
---
ext4dev is used to test experimental ext4 code in mutual existance
with production ext4 code on the same system.

Specifically, ext4 snapshots code is available for testing as a
stand-alone ext4dev module for Fedora 15 and Ubuntu 11.4
(see http://next3.sf.net).

v2 -> v3:
- change if to case statement

v1 -> v2:
- undo change of fsck -t $FSTYP to fsck.$FSTYP

 common.defrag |    2 +-
 common.quota  |   10 +++++++---
 common.rc     |   10 +++++-----
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/common.defrag b/common.defrag
index 1bcf01d..4850803 100644
--- a/common.defrag
+++ b/common.defrag
@@ -26,7 +26,7 @@ _require_defrag()
     xfs)
         DEFRAG_PROG=3D/usr/sbin/xfs_fsr
 	;;
-    ext4)
+    ext4|ext4dev)
         DEFRAG_PROG=3D/usr/bin/e4defrag
 	;;
     *)
diff --git a/common.quota b/common.quota
index 3c87ce1..9736306 100644
--- a/common.quota
+++ b/common.quota
@@ -29,7 +29,7 @@ _require_quota()
     [ -n $QUOTA_PROG ] || _notrun "Quota user tools not installed"

     case $FSTYP in
-    ext2|ext3|ext4|reiserfs)
+    ext2|ext3|ext4|ext4dev|reiserfs)
 	if [ ! -d /proc/sys/fs/quota ]; then
 	    _notrun "Installed kernel does not support quotas"
 	fi
@@ -237,10 +237,14 @@ _check_quota_usage()
 	# Sync to get delalloc to disk
 	sync
 	VFS_QUOTA=3D0
-	if [ $FSTYP =3D "ext2" -o $FSTYP =3D "ext3" -o $FSTYP =3D "ext4" -o $FSTYP
=3D "reiserfs" ]; then
+	case $FSTYP in
+	ext2|ext3|ext4|ext4dev|reiserfs)
 		VFS_QUOTA=3D1
 		quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
-	fi
+		;;
+	*)
+		;;
+	esac
 	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
 		sort >$tmp.user.orig
 	repquota -g -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
diff --git a/common.rc b/common.rc
index e634fbb..c510c66 100644
--- a/common.rc
+++ b/common.rc
@@ -65,7 +65,7 @@ _mount_opts()
     nfs)
 	export MOUNT_OPTIONS=3D$NFS_MOUNT_OPTIONS
 	;;
-    ext2|ext3|ext4)
+    ext2|ext3|ext4|ext4dev)
 	# acls & xattrs aren't turned on by default on ext$FOO
 	export MOUNT_OPTIONS=3D"-o acl,user_xattr $EXT_MOUNT_OPTIONS"
 	;;
@@ -110,7 +110,7 @@ _mkfs_opts()
 _fsck_opts()
 {
     case $FSTYP in
-    ext2|ext3|ext4)
+    ext2|ext3|ext4|ext4dev)
 	export FSCK_OPTIONS=3D"-nf"
 	;;
     reiserfs)
@@ -326,10 +326,10 @@ _scratch_mkfs_sized()
     xfs)
 	_scratch_mkfs_xfs -d size=3D$fssize -b size=3D$blocksize
 	;;
-    ext2|ext3|ext4)
+    ext2|ext3|ext4|ext4dev)
 	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
-     btrfs)
+    btrfs)
 	/sbin/mkfs.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV -b $fssize
 	;;
     *)
@@ -354,7 +354,7 @@ _scratch_mkfs_geom()
     xfs)
 	MKFS_OPTIONS+=3D" -b size=3D$blocksize, -d su=3D$sunit_bytes,sw=3D$swidth=
_mult"
 	;;
-    ext4)
+    ext4|ext4dev)
 	MKFS_OPTIONS+=3D" -b $blocksize -E
stride=3D$sunit_blocks,stripe_width=3D$swidth_blocks"
 	;;
     *)
-- =

1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
