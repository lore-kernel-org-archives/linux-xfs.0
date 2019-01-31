Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51666 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbfAaNvx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 08:51:53 -0500
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to 193bc42
References: <d5164ad2-1aed-0875-5032-64cea5be9afc@sandeen.net>
 <20190131062845.GA5761@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4e2e62cf-7a53-c11d-bfdb-86be6cb95992@sandeen.net>
Date: Thu, 31 Jan 2019 07:51:51 -0600
MIME-Version: 1.0
In-Reply-To: <20190131062845.GA5761@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 1/31/19 12:28 AM, Darrick J. Wong wrote:
> On Tue, Jan 29, 2019 at 11:05:32AM -0600, Eric Sandeen wrote:
>> Hi folks,
>>
>> The xfsprogs repository at:
>>
>> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>>
>> has just been updated.
>>
>> Patches often get missed, so please check if your outstanding
>> patches were in this update. If they have not been in this update,
>> please resubmit them to linux-xfs@vger.kernel.org so they can be
>> picked up in the next update.
>>
>> This is close to what xfsprogs-4.20 will (finally) be.  I'll review
>> Carlos' metadump patch for possible inclusion, and if anyone has other
>> outstanding patches that are better for 4.20 than 5.0, please let me know
>> either via a re-submit, or just point me at the patch subjects.
> 
> urk.....

sigh ....

I'll send a patch to fix it.

> + * Returns 1 if the name contains a NUL or if a directory entry contains a '/'.
> + * Returns 0 if the name checks out.
>   */
>  int
> -namecheck(char *name, int length)
> +namecheck(
> +	char	*name,
> +	int	length,
> +	bool	isadir)
>  {
> -	char *c;
> -	int i;
> +	char	*c;
> +	int	i;
>  
>  	ASSERT(length < MAXNAMELEN);
>  
>  	for (c = name, i = 0; i < length; i++, c++) {
> -		if (*c == '/' || *c == '\0')
> +		if (isadir && *c == '/')
> +			return 0;
> 
> I think that's supposed to be 'return 1', given the comment?
> 
> --D
> 
> 
>> Thanks,
>> -Eric
>>
>> The new head of the for-next branch is commit:
>>
>> 193bc42 xfsprogs: Remove barrier/nobarrier mount options from xfs.5
>>
>> New Commits:
>>
>> Achilles Gaikwad (1):
>>       [b136f48] xfs_quota: fix false error reporting of project inheritance flag is not set
>>
>> Brian Foster (1):
>>       [051dae5] xfs_repair: initialize non-leaf finobt blocks with correct magic
>>
>> Darrick J. Wong (2):
>>       [0ba6dae] xfs_repair: fix off by one error when rebuilding high keys
>>       [38c599e] xfs_db: fix finobt record decoding when sparse inodes enabled
>>
>> Eric Sandeen (4):
>>       [45571fd] xfs_repair: allow '/' in attribute names
>>       [17728a4] xfsprogs: remove generated scrub files under clean target
>>       [e3f66d1] xfs_db: add -d to short help for write command
>>       [193bc42] xfsprogs: Remove barrier/nobarrier mount options from xfs.5
>>
>> Stefan Ring (5):
>>       [11f3d9f] xfs_metadump: Extend data zapping to XFS_DIR{2,3}_LEAFN_MAGIC blocks
>>       [b04e7e9] xfs_metadump: Zap multi fsb blocks
>>       [c3387ef] xfs_metadump: Zap freeindex blocks in directory inodes
>>       [07b75e3] xfs_metadump: Zap unused space in inode btrees
>>       [b32d0eb] xfs_metadump: Zap dev inodes
>>
>>
>> Code Diffstat:
>>
>>  db/metadump.c        | 132 +++++++++++++++++++++++++++++++++++++++++++++------
>>  db/type.c            |   2 +-
>>  db/write.c           |   2 +-
>>  man/man5/xfs.5       |  30 ++++++------
>>  man/man8/xfs_db.8    |   2 +-
>>  quota/project.c      |   2 +-
>>  repair/attr_repair.c |  20 +++++---
>>  repair/da_util.c     |  20 +++++---
>>  repair/da_util.h     |   3 +-
>>  repair/dir2.c        |  12 ++++-
>>  repair/phase5.c      |  12 ++---
>>  scrub/Makefile       |   2 +
>>  12 files changed, 183 insertions(+), 56 deletions(-)
>>
> 
> 
> 
