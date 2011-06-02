Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p522G8rG160650 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 21:16:08 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4917F167B688
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 19:16:06 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id oYXekCYqVeUPrGGf
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2011 19:16:06 -0700 (PDT)
Received: by wyi11 with SMTP id 11so313077wyi.26
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2011 19:16:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110601232804.GL32466@dastard>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
Date: Thu, 2 Jun 2011 05:16:05 +0300
Message-ID: <BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
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

On Thu, Jun 2, 2011 at 2:28 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jun 01, 2011 at 03:56:52PM +0300, amir73il@users.sourceforge.net =
wrote:
>> From: Amir Goldstein <amir73il@users.sf.net>
>>
>> From: Amir Goldstein <amir73il@users.sf.net>
>>
>> blkid knows to identify the ext4dev FSTYP of a partition that was
>> formatted with mkfs.ext4dev.
>> quota tools and various util-linux utils are also aware of ext4dev,
>> so ext4dev shares the same capabilities as ext4.
>>
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
>> v1 -> v2:
>> - undo change of fsck -t $FSTYP to fsck.$FSTYP
>>
>> =A0common.defrag | =A0 =A02 +-
>> =A0common.quota =A0| =A0 =A04 ++--
>> =A0common.rc =A0 =A0 | =A0 10 +++++-----
>> =A03 files changed, 8 insertions(+), 8 deletions(-)
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
>> index 3c87ce1..b6d5f16 100644
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
4" -o $FSTYP =3D "reiserfs" ]; then
>> + =A0 =A0 if [ $FSTYP =3D "ext2" -o $FSTYP =3D "ext3" -o $FSTYP =3D "ext=
4" -o $FSTYP =3D "ext4dev" -o $FSTYP =3D "reiserfs" ]; then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 VFS_QUOTA=3D1
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
>> =A0 =A0 =A0 fi
>
> Perhaps this should be changes to a case statement?
>

you're making me go to v3 in such a trivial patch, but ok, I'll do it ;-)

> Cheers,
>
> Dave.
>
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
