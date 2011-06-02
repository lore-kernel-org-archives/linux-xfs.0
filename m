Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p527GoZe181299 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 02:16:51 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F229F15DAB52
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 00:16:48 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id cOEGgbVnwF9MMFbi
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 00:16:48 -0700 (PDT)
Received: by wwf26 with SMTP id 26so458122wwf.32
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 00:16:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
Date: Thu, 2 Jun 2011 10:16:48 +0300
Message-ID: <BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
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

On Thu, Jun 2, 2011 at 5:33 AM, Amir G. <amir73il@users.sourceforge.net> wr=
ote:
> On Thu, Jun 2, 2011 at 5:16 AM, Amir G. <amir73il@users.sourceforge.net> =
wrote:
>> On Thu, Jun 2, 2011 at 2:28 AM, Dave Chinner <david@fromorbit.com> wrote:
>>> On Wed, Jun 01, 2011 at 03:56:52PM +0300, amir73il@users.sourceforge.ne=
t wrote:
>>>> From: Amir Goldstein <amir73il@users.sf.net>
>>>>
>>>> From: Amir Goldstein <amir73il@users.sf.net>
>>>>
>>>> blkid knows to identify the ext4dev FSTYP of a partition that was
>>>> formatted with mkfs.ext4dev.
>>>> quota tools and various util-linux utils are also aware of ext4dev,
>>>> so ext4dev shares the same capabilities as ext4.
>>>>
>>>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>>>> Tested-by: Sergey Ivanov <sergey57@gmail.com>
>>>> ---
>>>> ext4dev is used to test experimental ext4 code in mutual existance
>>>> with production ext4 code on the same system.
>>>>
>>>> Specifically, ext4 snapshots code is available for testing as a
>>>> stand-alone ext4dev module for Fedora 15 and Ubuntu 11.4
>>>> (see http://next3.sf.net).
>>>>
>>>> v1 -> v2:
>>>> - undo change of fsck -t $FSTYP to fsck.$FSTYP
>>>>
>>>> =A0common.defrag | =A0 =A02 +-
>>>> =A0common.quota =A0| =A0 =A04 ++--
>>>> =A0common.rc =A0 =A0 | =A0 10 +++++-----
>>>> =A03 files changed, 8 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/common.defrag b/common.defrag
>>>> index 1bcf01d..4850803 100644
>>>> --- a/common.defrag
>>>> +++ b/common.defrag
>>>> @@ -26,7 +26,7 @@ _require_defrag()
>>>> =A0 =A0 =A0xfs)
>>>> =A0 =A0 =A0 =A0 =A0DEFRAG_PROG=3D/usr/sbin/xfs_fsr
>>>> =A0 =A0 =A0 ;;
>>>> - =A0 =A0ext4)
>>>> + =A0 =A0ext4|ext4dev)
>>>> =A0 =A0 =A0 =A0 =A0DEFRAG_PROG=3D/usr/bin/e4defrag
>>>> =A0 =A0 =A0 ;;
>>>> =A0 =A0 =A0*)
>>>> diff --git a/common.quota b/common.quota
>>>> index 3c87ce1..b6d5f16 100644
>>>> --- a/common.quota
>>>> +++ b/common.quota
>>>> @@ -29,7 +29,7 @@ _require_quota()
>>>> =A0 =A0 =A0[ -n $QUOTA_PROG ] || _notrun "Quota user tools not install=
ed"
>>>>
>>>> =A0 =A0 =A0case $FSTYP in
>>>> - =A0 =A0ext2|ext3|ext4|reiserfs)
>>>> + =A0 =A0ext2|ext3|ext4|ext4dev|reiserfs)
>>>> =A0 =A0 =A0 if [ ! -d /proc/sys/fs/quota ]; then
>>>> =A0 =A0 =A0 =A0 =A0 _notrun "Installed kernel does not support quotas"
>>>> =A0 =A0 =A0 fi
>>>> @@ -237,7 +237,7 @@ _check_quota_usage()
>>>> =A0 =A0 =A0 # Sync to get delalloc to disk
>>>> =A0 =A0 =A0 sync
>>>> =A0 =A0 =A0 VFS_QUOTA=3D0
>>>> - =A0 =A0 if [ $FSTYP =3D "ext2" -o $FSTYP =3D "ext3" -o $FSTYP =3D "e=
xt4" -o $FSTYP =3D "reiserfs" ]; then
>>>> + =A0 =A0 if [ $FSTYP =3D "ext2" -o $FSTYP =3D "ext3" -o $FSTYP =3D "e=
xt4" -o $FSTYP =3D "ext4dev" -o $FSTYP =3D "reiserfs" ]; then
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 VFS_QUOTA=3D1
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
>>>> =A0 =A0 =A0 fi
>>>
>>> Perhaps this should be changes to a case statement?
>>>
>>
>> you're making me go to v3 in such a trivial patch, but ok, I'll do it ;-)
>>
>
> I rechecked the fsck -t ext4dev vs. fsck.ext4dev.
> fsck -t ext4dev doesn't work for me :-(
> Sergey has a newer version of =A0util-linux-ng
> see:
>
> amir@qalab:~/xfstests$ sudo fsck -t ext4dev -nf /dev/sda5
> fsck from util-linux-ng 2.17.2
> e2fsck 1.41.14 (22-Dec-2010)
> /dev/sda5 has unsupported feature(s): FEATURE_C7 FEATURE_C8 FEATURE_R7
> e2fsck: Get a newer version of e2fsck!

OK, after upgrading to newer util-linux and building it from git,
which also didn't help, I finally found who to blame - me.
I had an old (noauto) entry in /etc/fstab which claimed that /dev/sda5 is e=
xt4.
fsck was picking up that entry and insisting that /dev/sda5 is ext4
(regardless of what it really is)
blkid isn't doing that silly thing.

Amir

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
