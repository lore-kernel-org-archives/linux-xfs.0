Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43415 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbdHOEFI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 00:05:08 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7F456kT032705
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 04:05:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7F456SA027747
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 04:05:06 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7F456ji025071
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 04:05:06 GMT
Subject: Re: [RFC PATCH 05/13] xfs: define parent pointer xattr format
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
 <1502329293-4091-6-git-send-email-allison.henderson@oracle.com>
 <20170814235942.GR4796@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ea16099b-4a2f-d3a5-1e10-76d35464ac7c@oracle.com>
Date: Mon, 14 Aug 2017 21:05:05 -0700
MIME-Version: 1.0
In-Reply-To: <20170814235942.GR4796@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 08/14/2017 04:59 PM, Darrick J. Wong wrote:

> On Wed, Aug 09, 2017 at 06:41:25PM -0700, Allison Henderson wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> We need to define the parent pointer attribute format before we
>> start adding support for it into all the code that needs to use it.
>> The EA format we will use encodes the following information:
>>
>> 	name={parent inode #, parent inode generation, dirent offset}
>> 	value={dirent filename}
>>
>> The inode/gen gives all the information we need to reliably identify
>> the parent without requiring child->parent lock ordering, and allows
>> userspace to do pathname component level reconstruction without the
>> kernel ever needing to verify the parent itself as part of ioctl
>> calls.
>>
>> By using the dirent offset in the EA name, we have a method of
>> knowing the exact parent pointer EA we need to modify/remove in
>> rename/unlink without an unbound EA name search.
>>
>> By keeping the dirent name in the value, we have enough information
>> to be able to validate and reconstruct damaged directory trees.
>> While the diroffset of a filename alone is not unique enough to
>> identify the child, the {diroffset,filename,child_inode} tuple is
>> sufficient. That is, if the diroffset gets reused and points to a
>> different filename, we can detect that from the contents of EA. If a
>> link of the same name is created, then we can check whether it
>> points at the same inode as the parent EA we current have.
>>
>> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t]
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>> :100644 100644 d4d9bef... 91e2d5a... M	fs/xfs/libxfs/xfs_format.h
>>   fs/xfs/libxfs/xfs_format.h | 27 +++++++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index d4d9bef..91e2d5a 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -18,6 +18,8 @@
>>   #ifndef __XFS_FORMAT_H__
>>   #define __XFS_FORMAT_H__
>>   
>> +#include "xfs_da_format.h"
>> +
>>   /*
>>    * XFS On Disk Format Definitions
>>    *
>> @@ -1721,4 +1723,29 @@ struct xfs_acl {
>>   #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
>>   #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
>>   
>> +/*
>> + * Parent pointer attribute format definition
>> + *
>> + * EA name encodes the parent inode number, generation and the offset of
>> + * the dirent that points to the child inode. The EA value contains the
>> + * same name as the dirent in the parent directory.
>> + */
>> +struct xfs_parent_name_rec {
>> +	__be64	p_ino;
>> +	__be32	p_gen;
>> +	__be32	p_diroffset;
>> +};
>> +
>> +/*
>> + * incore version of the above, also contains name pointers so callers
>> + * can pass/obtain all the parent pointer information in a single structure
>> + */
>> +struct xfs_parent_name_irec {
>> +	uint64_t		p_ino;
> Should use incore xfs types, i.e. xfs_ino_t.
Ok, will fix
>> +	uint32_t		p_gen;
>> +	xfs_dir2_dataptr_t	p_diroffset;
>> +	const char		*p_name;
>> +	uint32_t		p_namelen;
> Pathname components are at most 255 bytes long, though I guess that
> doesn't save us any space here.
Ok, I'll update it to use a uint8_t, parameters get shifted around all 
the time.

Allison
> --D
>
>> +};
>> +
>>   #endif /* __XFS_FORMAT_H__ */
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

