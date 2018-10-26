Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49924 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbeJ0DuC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Oct 2018 23:50:02 -0400
Subject: Re: [PATCH] libxfs: check all defer ops types
From: Eric Sandeen <sandeen@sandeen.net>
References: <20181026161905.GH28243@magnolia>
 <0dc53e1c-2ad6-b04f-2747-451b6760e1d5@sandeen.net>
Message-ID: <d13db2aa-3e73-7dd6-8677-7e19f9b7ffcd@sandeen.net>
Date: Fri, 26 Oct 2018 14:11:47 -0500
MIME-Version: 1.0
In-Reply-To: <0dc53e1c-2ad6-b04f-2747-451b6760e1d5@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>



On 10/26/18 2:02 PM, Eric Sandeen wrote:
> On 10/26/18 11:19 AM, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Make sure we have all the defer ops types loaded before proceeding.
> 
> So, the only reason we have this problem is that userspace doesn't
> exactly share the code which handles all the defer ops.
> 
> I think this really needs to be a BUILD_BUG_ON if anything, by the
> time we get to runtime it's really too late, and a weird thing to
> run at every invocation.
> 
> The only thing I can think of is to make an array containing each
> of the xfs_defer_op_types, and iterate over it in some sort of
> xfs_defer_ops_init(), then we can compare the size of that array to
> XFS_DEFER_OPS_TYPE_MAX with a BUILD_BUG_ON.  Worth it?

Uh, or just make a statically initialized array?
I guess nothing about this directly enforces that the ->type number
is in the right slot of the array.

static const struct
xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX] = {
       xfs_bmap_update_defer_type,
       xfs_refcount_update_defer_type,
       xfs_rmap_update_defer_type,
       xfs_extent_free_defer_type,
       xfs_agfl_free_defer_type,
};
