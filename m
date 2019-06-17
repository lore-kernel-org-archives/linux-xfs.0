Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51058 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbfFQSX4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jun 2019 14:23:56 -0400
Subject: Re: [PATCH] xfs_info: limit findmnt to find mounted xfs filesystems
References: <20190617095447.3748-1-amir73il@gmail.com>
 <20190617182226.GM3773859@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2d751504-7ab7-fd59-d53d-6ba1f69df932@sandeen.net>
Date: Mon, 17 Jun 2019 13:23:54 -0500
MIME-Version: 1.0
In-Reply-To: <20190617182226.GM3773859@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org



On 6/17/19 1:22 PM, Darrick J. Wong wrote:
> On Mon, Jun 17, 2019 at 12:54:47PM +0300, Amir Goldstein wrote:
>> When running xfstests with -overlay, the xfs mount point
>> (a.k.a $OVL_BASE_SCRATCH_MNT) is used as the $SCRATCH_DEV argument
>> to the overlay mount, like this:
>>
>> /dev/vdf /vdf xfs rw,relatime,attr2,inode64,noquota 0 0
>> /vdf /vdf/ovl-mnt overlay rw,lowerdir=/vdf/lower,upperdir=/vdf/upper...
>>
>> Ever since commit bbb43745, when xfs_info started using findmnt,
>> when calling the helper `_supports_filetype /vdf` it returns false,
>> and reports: "/vdf/ovl-mnt: Not on a mounted XFS filesystem".
>>
>> Fix this ambiguity by preferring to query a mounted XFS filesystem,
>> if one can be found.
>>
>> Fixes: bbb43745 ("xfs_info: use findmnt to handle mounted block devices")
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> 
> Looks good to me, so long as findmnt /has/ a -t option in, uh, whatever
> enterprise distro(s) for which the xfsprogs maintainer might be a
> stakeholder. :)

:D

-t goes way back so this should be no problem.

Thanks, Amir.

-Eric

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
>> ---
>>
>> Eric,
>>
>> FYI, I don't *need* to fix xfs_info in order to fix xfstests
>> and I do plan to send an independent fix to xfstests, but this
>> seems like a correct fix regardless of the specific xfstests
>> regression.
>>
>> Thanks,
>> Amir.
>>
>>  spaceman/xfs_info.sh | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/spaceman/xfs_info.sh b/spaceman/xfs_info.sh
>> index 1bf6d2c3..3b10dc14 100755
>> --- a/spaceman/xfs_info.sh
>> +++ b/spaceman/xfs_info.sh
>> @@ -40,7 +40,7 @@ case $# in
>>  
>>  		# If we find a mountpoint for the device, do a live query;
>>  		# otherwise try reading the fs with xfs_db.
>> -		if mountpt="$(findmnt -f -n -o TARGET "${arg}" 2> /dev/null)"; then
>> +		if mountpt="$(findmnt -t xfs -f -n -o TARGET "${arg}" 2> /dev/null)"; then
>>  			xfs_spaceman -p xfs_info -c "info" $OPTS "${mountpt}"
>>  			status=$?
>>  		else
>> -- 
>> 2.17.1
>>
> 
