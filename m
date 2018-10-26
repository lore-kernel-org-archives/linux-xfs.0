Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51346 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbeJ0EEj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 27 Oct 2018 00:04:39 -0400
Subject: Re: [PATCH] libxfs: check all defer ops types
References: <20181026161905.GH28243@magnolia>
 <0dc53e1c-2ad6-b04f-2747-451b6760e1d5@sandeen.net>
 <d13db2aa-3e73-7dd6-8677-7e19f9b7ffcd@sandeen.net>
 <20181026192458.GA8643@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e478230e-95fc-984f-c8bb-5a393b10fa56@sandeen.net>
Date: Fri, 26 Oct 2018 14:26:22 -0500
MIME-Version: 1.0
In-Reply-To: <20181026192458.GA8643@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>



On 10/26/18 2:24 PM, Christoph Hellwig wrote:
> On Fri, Oct 26, 2018 at 02:11:47PM -0500, Eric Sandeen wrote:
>> static const struct
>> xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX] = {
>>        xfs_bmap_update_defer_type,
>>        xfs_refcount_update_defer_type,
>>        xfs_rmap_update_defer_type,
>>        xfs_extent_free_defer_type,
>>        xfs_agfl_free_defer_type,
>> };
> 
> I think this should be:
> 
> static const struct xfs_defer_op_type *defer_op_types[] = {
> 	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
> 	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
> 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
> 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
> 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
> };
> 
> somefunc()
> {
> 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
> }
> 

Uh, yeah, that's what I was trying but pitifully failing to come
up with, thanks.  :)

-Eric
