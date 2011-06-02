Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p523nQOI167962 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 22:49:26 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3E77D6D572
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 20:49:24 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id B6OInfSYv2gxDccv
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2011 20:49:24 -0700 (PDT)
Received: by wyi11 with SMTP id 11so347242wyi.26
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2011 20:49:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110602030802.GR561@dastard>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<20110602030802.GR561@dastard>
Date: Thu, 2 Jun 2011 06:49:20 +0300
Message-ID: <BANLkTi=sPM_AYB4w=N5pWHfws9R3WnfJVw@mail.gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen@redhat.com, Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com, sergey57@gmail.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jun 2, 2011 at 6:08 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jun 02, 2011 at 05:33:34AM +0300, Amir G. wrote:
>> On Thu, Jun 2, 2011 at 5:16 AM, Amir G. <amir73il@users.sourceforge.net>=
 wrote:
>> > On Thu, Jun 2, 2011 at 2:28 AM, Dave Chinner <david@fromorbit.com> wro=
te:
>> >> On Wed, Jun 01, 2011 at 03:56:52PM +0300, amir73il@users.sourceforge.=
net wrote:
>> >>> From: Amir Goldstein <amir73il@users.sf.net>
>> >>>
>> >>> From: Amir Goldstein <amir73il@users.sf.net>
>> >>>
>> >>> blkid knows to identify the ext4dev FSTYP of a partition that was
>> >>> formatted with mkfs.ext4dev.
>> >>> quota tools and various util-linux utils are also aware of ext4dev,
>> >>> so ext4dev shares the same capabilities as ext4.
>> >>>
>> >>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>> >>> Tested-by: Sergey Ivanov <sergey57@gmail.com>
>> >>> ---
>> >>> ext4dev is used to test experimental ext4 code in mutual existance
>> >>> with production ext4 code on the same system.
>> >>>
>> >>> Specifically, ext4 snapshots code is available for testing as a
>> >>> stand-alone ext4dev module for Fedora 15 and Ubuntu 11.4
>> >>> (see http://next3.sf.net).
>> >>>
>> >>> v1 -> v2:
>> >>> - undo change of fsck -t $FSTYP to fsck.$FSTYP
>> >>>
>> >>> =A0common.defrag | =A0 =A02 +-
>> >>> =A0common.quota =A0| =A0 =A04 ++--
>> >>> =A0common.rc =A0 =A0 | =A0 10 +++++-----
>> >>> =A03 files changed, 8 insertions(+), 8 deletions(-)
>> >>>
>> >>> diff --git a/common.defrag b/common.defrag
>> >>> index 1bcf01d..4850803 100644
>> >>> --- a/common.defrag
>> >>> +++ b/common.defrag
>> >>> @@ -26,7 +26,7 @@ _require_defrag()
>> >>> =A0 =A0 =A0xfs)
>> >>> =A0 =A0 =A0 =A0 =A0DEFRAG_PROG=3D/usr/sbin/xfs_fsr
>> >>> =A0 =A0 =A0 ;;
>> >>> - =A0 =A0ext4)
>> >>> + =A0 =A0ext4|ext4dev)
>> >>> =A0 =A0 =A0 =A0 =A0DEFRAG_PROG=3D/usr/bin/e4defrag
>> >>> =A0 =A0 =A0 ;;
>> >>> =A0 =A0 =A0*)
>> >>> diff --git a/common.quota b/common.quota
>> >>> index 3c87ce1..b6d5f16 100644
>> >>> --- a/common.quota
>> >>> +++ b/common.quota
>> >>> @@ -29,7 +29,7 @@ _require_quota()
>> >>> =A0 =A0 =A0[ -n $QUOTA_PROG ] || _notrun "Quota user tools not insta=
lled"
>> >>>
>> >>> =A0 =A0 =A0case $FSTYP in
>> >>> - =A0 =A0ext2|ext3|ext4|reiserfs)
>> >>> + =A0 =A0ext2|ext3|ext4|ext4dev|reiserfs)
>> >>> =A0 =A0 =A0 if [ ! -d /proc/sys/fs/quota ]; then
>> >>> =A0 =A0 =A0 =A0 =A0 _notrun "Installed kernel does not support quota=
s"
>> >>> =A0 =A0 =A0 fi
>> >>> @@ -237,7 +237,7 @@ _check_quota_usage()
>> >>> =A0 =A0 =A0 # Sync to get delalloc to disk
>> >>> =A0 =A0 =A0 sync
>> >>> =A0 =A0 =A0 VFS_QUOTA=3D0
>> >>> - =A0 =A0 if [ $FSTYP =3D "ext2" -o $FSTYP =3D "ext3" -o $FSTYP =3D =
"ext4" -o $FSTYP =3D "reiserfs" ]; then
>> >>> + =A0 =A0 if [ $FSTYP =3D "ext2" -o $FSTYP =3D "ext3" -o $FSTYP =3D =
"ext4" -o $FSTYP =3D "ext4dev" -o $FSTYP =3D "reiserfs" ]; then
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 VFS_QUOTA=3D1
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
>> >>> =A0 =A0 =A0 fi
>> >>
>> >> Perhaps this should be changes to a case statement?
>> >>
>> >
>> > you're making me go to v3 in such a trivial patch, but ok, I'll do it =
;-)
>> >
>>
>> I rechecked the fsck -t ext4dev vs. fsck.ext4dev.
>> fsck -t ext4dev doesn't work for me :-(
>> Sergey has a newer version of =A0util-linux-ng
>> see:
>>
>> amir@qalab:~/xfstests$ sudo fsck -t ext4dev -nf /dev/sda5
>> fsck from util-linux-ng 2.17.2
>> e2fsck 1.41.14 (22-Dec-2010)
>> /dev/sda5 has unsupported feature(s): FEATURE_C7 FEATURE_C8 FEATURE_R7
>> e2fsck: Get a newer version of e2fsck!
>> amir@qalab:~/xfstests$ sudo fsck.ext4dev -nf /dev/sda5
>> e2fsck 1.41.14-next3-1.0.13-7 (24-May-2011)
>> Checking snapshots: 1,done
>> Pass 1: Checking inodes, blocks, and sizes
>> Pass 2: Checking directory structure
>> Pass 3: Checking directory connectivity
>> Pass 4: Checking reference counts
>> Pass 5: Checking group summary information
>> /dev/sda5: 6596/6561792 files (3.6% non-contiguous), 1242522/26216064 bl=
ocks
>> amir@qalab:~/xfstests$
>>
>> What do you thing, Dave?
>> Should xfstests rely on a non-buggy generic fsck util,
>
> For filessytems that use the generic fsck multiplexor, yes.
>
>> or just
>> implement it's own
>> non-buggy generic fsck (invoke fsck.$FSTYP directly)
>
> In general, no. XFS is a special case in that fsck.xfs is a no-op -
> it does no checking at all and only returns values needed for init
> scripts to work correctly. xfs_repair/xfs_check are for checking the
> filesystem...
>
>> I am running a recent system (Ubuntu 11.4) and I don't thing that upgrad=
ing
>> util-linux should be a requirement for xfstests to work.
>
> We do not try to support every buggy piece of crap out there - if a
> newer version of util-linux has already fixed the problem, then use
> that and we don't need to do anything special with xfstests at all.
> If you've got bleeding edge filesystem code that requires using a
> ext4dev fstyp and a new ext4 userspace, then I think that requiring
> you to use a non-buggy util-linux is not a big deal....
>

