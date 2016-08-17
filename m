Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7CE977CA0
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2016 09:43:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F07C3040CD
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2016 07:43:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id smzPvPbtXoKE7Eh3 for <xfs@oss.sgi.com>;
	Wed, 17 Aug 2016 07:43:37 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D7E2E4456
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2016 09:43:36 -0500 (CDT)
Subject: Re: [PATCH V2] xfs_quota: wire up XFS_GETQSTATV
References: <a8d81afb-8c95-c6bf-028d-8d6e463557b3@redhat.com>
	<2ca2dc3b-53d2-0791-644f-c9cd5abef89f@sandeen.net>
	<20160817083340.GB7193@zlang.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <82f3c5f9-204d-845f-16cf-c267085242ac@sandeen.net>
Date: Wed, 17 Aug 2016 09:43:36 -0500
MIME-Version: 1.0
In-Reply-To: <20160817083340.GB7193@zlang.usersys.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 8/17/16 3:33 AM, Zorro Lang wrote:

> Hi Eric,
> 
> This's what I tried to explain to you:
> 
>   [root@dhcp-13-149 ~]# mount /dev/mapper/testvg-scratchdev /mnt/scratch -o pquota,gquota,uquota
>   [root@dhcp-13-149 xfsprogs-dev]# xfs_quota -xc "limit bsoft=100m bhard=200m fsgqa" /mnt/scratch
>   [root@dhcp-13-149 xfsprogs-dev]# xfs_quota -xc "limit -g bsoft=100m bhard=200m fsgqa" /mnt/scratch
>   [root@dhcp-13-149 xfsprogs-dev]# xfs_quota -xc "state" /mnt/scratch
>   User quota state on /mnt/scratch (/dev/mapper/testvg-scratchdev)
>     Accounting: ON
>     Enforcement: ON
>     Inode: #101 (2 blocks, 2 extents)
>   Group quota state on /mnt/scratch (/dev/mapper/testvg-scratchdev)
>     Accounting: ON
>     Enforcement: ON
>     Inode: #99 (2 blocks, 2 extents)
>   Project quota state on /mnt/scratch (/dev/mapper/testvg-scratchdev)
>     Accounting: ON
>     Enforcement: ON
>     Inode: #100 (1 blocks, 1 extents)
>   Blocks grace time: [7 days]
>   Inodes grace time: [7 days]
>   Realtime Blocks grace time: [7 days]

And that's all correct, right.

>   [root@dhcp-13-149 xfsprogs-dev]# umount /mnt/scratch
>   [root@dhcp-13-149 xfsprogs-dev]# mount /dev/mapper/testvg-scratchdev /mnt/scratch -o pquota

Now you have only pquota...

>   [root@dhcp-13-149 xfsprogs-dev]# xfs_quota -xc "state" /mnt/scratch
>   User quota state on /mnt/scratch (/dev/mapper/testvg-scratchdev)
>     Accounting: OFF
>     Enforcement: OFF
>     Inode: #0 (0 blocks, 0 extents)
>   Group quota state on /mnt/scratch (/dev/mapper/testvg-scratchdev)
>     Accounting: OFF
>     Enforcement: OFF
>     Inode: #0 (0 blocks, 0 extents)
>   Project quota state on /mnt/scratch (/dev/mapper/testvg-scratchdev)
>     Accounting: ON
>     Enforcement: ON
>     Inode: #100 (1 blocks, 1 extents)
>   Blocks grace time: [7 days]
>   Inodes grace time: [7 days]
>   Realtime Blocks grace time: [7 days]

And pquota is properly shown, but user and group show inode 0.

>   [root@dhcp-13-149 ~]# xfs_db -r -c "sb 0" -c "p" /dev/mapper/testvg-scratchdev|grep quot
>   uquotino = 101
>   gquotino = 99
>   pquotino = 100
> 
> 
> If I someone quota isn't enable, "state" command will print that inode
> number, blocks and extents as 0.

*nod*

