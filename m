Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p514uoZY092485 for <xfs@oss.sgi.com>; Tue, 31 May 2011 23:56:50 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84FA0D6A405
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 21:56:47 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id NdX0JhNxT4N7raVw
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 21:56:47 -0700 (PDT)
Received: by wyi11 with SMTP id 11so4434123wyi.26
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 21:56:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE5C1FE.8080006@redhat.com>
References: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>
	<4DE5C1FE.8080006@redhat.com>
Date: Wed, 1 Jun 2011 07:56:45 +0300
Message-ID: <BANLkTikfjitncM=zLpfTrfQkd8VfQAxbUA@mail.gmail.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Sergey Ivanov <sergey57@gmail.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, XFS <xfs@oss.sgi.com>

On Wed, Jun 1, 2011 at 7:37 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 5/31/11 10:13 PM, Amir Goldstein wrote:
>> From: Amir Goldstein <amir73il@users.sf.net>
>>
>> blkid knows to identify the ext4dev FSTYP of a partition that was
>> formatted with mkfs.ext4dev.
>> quota tools and various util-linux utils are also aware of ext4dev,
>> so ext4dev shares the same capabilities as ext4.
>>
>> While testing on Fedora 15, we encoutered a buggy fsck utility, which
>> invokes fsck.ext4, even though it was called with -t ext4dev argument.
>> In our setup fsck.ext4dev knows about new fs features that fsck.ext4
>> doesn't know, so the generic_fs_check fails.
>> Since we have no real use of the extra capabilities provided by fsck uti=
l,
>> we decided to invoke fsck.$FSTYP directly to avoid this issue.
>
> Adding ext4dev to every case seems harmless enough. =A0TBH I thought I had
> it there already but I guess not.
>
> I'm less certain of the change from fsck -t $FSTYP to fsck.$FSTYP
>
> What issue are you avoiding? =A0wouldn't fsck -t ext4dev invoke fsck.ext4=
dev anyway?
>
> It seems like it should be harmless, but I don't understand how it helps =
you.
>

As I wrote in the patch description, the fsck utility in Fedora 15 invokes
fsck.ext4 for some reason when calling fsck -t ext4dev.
this fails because fsck.ext4 doesn't know the snapshot feature.
I didn't debug fsck utility for that. it seemed pointless.

