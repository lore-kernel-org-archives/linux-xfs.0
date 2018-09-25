Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46122 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbeIYI4M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Sep 2018 04:56:12 -0400
Subject: Re: [PATCH 1/2] xfs: validate inode di_forkoff
References: <0c8c405b-8929-82a6-5c9a-f5965da2c464@redhat.com>
 <da670f4a-6ae7-fbe7-94db-b6a4e6bb0c9e@redhat.com>
 <20180924170447.GA60179@bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <96f44d37-648d-536b-d3ea-af5ddaacab05@sandeen.net>
Date: Mon, 24 Sep 2018 21:50:52 -0500
MIME-Version: 1.0
In-Reply-To: <20180924170447.GA60179@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 9/24/18 12:04 PM, Brian Foster wrote:
> On Mon, Sep 10, 2018 at 05:22:08PM -0500, Eric Sandeen wrote:
>> Verify the inode di_forkoff, lifted from xfs_repair's
>> process_check_inode_forkoff().
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index 30d1d60f1d46..8d76637a49a7 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -415,6 +415,31 @@ xfs_dinode_verify_fork(
>>  	return NULL;
>>  }
>>  
>> +static xfs_failaddr_t
>> +xfs_dinode_verify_forkoff(
>> +	struct xfs_dinode	*dip,
>> +	struct xfs_mount	*mp)
>> +{
>> +	if (dip->di_forkoff == 0)
>> +		return NULL;
> 
> I think it would be good to use XFS_DFORK_Q() here, just to be
> consistent with the other, similar checks. Otherwise looks good:

Ok; personally I hate that macro ;) but you're right, consistency
first.

-Eric