> Do you think this's a problem should be fixed?
> If it's a bug, maybe we can fix it on another patch later, because
> it's another bug?

This is a bug in the kernel, because it does not fill in inode information
for inactive quota types, and fills in 0 instead (so we don't even
get NULLFSINO).

I did send a patch for this,

[PATCH] quota: fill in Q_XGETQSTAT inode information for inactive quotas

to the linux-fsdevel list (it is in common vfs quota code, but I probably
should have cc'd the xfs list as well).  Jan has indicated that he has
merged it.

With that patch and this one, it should all work as expected.

Thanks,
-Eric

> Thanks,
> Zorro
> 
>>
>> I probably could have done some memcpy()'s in 
>> state_stat_to_statv(), but opted for the explicit copy-out;
>> the structures aren't identical, although the newer one 
>> only differs by padding on the end.  If memcpy() is preferable
>> I could send a V2...
>>
>> V2: set sv.qs_version = FS_QSTATV_VERSION1; before calling
>> the quotactl (thanks Zorro!)
>>
>> diff --git a/include/xqm.h b/include/xqm.h
>> index c084b2d..5b6934a 100644
>> --- a/include/xqm.h
>> +++ b/include/xqm.h
>> @@ -32,6 +32,7 @@
>>  #define Q_XGETQSTAT	XQM_CMD(5)	/* get quota subsystem status */
>>  #define Q_XQUOTARM	XQM_CMD(6)	/* free disk space used by dquots */
>>  #define Q_XQUOTASYNC	XQM_CMD(7)	/* delalloc flush, updates dquots */
>> +#define Q_XGETQSTATV	XQM_CMD(8)	/* newer version of get quota */
>>  #define Q_XGETNEXTQUOTA	XQM_CMD(9)	/* get disk limits and usage */
>>  
>>  /*
>> @@ -149,4 +150,35 @@ typedef struct fs_quota_stat {
>>  	__u16		qs_iwarnlimit;	/* limit for num warnings */
>>  } fs_quota_stat_t;
>>  
>> +
>> +#ifndef FS_QSTATV_VERSION1
>> +#define FS_QSTATV_VERSION1	1	/* fs_quota_statv.qs_version */
>> +#endif
>> +
>> +/*
>> + * Some basic information about 'quota files' for Q_XGETQSTATV command
>> + */
>> +struct fs_qfilestatv {
>> +	__u64		qfs_ino;	/* inode number */
>> +	__u64		qfs_nblks;	/* number of BBs 512-byte-blks */
>> +	__u32		qfs_nextents;	/* number of extents */
>> +	__u32		qfs_pad;	/* pad for 8-byte alignment */
>> +};
>> +
>> +struct fs_quota_statv {
>> +	__s8			qs_version;	/* version for future changes */
>> +	__u8			qs_pad1;	/* pad for 16bit alignment */
>> +	__u16			qs_flags;	/* FS_QUOTA_.* flags */
>> +	__u32			qs_incoredqs;	/* number of dquots incore */
>> +	struct fs_qfilestatv	qs_uquota;	/* user quota information */
>> +	struct fs_qfilestatv	qs_gquota;	/* group quota information */
>> +	struct fs_qfilestatv	qs_pquota;	/* project quota information */
>> +	__s32			qs_btimelimit;	/* limit for blks timer */
>> +	__s32			qs_itimelimit;	/* limit for inodes timer */
>> +	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
>> +	__u16			qs_bwarnlimit;	/* limit for num warnings */
>> +	__u16			qs_iwarnlimit;	/* limit for num warnings */
>> +	__u64			qs_pad2[8];	/* for future proofing */
>> +};
>> +
>>  #endif	/* __XQM_H__ */
>> diff --git a/quota/linux.c b/quota/linux.c
>> index 74dba01..4f1f3c4 100644
>> --- a/quota/linux.c
>> +++ b/quota/linux.c
>> @@ -55,6 +55,8 @@ xcommand_to_qcommand(
>>  		return Q_XSETQLIM;
>>  	case XFS_GETQSTAT:
>>  		return Q_XGETQSTAT;
>> +	case XFS_GETQSTATV:
>> +		return Q_XGETQSTATV;
>>  	case XFS_QUOTARM:
>>  		return Q_XQUOTARM;
>>  	case XFS_QSYNC:
>> diff --git a/quota/state.c b/quota/state.c
>> index 8186762..9f6616e 100644
>> --- a/quota/state.c
>> +++ b/quota/state.c
>> @@ -111,12 +111,12 @@ remove_help(void)
>>  
>>  static void
>>  state_qfilestat(
>> -	FILE		*fp,
>> -	fs_path_t	*mount,
>> -	uint		type,
>> -	fs_qfilestat_t	*qfs,
>> -	int		accounting,
>> -	int		enforcing)
>> +	FILE			*fp,
>> +	struct fs_path		*mount,
>> +	uint			type,
>> +	struct fs_qfilestatv	*qfs,
>> +	int			accounting,
>> +	int			enforcing)
>>  {
>>  	fprintf(fp, _("%s quota state on %s (%s)\n"), type_to_string(type),
>>  		mount->fs_dir, mount->fs_name);
>> @@ -142,39 +142,96 @@ state_timelimit(
>>  		time_to_string(timelimit, VERBOSE_FLAG | ABSOLUTE_FLAG));
>>  }
>>  
>> +/*
>> + * fs_quota_stat holds a subset of fs_quota_statv; this copies
>> + * the smaller into the larger, leaving any not-present fields
>> + * empty.  This is so the same reporting function can be used
>> + * for both XFS_GETQSTAT and XFS_GETQSTATV results.
>> + */
>>  static void
>> -state_quotafile_mount(
>> -	FILE		*fp,
>> -	uint		type,
>> -	fs_path_t	*mount,
>> -	uint		flags)
>> +state_stat_to_statv(
>> +	struct fs_quota_stat	*s,
>> +	struct fs_quota_statv	*sv)
>>  {
>> -	fs_quota_stat_t	s;
>> -	char		*dev = mount->fs_name;
>> +	memset(sv, 0, sizeof(struct fs_quota_statv));
>> +
>> +	/* shared information */
>> +	sv->qs_version = s->qs_version;
>> +	sv->qs_flags = s->qs_flags;
>> +	sv->qs_incoredqs = s->qs_incoredqs;
>> +	sv->qs_btimelimit = s->qs_btimelimit;
>> +	sv->qs_itimelimit = s->qs_itimelimit;
>> +	sv->qs_rtbtimelimit = s->qs_rtbtimelimit;
>> +	sv->qs_bwarnlimit = s->qs_bwarnlimit;
>> +	sv->qs_iwarnlimit = s->qs_iwarnlimit;
>> +
>> +	/* Always room for uquota */
>> +	sv->qs_uquota.qfs_ino = s->qs_uquota.qfs_ino;
>> +	sv->qs_uquota.qfs_nblks = s->qs_uquota.qfs_nblks;
>> +	sv->qs_uquota.qfs_nextents = s->qs_uquota.qfs_nextents;
>> +
>> +	/*
>> +	 * If we are here, XFS_GETQSTATV failed and XFS_GETQSTAT passed;
>> +	 * that is a very strong hint that we're on a kernel which predates
>> +	 * the on-disk pquota inode; both were added in v3.12.  So, we do
>> +	 * some tricksy determination here.
>> +	 * gs_gquota may hold either group quota inode info, or project
>> +	 * quota if that is used instead; which one it actually holds depends
>> +	 * on the quota flags.  (If neither is set, neither is used)
>> +	 */
>> +	if (s->qs_flags & XFS_QUOTA_GDQ_ACCT) {
>> +		/* gs_gquota holds group quota info */
>> +		sv->qs_gquota.qfs_ino = s->qs_gquota.qfs_ino;
>> +		sv->qs_gquota.qfs_nblks = s->qs_gquota.qfs_nblks;
>> +		sv->qs_gquota.qfs_nextents = s->qs_gquota.qfs_nextents;
>> +	} else if (s->qs_flags & XFS_QUOTA_PDQ_ACCT) {
>> +		/* gs_gquota actually holds project quota info */
>> +		sv->qs_pquota.qfs_ino = s->qs_gquota.qfs_ino;
>> +		sv->qs_pquota.qfs_nblks = s->qs_gquota.qfs_nblks;
>> +		sv->qs_pquota.qfs_nextents = s->qs_gquota.qfs_nextents;
>> +	}
>> +}
>>  
>> -	if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)&s) < 0) {
>> -		if (flags & VERBOSE_FLAG)
>> -			fprintf(fp, _("%s quota are not enabled on %s\n"),
>> -				type_to_string(type), dev);
>> -		return;
>> +static void
>> +state_quotafile_mount(
>> +	FILE			*fp,
>> +	uint			type,
>> +	struct fs_path		*mount,
>> +	uint			flags)
>> +{
>> +	struct fs_quota_stat	s;
>> +	struct fs_quota_statv	sv;
>> +	char			*dev = mount->fs_name;
>> +
>> +	sv.qs_version = FS_QSTATV_VERSION1;
>> +
>> +	if (xfsquotactl(XFS_GETQSTATV, dev, type, 0, (void *)&sv) < 0) {
>> +		if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)&s) < 0) {
>> +			if (flags & VERBOSE_FLAG)
>> +				fprintf(fp,
>> +					_("%s quota are not enabled on %s\n"),
>> +					type_to_string(type), dev);
>> +			return;
>> +		}
>> +		state_stat_to_statv(&s, &sv);
>>  	}
>>  
>>  	if (type & XFS_USER_QUOTA)
>> -		state_qfilestat(fp, mount, XFS_USER_QUOTA, &s.qs_uquota,
>> -				s.qs_flags & XFS_QUOTA_UDQ_ACCT,
>> -				s.qs_flags & XFS_QUOTA_UDQ_ENFD);
>> +		state_qfilestat(fp, mount, XFS_USER_QUOTA, &sv.qs_uquota,
>> +				sv.qs_flags & XFS_QUOTA_UDQ_ACCT,
>> +				sv.qs_flags & XFS_QUOTA_UDQ_ENFD);
>>  	if (type & XFS_GROUP_QUOTA)
>> -		state_qfilestat(fp, mount, XFS_GROUP_QUOTA, &s.qs_gquota,
>> -				s.qs_flags & XFS_QUOTA_GDQ_ACCT,
>> -				s.qs_flags & XFS_QUOTA_GDQ_ENFD);
>> +		state_qfilestat(fp, mount, XFS_GROUP_QUOTA, &sv.qs_gquota,
>> +				sv.qs_flags & XFS_QUOTA_GDQ_ACCT,
>> +				sv.qs_flags & XFS_QUOTA_GDQ_ENFD);
>>  	if (type & XFS_PROJ_QUOTA)
>> -		state_qfilestat(fp, mount, XFS_PROJ_QUOTA, &s.qs_gquota,
>> -				s.qs_flags & XFS_QUOTA_PDQ_ACCT,
>> -				s.qs_flags & XFS_QUOTA_PDQ_ENFD);
>> +		state_qfilestat(fp, mount, XFS_PROJ_QUOTA, &sv.qs_pquota,
>> +				sv.qs_flags & XFS_QUOTA_PDQ_ACCT,
>> +				sv.qs_flags & XFS_QUOTA_PDQ_ENFD);
>>  
>> -	state_timelimit(fp, XFS_BLOCK_QUOTA, s.qs_btimelimit);
>> -	state_timelimit(fp, XFS_INODE_QUOTA, s.qs_itimelimit);
>> -	state_timelimit(fp, XFS_RTBLOCK_QUOTA, s.qs_rtbtimelimit);
>> +	state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
>> +	state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
>> +	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
>>  }
>>  
>>  static void
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