> Thanks,
> -Eric
>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>> Tested-by: Sergey Ivanov <sergey57@gmail.com>
>> ---
>> ext4dev is used to test experimental ext4 code in mutual existance
>> with production ext4 code on the same system.
>>
>> Specifically, ext4 snapshots code is available for testing as a
>> stand-alone ext4dev module for Fedora 15 and Ubuntu 11.4
>> (see http://next3.sf.net).
>>
>> =A0common.defrag | =A0 =A02 +-
>> =A0common.quota =A0| =A0 =A04 ++--
>> =A0common.rc =A0 =A0 | =A0 12 ++++++------
>> =A03 files changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/common.defrag b/common.defrag
>> index 1bcf01d..4850803 100644
>> --- a/common.defrag
>> +++ b/common.defrag
>> @@ -26,7 +26,7 @@ _require_defrag()
>> =A0 =A0 =A0xfs)
>> =A0 =A0 =A0 =A0 =A0DEFRAG_PROG=3D/usr/sbin/xfs_fsr
>> =A0 =A0 =A0 ;;
>> - =A0 =A0ext4)
>> + =A0 =A0ext4|ext4dev)
>> =A0 =A0 =A0 =A0 =A0DEFRAG_PROG=3D/usr/bin/e4defrag
>> =A0 =A0 =A0 ;;
>> =A0 =A0 =A0*)
>> diff --git a/common.quota b/common.quota
>> index 3c87ce1..9eac19d 100644
>> --- a/common.quota
>> +++ b/common.quota
>> @@ -29,7 +29,7 @@ _require_quota()
>> =A0 =A0 =A0[ -n $QUOTA_PROG ] || _notrun "Quota user tools not installed"
>>
>> =A0 =A0 =A0case $FSTYP in
>> - =A0 =A0ext2|ext3|ext4|reiserfs)
>> + =A0 =A0ext2|ext3|ext4|ext4dev|reiserfs)
>> =A0 =A0 =A0 if [ ! -d /proc/sys/fs/quota ]; then
>> =A0 =A0 =A0 =A0 =A0 _notrun "Installed kernel does not support quotas"
>> =A0 =A0 =A0 fi
>> @@ -237,7 +237,7 @@ _check_quota_usage()
>> =A0 =A0 =A0 # Sync to get delalloc to disk
>> =A0 =A0 =A0 sync
>> =A0 =A0 =A0 VFS_QUOTA=3D0
>> - =A0 =A0 if [ $FSTYP =3D "ext2" -o $FSTYP =3D "ext3" -o $FSTYP =3D "ext=
4" -o $FSTYP
>> =3D "reiserfs" ]; then
>> + =A0 =A0 if [ $FSTYP =3D "ext2" -o $FSTYP =3D "ext3" -o $FSTYP =3D "ext=
4" -o $FSTYP
>> =3D "ext4dev" -o $FSTYP =3D "reiserfs" ]; then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 VFS_QUOTA=3D1
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
>> =A0 =A0 =A0 fi
>> diff --git a/common.rc b/common.rc
>> index e634fbb..e71fe9c 100644
>> --- a/common.rc
>> +++ b/common.rc
>> @@ -65,7 +65,7 @@ _mount_opts()
>> =A0 =A0 =A0nfs)
>> =A0 =A0 =A0 export MOUNT_OPTIONS=3D$NFS_MOUNT_OPTIONS
>> =A0 =A0 =A0 ;;
>> - =A0 =A0ext2|ext3|ext4)
>> + =A0 =A0ext2|ext3|ext4|ext4dev)
>> =A0 =A0 =A0 # acls & xattrs aren't turned on by default on ext$FOO
>> =A0 =A0 =A0 export MOUNT_OPTIONS=3D"-o acl,user_xattr $EXT_MOUNT_OPTIONS"
>> =A0 =A0 =A0 ;;
>> @@ -110,7 +110,7 @@ _mkfs_opts()
>> =A0_fsck_opts()
>> =A0{
>> =A0 =A0 =A0case $FSTYP in
>> - =A0 =A0ext2|ext3|ext4)
>> + =A0 =A0ext2|ext3|ext4|ext4dev)
>> =A0 =A0 =A0 export FSCK_OPTIONS=3D"-nf"
>> =A0 =A0 =A0 ;;
>> =A0 =A0 =A0reiserfs)
>> @@ -326,10 +326,10 @@ _scratch_mkfs_sized()
>> =A0 =A0 =A0xfs)
>> =A0 =A0 =A0 _scratch_mkfs_xfs -d size=3D$fssize -b size=3D$blocksize
>> =A0 =A0 =A0 ;;
>> - =A0 =A0ext2|ext3|ext4)
>> + =A0 =A0ext2|ext3|ext4|ext4dev)
>> =A0 =A0 =A0 /sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $=
blocks
>> =A0 =A0 =A0 ;;
>> - =A0 =A0 btrfs)
>> + =A0 =A0btrfs)
>> =A0 =A0 =A0 /sbin/mkfs.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV -b $fssize
>> =A0 =A0 =A0 ;;
>> =A0 =A0 =A0*)
>> @@ -354,7 +354,7 @@ _scratch_mkfs_geom()
>> =A0 =A0 =A0xfs)
>> =A0 =A0 =A0 MKFS_OPTIONS+=3D" -b size=3D$blocksize, -d su=3D$sunit_bytes=
,sw=3D$swidth_mult"
>> =A0 =A0 =A0 ;;
>> - =A0 =A0ext4)
>> + =A0 =A0ext4|ext4dev)
>> =A0 =A0 =A0 MKFS_OPTIONS+=3D" -b $blocksize -E
>> stride=3D$sunit_blocks,stripe_width=3D$swidth_blocks"
>> =A0 =A0 =A0 ;;
>> =A0 =A0 =A0*)
>> @@ -1026,7 +1026,7 @@ _check_generic_filesystem()
>> =A0 =A0 =A0 =A0 =A0mountpoint=3D`_umount_or_remount_ro $device`
>> =A0 =A0 =A0fi
>>
>> - =A0 =A0fsck -t $FSTYP $FSCK_OPTIONS $device >$tmp.fsck 2>&1
>> + =A0 =A0fsck.$FSTYP $FSCK_OPTIONS $device >$tmp.fsck 2>&1
>> =A0 =A0 =A0if [ $? -ne 0 ]
>> =A0 =A0 =A0then
>> =A0 =A0 =A0 =A0 =A0echo "_check_generic_filesystem: filesystem on $devic=
e is
>> inconsistent (see $seq.full)"
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
