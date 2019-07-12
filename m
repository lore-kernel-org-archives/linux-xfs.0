Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:27610 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfGLIbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jul 2019 04:31:49 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
Date: Fri, 12 Jul 2019 08:31:32 +0000
Message-ID: <BN8PR04MB581241A65E81F79882508F4BE7F20@BN8PR04MB5812.namprd04.prod.outlook.com>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
 <20190712080022.GA16276@x250.microfocus.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

On 2019/07/12 17:00, Johannes Thumshirn wrote:=0A=
> On Fri, Jul 12, 2019 at 12:00:17PM +0900, Damien Le Moal wrote:=0A=
> =0A=
> Hi Daminen,=0A=
> =0A=
> Thanks for submitting zonefs.=0A=
> =0A=
> Please find my first few comments, I'll have a second look later as well.=
=0A=
> =0A=
> [...]=0A=
> =0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>  fs/Kconfig                 |    2 +=0A=
>>  fs/Makefile                |    1 +=0A=
>>  fs/zonefs/Kconfig          |    9 +=0A=
>>  fs/zonefs/Makefile         |    4 +=0A=
>>  fs/zonefs/super.c          | 1004 ++++++++++++++++++++++++++++++++++++=
=0A=
>>  fs/zonefs/zonefs.h         |  190 +++++++=0A=
>>  include/uapi/linux/magic.h |    1 +=0A=
>>  7 files changed, 1211 insertions(+)=0A=
>>  create mode 100644 fs/zonefs/Kconfig=0A=
>>  create mode 100644 fs/zonefs/Makefile=0A=
>>  create mode 100644 fs/zonefs/super.c=0A=
>>  create mode 100644 fs/zonefs/zonefs.h=0A=
> =0A=
> It'll probably be good to add yourself as a maitainer in MAINTAINERS, so=
=0A=
> people see there's a go-to person for patches. Also a list (fsdevel@) and=
 a=0A=
> git tree won't harm.=0A=
=0A=
Oops. Yes, indeed. I forgot to add that. I will.=0A=
=0A=
> =0A=
>>=0A=
>> diff --git a/fs/Kconfig b/fs/Kconfig=0A=
>> index f1046cf6ad85..e48cc0e0efbb 100644=0A=
>> --- a/fs/Kconfig=0A=
>> +++ b/fs/Kconfig=0A=
>> @@ -41,6 +41,7 @@ source "fs/ocfs2/Kconfig"=0A=
>>  source "fs/btrfs/Kconfig"=0A=
>>  source "fs/nilfs2/Kconfig"=0A=
>>  source "fs/f2fs/Kconfig"=0A=
>> +source "fs/zonefs/Kconfig"=0A=
>>  =0A=
>>  config FS_DAX=0A=
>>  	bool "Direct Access (DAX) support"=0A=
>> @@ -262,6 +263,7 @@ source "fs/romfs/Kconfig"=0A=
>>  source "fs/pstore/Kconfig"=0A=
>>  source "fs/sysv/Kconfig"=0A=
>>  source "fs/ufs/Kconfig"=0A=
>> +source "fs/ufs/Kconfig"=0A=
>>  =0A=
> =0A=
> This hunk looks wrong.=0A=
=0A=
Yes it is wrong. No idea how that sneaked in here. Will fix it.=0A=
=0A=
> =0A=
>>  endif # MISC_FILESYSTEMS=0A=
>>  =0A=
> =0A=
> [...]=0A=
> =0A=
>> +	/*=0A=
>> +	 * Note: The first zone contains the super block: skip it.=0A=
>> +	 */=0A=
> =0A=
> I know I've been advocating for having on-disk metadata, but do we really=
=0A=
> sacrifice a whole zone per default? I thought we'll have on-disk metadata=
=0A=
> optional (I might be completely off the track here and need more coffee t=
o=0A=
> wake up though).=0A=
=0A=
Yes, indeed we do not really need the super block for now. But it is still =
super=0A=
useful to have so that:=0A=
1) libblkid and other such userland tools can probe the disk to see its for=
mat,=0A=
and preserve the usual "use -force option if you really want to overwrite"=
=0A=
behavior of all format tools.=0A=
2) Still related to previous point, the super block allows commands like:=
=0A=
mount /dev/sdX /mnt=0A=
and=0A=
mount -t zonefs /dev/sdX /mnt=0A=
to have the same result. That is, without the super block, if the drive was=
=0A=
previously formatted for btrfs or f2fs, the first command will mount that o=
ld=0A=
format, while the second will mount zonefs without necessarily erasing the =
old=0A=
FS super block.=0A=
3) Having the super block with a version number will allow in the future to=
 add=0A=
