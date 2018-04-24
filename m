Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40758 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750826AbeDXQBG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Apr 2018 12:01:06 -0400
Subject: Re: [PATCH 07/13] xfs: refactor incore dquot initialization functions
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440959784.29601.7345409188558922914.stgit@magnolia>
 <20180423172755.GG834@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7b75039e-92a4-7d63-3881-2fb5d29c31ee@sandeen.net>
Date: Tue, 24 Apr 2018 10:01:03 -0600
MIME-Version: 1.0
In-Reply-To: <20180423172755.GG834@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 4/23/18 11:27 AM, Christoph Hellwig wrote:
> On Sun, Apr 22, 2018 at 08:06:37AM -0700, Darrick J. Wong wrote:
>> -/*
>> - * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
>> - * and release the buffer immediately.
>> - *
>> - * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
>> - */
>> -int
>> -xfs_qm_dqread(
>> +/* Allocate and initialize everything we need for an incore dquot. */
>> +STATIC struct xfs_dquot *
>> +xfs_qm_dqinit_once(
>>  	struct xfs_mount	*mp,
>>  	xfs_dqid_t		id,
>> -	uint			type,
>> -	uint			flags,
>> -	struct xfs_dquot	**O_dqpp)
>> +	uint			type)
>>  {
>>  	struct xfs_dquot	*dqp;
>> -	struct xfs_disk_dquot	*ddqp;
>> -	struct xfs_buf		*bp;
>> -	struct xfs_trans	*tp = NULL;
>> -	int			error;
>>  
>>  	dqp = kmem_zone_zalloc(xfs_qm_dqzone, KM_SLEEP);
> 
> Shouldn't this be called something like xfs_dquot_alloc given that
> it allocates the xfs_dquot structure?

Preaching to the choir here but I agree, "init_once" has a pretty specific
meaning in slab allocation paths, and this isn't it. ;)

-Eric
