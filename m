Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44874 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755019AbeEHT3A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 15:29:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w48JQqc1090991
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 19:28:59 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2hs24sjc3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 19:28:59 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w48JSwMi001661
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 19:28:58 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w48JSw1J024580
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 19:28:58 GMT
Subject: Re: [PATCH 20/21] xfsprogs: Add parent pointers during protofile
 creation
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-21-git-send-email-allison.henderson@oracle.com>
 <20180508174305.GT11261@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <dc63c74f-4919-1b66-3466-0e7cda69ca26@oracle.com>
Date: Tue, 8 May 2018 12:28:56 -0700
MIME-Version: 1.0
In-Reply-To: <20180508174305.GT11261@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 05/08/2018 10:43 AM, Darrick J. Wong wrote:
> On Mon, May 07, 2018 at 09:41:18PM -0700, Allison Henderson wrote:
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   mkfs/proto.c         | 59 ++++++++++++++++++++++++++++++++++------------------
>>   repair/attr_repair.c | 16 ++------------
> Separate patches for separate utilities, please.
>
>>   repair/phase6.c      | 47 +++++++++++++++++++++++++----------------
>>   3 files changed, 70 insertions(+), 52 deletions(-)
>>
>> diff --git a/mkfs/proto.c b/mkfs/proto.c
>> index 67c228a..3e4fd33 100644
>> --- a/mkfs/proto.c
>> +++ b/mkfs/proto.c
>> @@ -19,6 +19,7 @@
>>   #include "libxfs.h"
>>   #include <sys/stat.h>
>>   #include "xfs_multidisk.h"
>> +#include "xfs_parent.h"
>>   
>>   /*
>>    * Prototypes for internal functions.
>> @@ -318,23 +319,25 @@ newregfile(
>>   
>>   static void
>>   newdirent(
>> -	xfs_mount_t	*mp,
>> -	xfs_trans_t	*tp,
>> -	xfs_inode_t	*pip,
>> -	struct xfs_name	*name,
>> -	xfs_ino_t	inum,
>> -	xfs_fsblock_t	*first,
>> -	struct xfs_defer_ops	*dfops)
>> +	xfs_mount_t		*mp,
> While you're changing these lines, get rid of the _t usage when
> appropriate.
>
> 	struct xfs_trans	*tp,
>
> Here and elsewhere in the patch.
Sure, will do
>
>> +	xfs_trans_t		*tp,
>> +	xfs_inode_t		*pip,
>> +	struct xfs_name		*name,
>> +	struct xfs_inode	*ip,
>> +	xfs_fsblock_t		*first,
>> +	struct xfs_defer_ops	*dfops,
>> +	xfs_dir2_dataptr_t      *offset)
>>   {
>> -	int	error;
>> -	int	rsv;
>> +	int			error;
>> +	int			rsv;
>>   
>>   	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
>>   
>> -	error = -libxfs_dir_createname(tp, pip, name, inum, first, dfops, rsv,
>> -				       NULL);
>> +	error = -libxfs_dir_createname(tp, pip, name, ip->i_ino, first, dfops, rsv,
>> +				       offset);
>>   	if (error)
>>   		fail(_("directory createname error"), error);
>> +
>>   }
>>   
>>   static void
>> @@ -387,6 +390,7 @@ parseproto(
>>   	cred_t		creds;
>>   	char		*value;
>>   	struct xfs_name	xname;
>> +	xfs_dir2_dataptr_t offset;
>>   
>>   	memset(&creds, 0, sizeof(creds));
>>   	mstr = getstr(pp);
>> @@ -470,7 +474,7 @@ parseproto(
>>   			free(buf);
>>   		libxfs_trans_ijoin(tp, pip, 0);
>>   		xname.type = XFS_DIR3_FT_REG_FILE;
>> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
>> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>>   		break;
>>   
>>   	case IF_RESERVED:			/* pre-allocated space only */
>> @@ -493,7 +497,7 @@ parseproto(
>>   		libxfs_trans_ijoin(tp, pip, 0);
>>   
>>   		xname.type = XFS_DIR3_FT_REG_FILE;
>> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
>> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>>   		libxfs_trans_log_inode(tp, ip, flags);
>>   
>>   		libxfs_defer_ijoin(&dfops, ip);
>> @@ -516,7 +520,7 @@ parseproto(
>>   		}
>>   		libxfs_trans_ijoin(tp, pip, 0);
>>   		xname.type = XFS_DIR3_FT_BLKDEV;
>> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
>> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>>   		flags |= XFS_ILOG_DEV;
>>   		break;
>>   
>> @@ -530,7 +534,7 @@ parseproto(
>>   			fail(_("Inode allocation failed"), error);
>>   		libxfs_trans_ijoin(tp, pip, 0);
>>   		xname.type = XFS_DIR3_FT_CHRDEV;
>> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
>> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>>   		flags |= XFS_ILOG_DEV;
>>   		break;
>>   
>> @@ -542,7 +546,7 @@ parseproto(
>>   			fail(_("Inode allocation failed"), error);
>>   		libxfs_trans_ijoin(tp, pip, 0);
>>   		xname.type = XFS_DIR3_FT_FIFO;
>> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
>> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>>   		break;
>>   	case IF_SYMLINK:
>>   		buf = getstr(pp);
>> @@ -555,7 +559,7 @@ parseproto(
>>   		flags |= newfile(tp, ip, &dfops, &first, 1, 1, buf, len);
>>   		libxfs_trans_ijoin(tp, pip, 0);
>>   		xname.type = XFS_DIR3_FT_SYMLINK;
>> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
>> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>>   		break;
>>   	case IF_DIRECTORY:
>>   		tp = getres(mp, 0);
>> @@ -572,8 +576,8 @@ parseproto(
>>   		} else {
>>   			libxfs_trans_ijoin(tp, pip, 0);
>>   			xname.type = XFS_DIR3_FT_DIR;
>> -			newdirent(mp, tp, pip, &xname, ip->i_ino,
>> -				  &first, &dfops);
>> +			newdirent(mp, tp, pip, &xname, ip,
>> +				  &first, &dfops, &offset);
>>   			inc_nlink(VFS_I(pip));
>>   			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
>>   		}
>> @@ -612,8 +616,23 @@ parseproto(
>>   		fail(_("Error encountered creating file from prototype file"),
>>   			error);
>>   	}
>> -	libxfs_trans_commit(tp);
>> +        libxfs_trans_commit(tp);
>> +
>> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
>> +		error = xfs_parent_add(tp, pip, ip, &xname, offset, &first, &dfops);
> Definitely can't keep using tp after committing the transaction.
>
>> +		if (error)
>> +			fail(_("Error creating parent pointer"), error);
>> +
>> +		libxfs_trans_log_inode(tp, ip, flags);
>> +		libxfs_defer_ijoin(&dfops, ip);
>> +		error = -libxfs_defer_finish(&tp, &dfops);
>> +		if (error)
>> +			fail(_("Directory creation failed"), error);
>> +		libxfs_trans_commit(tp);
> Also, if you add libxfs_trans_commit calls they probably ought to have
> return values checked in case some day libxfs_trans_commit starts
> returning error codes.
Alrighty, will fix
>> +	}
>> +
>>   	IRELE(ip);
>> +	
>>   }
>>   
>>   void
>> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
>> index 8b1b8a7..e5ff3b0 100644
>> --- a/repair/attr_repair.c
>> +++ b/repair/attr_repair.c
>> @@ -305,16 +305,6 @@ process_shortform_attr(
>>   			}
>>   		}
>>   
>> -		/* namecheck checks for / and null terminated for file names.
>> -		 * attributes names currently follow the same rules.
>> -		*/
>> -		if (namecheck((char *)&currententry->nameval[0],
> Why remove the namecheck calls?  It's only the ATTR_PARENT attributes
> where we want to skip the null-in-name checks, right?
Oh, I had forgotten about this.  I'll add something to make it exclude 
only pptrs
>
>> -						currententry->namelen))  {
>> -			do_warn(
>> -	_("entry contains illegal character in shortform attribute name\n"));
>> -			junkit = 1;
>> -		}
>> -
>>   		if (currententry->flags & XFS_ATTR_INCOMPLETE) {
>>   			do_warn(
>>   	_("entry has INCOMPLETE flag on in shortform attribute\n"));
>> @@ -470,8 +460,7 @@ process_leaf_attr_local(
>>   	xfs_attr_leaf_name_local_t *local;
>>   
>>   	local = xfs_attr3_leaf_name_local(leaf, i);
>> -	if (local->namelen == 0 || namecheck((char *)&local->nameval[0],
>> -							local->namelen)) {
>> +	if (local->namelen == 0) {
>>   		do_warn(
>>   	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
>>   			i, da_bno, ino, local->namelen);
>> @@ -525,8 +514,7 @@ process_leaf_attr_remote(
>>   
>>   	remotep = xfs_attr3_leaf_name_remote(leaf, i);
>>   
>> -	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0],
>> -						remotep->namelen) ||
>> +	if (remotep->namelen == 0 ||
>>   			be32_to_cpu(entry->hashval) !=
>>   				libxfs_da_hashname((unsigned char *)&remotep->name[0],
>>   						remotep->namelen) ||
>> diff --git a/repair/phase6.c b/repair/phase6.c
>> index 4fedb35..b861b3b 100644
>> --- a/repair/phase6.c
>> +++ b/repair/phase6.c
>> @@ -29,6 +29,7 @@
>>   #include "dinode.h"
>>   #include "progress.h"
>>   #include "versions.h"
>> +#include "xfs_parent.h"
>>   
>>   static struct cred		zerocr;
>>   static struct fsxattr 		zerofsx;
>> @@ -962,19 +963,20 @@ mk_root_dir(xfs_mount_t *mp)
>>   static xfs_ino_t
>>   mk_orphanage(xfs_mount_t *mp)
>>   {
>> -	xfs_ino_t	ino;
>> -	xfs_trans_t	*tp;
>> -	xfs_inode_t	*ip;
>> -	xfs_inode_t	*pip;
>> -	xfs_fsblock_t	first;
>> -	ino_tree_node_t	*irec;
>> -	int		ino_offset = 0;
>> -	int		i;
>> -	int		error;
>> +	xfs_ino_t		ino;
>> +	xfs_trans_t		*tp;
>> +	xfs_inode_t		*ip;
>> +	xfs_inode_t		*pip;
>> +	xfs_fsblock_t		first;
>> +	ino_tree_node_t		*irec;
>> +	int			ino_offset = 0;
>> +	int			i;
>> +	int			error;
>>   	struct xfs_defer_ops	dfops;
>> -	const int	mode = 0755;
>> -	int		nres;
>> -	struct xfs_name	xname;
>> +	const int		mode = 0755;
>> +	int			nres;
>> +	struct xfs_name		xname;
>> +	xfs_dir2_dataptr_t      offset;
>>   
>>   	/*
>>   	 * check for an existing lost+found first, if it exists, return
>> @@ -1061,7 +1063,7 @@ mk_orphanage(xfs_mount_t *mp)
>>   	 * create the actual entry
>>   	 */
>>   	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, &first,
>> -					&dfops, nres, NULL);
>> +					&dfops, nres, &offset);
>>   	if (error)
>>   		do_error(
>>   		_("can't make %s, createname error %d\n"),
>> @@ -1089,6 +1091,14 @@ mk_orphanage(xfs_mount_t *mp)
>>   			ORPHANAGE, error);
>>   	}
>>   
>> +        libxfs_trans_commit(tp);
>> +        if (xfs_sb_version_hasparent(&mp->m_sb)) {
>> +                error = xfs_parent_add(tp, pip, ip, &xname, offset,
> When you want to use libxfs functions from outside of libxfs (namely
> within mkfs/repair/whatever) the convention is to add a #define in
> libxfs_api_defs.h:
>
> #define libxfs_parent_add	xfs_parent_add
>
> And then in the utility program the usage should be:
>
> error = -libxfs_parent_add(...);
>
> Because libxfs functions return negative numbers for errors (kernel
> style) but the rest of the C world expects positive error codes.
>
> In theory xfs/437 should complain about this (though for all I know it
> could be busted).
>
> --D
I see, I will get libxfs_api_defs updated then.  Thx for the review!

Allison
>> +				       &first, &dfops);
>> +                if (error)
>> +                        do_error(_("Error creating parent pointer: %d\n"),
>> +				 error);
>> +        }
>>   
>>   	libxfs_trans_commit(tp);
>>   	IRELE(ip);
>> @@ -1120,6 +1130,7 @@ mv_orphanage(
>>   	ino_tree_node_t		*irec;
>>   	int			ino_offset = 0;
>>   	struct xfs_name		xname;
>> +	xfs_dir2_dataptr_t      offset;
>>   
>>   	xname.name = fname;
>>   	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
>> @@ -1170,7 +1181,7 @@ mv_orphanage(
>>   
>>   			libxfs_defer_init(&dfops, &first);
>>   			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
>> -						ino, &first, &dfops, nres, NULL);
>> +						ino, &first, &dfops, nres, &offset);
>>   			if (err)
>>   				do_error(
>>   	_("name create failed in %s (%d), filesystem may be out of space\n"),
>> @@ -1183,7 +1194,7 @@ mv_orphanage(
>>   			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
>>   
>>   			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
>> -					orphanage_ino, &first, &dfops, nres, NULL);
>> +					orphanage_ino, &first, &dfops, nres, &offset);
>>   			if (err)
>>   				do_error(
>>   	_("creation of .. entry failed (%d), filesystem may be out of space\n"),
>> @@ -1214,7 +1225,7 @@ mv_orphanage(
>>   			libxfs_defer_init(&dfops, &first);
>>   
>>   			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
>> -						ino, &first, &dfops, nres, NULL);
>> +						ino, &first, &dfops, nres, &offset);
>>   			if (err)
>>   				do_error(
>>   	_("name create failed in %s (%d), filesystem may be out of space\n"),
>> @@ -1233,7 +1244,7 @@ mv_orphanage(
>>   			if (entry_ino_num != orphanage_ino)  {
>>   				err = -libxfs_dir_replace(tp, ino_p,
>>   						&xfs_name_dotdot, orphanage_ino,
>> -						&first, &dfops, nres, NULL);
>> +						&first, &dfops, nres, &offset);
>>   				if (err)
>>   					do_error(
>>   	_("name replace op failed (%d), filesystem may be out of space\n"),
>> @@ -1270,7 +1281,7 @@ mv_orphanage(
>>   
>>   		libxfs_defer_init(&dfops, &first);
>>   		err = -libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
>> -						&first, &dfops, nres, NULL);
>> +						&first, &dfops, nres, &offset);
>>   		if (err)
>>   			do_error(
>>   	_("name create failed in %s (%d), filesystem may be out of space\n"),
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