more metadata (e.g. file names as decided by the application) while allowin=
g=0A=
backward compatibility of the code.=0A=
=0A=
>> +	end =3D zones + sbi->s_nr_zones[ZONEFS_ZTYPE_ALL];=0A=
>> +	for (zone =3D &zones[1]; zone < end; zone =3D next) {=0A=
> =0A=
> [...]=0A=
> =0A=
>> +=0A=
>> +	/* Set defaults */=0A=
>> +	sbi->s_uid =3D GLOBAL_ROOT_UID;=0A=
>> +	sbi->s_gid =3D GLOBAL_ROOT_GID;=0A=
>> +	sbi->s_perm =3D S_IRUSR | S_IWUSR | S_IRGRP; /* 0640 */=0A=
>> +=0A=
>> +=0A=
>> +	ret =3D zonefs_read_super(sb);=0A=
>> +	if (ret)=0A=
>> +		return ret;=0A=
> =0A=
> That would be cool to be controllable via a mount option and have it:=0A=
> 	sbi->s_uid =3D opt.uid;=0A=
> 	sbi->s_gid =3D opt.gid;=0A=
> 	sbi->s_perm =3D opt.mode;=0A=
> =0A=
> or pass these mount options to zonefs_read_super() and they can be set af=
ter=0A=
> the feature validation.=0A=
=0A=
Yes, I thought of that and even had that implemented in a previous version.=
 I=0A=
switched to the static format time definition only so that the resulting=0A=
operation of the FS is a little more like a normal file system, namely, mou=
nting=0A=
the device does not change file attributes and so can be mounted and seen w=
ith=0A=
the same attribute no matter where it is mounted, regardless of the mount o=
ptions.=0A=
=0A=
> [...]=0A=
=0A=
Thanks for the nits and typos pointer. I will fix that.=0A=
=0A=
>> +struct zonefs_super {=0A=
>> +=0A=
>> +	/* Magic number */=0A=
>> +	__le32		s_magic;		/*    4 */=0A=
>> +=0A=
>> +	/* Metadata version number */=0A=
>> +	__le32		s_version;		/*    8 */=0A=
>> +=0A=
>> +	/* Features */=0A=
>> +	__le64		s_features;		/*   16 */=0A=
>> +=0A=
>> +	/* 128-bit uuid */=0A=
>> +	__u8		s_uuid[16];		/*   32 */=0A=
>> +=0A=
>> +	/* UID/GID to use for files */=0A=
>> +	__le32		s_uid;			/*   36 */=0A=
>> +	__le32		s_gid;			/*   40 */=0A=
>> +=0A=
>> +	/* File permissions */=0A=
>> +	__le32		s_perm;			/*   44 */=0A=
>> +=0A=
>> +	/* Padding to 4K */=0A=
>> +	__u8		s_reserved[4052];	/* 4096 */=0A=
>> +=0A=
>> +} __attribute__ ((packed));=0A=
> =0A=
> I'm not sure the (end)offset comments are of any value here, it's nothing=
 that=0A=
> can't be obtained from pahole or gdb (or even by hand).=0A=
=0A=
OK. Will remove.=0A=
=0A=
>> +/*=0A=
>> + * Metadata version.=0A=
>> + */=0A=
>> +#define ZONEFS_VERSION	1=0A=
>> +=0A=
>> +/*=0A=
>> + * Feature flags.=0A=
>> + */=0A=
>> +enum zonefs_features {=0A=
>> +	/*=0A=
>> +	 * Use a zone start sector value as file name.=0A=
>> +	 */=0A=
>> +	ZONEFS_F_STARTSECT_NAME,=0A=
>> +	/*=0A=
>> +	 * Aggregate contiguous conventional zones into a single file.=0A=
>> +	 */=0A=
>> +	ZONEFS_F_AGRCNV,=0A=
>> +	/*=0A=
>> +	 * Use super block specified UID for files instead of default.=0A=
>> +	 */=0A=
>> +	ZONEFS_F_UID,=0A=
>> +	/*=0A=
>> +	 * Use super block specified GID for files instead of default.=0A=
>> +	 */=0A=
>> +	ZONEFS_F_GID,=0A=
>> +	/*=0A=
>> +	 * Use super block specified file permissions instead of default 640.=
=0A=
>> +	 */=0A=
>> +	ZONEFS_F_PERM,=0A=
>> +};=0A=
> =0A=
> I'd rather not write the uid, gid, permissions and startsect name to the=
=0A=
> superblock but have it controllable via a mount option. Just write the fe=
ature=0A=
> to the superblock so we know we _can_ control this per mount.=0A=
=0A=
This is another view. See my thinking above. Thoughts ?=0A=
=0A=
Thanks !=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