no. not a big deal at all.

> ---
>
> Personally I think that ext4dev shouldn't be supported at all. A
> special fstyp iwhile ext4 was being developed was, IMO, a stupid
> thing to do in the first place, and I was happy when it died. It
> should not be resurrected and propagated.
>
> xfstests assumes that you are using a userspace that is current with
> the version of the filesystem the kernel supports. If you are
> running a development/special branch of ext4, then you need to be
> running a userspace that understands it completely. If all you are
> doing with the ext4dev fstyp is trying to vector to a different fsck
> program that supports a new set of feature bits, then IMO you are
> doing it all wrong.
>
> Fundamentally, the filesystem is either ext4 or it isn't. If the
> features are never going to make it into mainline ext4, then you
> need a completely different fstype and full userspace support for
> that fstype. Once you have that, you can add the fstype support to
> xfstests. However, just using a different fstyp just to set a
> certain set of feature flags is, again IMO, a pretty stupid way of
> going about this.
>

The features are going into mainline, but are not there yet.
I did not invent the ext4dev standard, which is pretty well supported
by all relevant tools, but I find it very convenient for the testing.

Especially, when I expect my testers to be running a stable
distro release (i.e. F15 or Ubuntu 11.4) and be able to install
my experimental ext4dev module and utils, without it affecting
their (most likely) root ext4/ext3 fs.


> Cheers,
>
> Dave.
>
> --
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
