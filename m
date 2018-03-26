Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60527 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbeCZNhE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Mar 2018 09:37:04 -0400
Subject: Re: [PATCH V2] xfs: do not log swapext extent owner changes for
 deleted inodes
References: <f2dcef25-01f2-d7fe-3b2d-f54a809215a5@redhat.com>
 <b7a4250a-b348-0381-683b-74059c397a7d@sandeen.net>
 <20180326121339.GB34912@bfoster.bfoster>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <45ea874c-3b9c-9b0e-e773-bf01e46c8182@redhat.com>
Date: Mon, 26 Mar 2018 08:37:02 -0500
MIME-Version: 1.0
In-Reply-To: <20180326121339.GB34912@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 3/26/18 7:13 AM, Brian Foster wrote:
> On Fri, Mar 23, 2018 at 07:13:43PM -0500, Eric Sandeen wrote:
>> Today if we run fsr and crash, log replay can fail because
>> the recovery code tries to instantiate the donor inode from
>> disk to replay the swapext, but it's been deleted and we get
>> verifier failures when we try to read it off disk with
>> i_mode == 0.
>>
>> Strip the extent owner changes out of the logged fields when
>> we're freeing the inode to avoid this.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> V2: Move the fix to xfs_ifree per bfoster's suggestion
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 604ee38..d17e2d5 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -2470,6 +2470,10 @@
>>  	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
>>  	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
>>  	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
>> +
>> +	/* Don't attempt to replay owner changes for a deleted inode */
>> +	ip->i_itemp->ili_fields &= !(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);
> 
> 				   ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER)
> 
> Brian

Oh man.  :(  Total brain burp, thanks for catching that.
Some days I think my hair is getting too pointy to keep doing this work.  :(

-Eric
