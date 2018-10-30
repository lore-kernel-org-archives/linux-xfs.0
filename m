Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60192 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbeJaFfW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 01:35:22 -0400
Subject: Re: [PATCH 2/7] repair: don't dirty inodes which are not unlinked
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-3-david@fromorbit.com>
 <539a02d8-f9fd-e9b4-d928-dcdced642376@sandeen.net>
 <a2aa0727-21db-fd2a-6207-0b70d05a7374@sandeen.net>
 <20181030203428.GN19305@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ef573c7c-0522-0564-c552-e5ef684b5444@sandeen.net>
Date: Tue, 30 Oct 2018 15:40:20 -0500
MIME-Version: 1.0
In-Reply-To: <20181030203428.GN19305@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 10/30/18 3:34 PM, Dave Chinner wrote:
> On Tue, Oct 30, 2018 at 03:09:56PM -0500, Eric Sandeen wrote:
>> So I'm not stealing commits: ;)
>>
>> ===
>>
>> repair: don't dirty inodes unconditionally when testing unlinked state
>>
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> I noticed phase 4 writing back lots of inode buffers during recent
>> testing. The recent rework of clear_inode() in commit 0724d0f4cb53
>> ("xfs_repair: clear_dinode should simply clear, not check contents")
>> accidentally caught a call to clear_inode_unlinked() as well,
>> resulting in all inodes being marked dirty whether then needed
>> updating or not.
>>
>> Fix it by making clear_inode_unlinked unconditionally do the clear
>> (as was done for clear_inode), and move the test to the caller.
>> Add warnings as well so that this corruption is no longer silently
>> fixed.
>>
>> Reported-by: Dave Chinner <dchinner@redhat.com>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>> [sandeen: rework so clear_inode_unlinked is unconditional]
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> diff --git a/repair/dinode.c b/repair/dinode.c
>> index 379f85c..f466e77 100644
>> --- a/repair/dinode.c
>> +++ b/repair/dinode.c
>> @@ -125,23 +125,16 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
>>  	return;
>>  }
>>  
>> -static int
>> +static void
>>  clear_dinode_unlinked(xfs_mount_t *mp, xfs_dinode_t *dino)
>>  {
>>  
>> -	if (be32_to_cpu(dino->di_next_unlinked) != NULLAGINO)  {
>> -		if (!no_modify)
>> -			dino->di_next_unlinked = cpu_to_be32(NULLAGINO);
>> -		return(1);
>> -	}
>> -
>> -	return(0);
>> +	dino->di_next_unlinked = cpu_to_be32(NULLAGINO);
>>  }
> 
> What's the point of keeping this wrapper now?

Not much other than making clear_dinode() sightly prettier.

Happy to nuke it if preferred.

-Eric
