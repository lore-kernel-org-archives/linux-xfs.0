Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29218 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750853AbdHAXSm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 19:18:42 -0400
Date: Wed, 2 Aug 2017 09:18:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()
Message-ID: <20170801231839.GQ17762@dastard>
References: <d161b07cad6536b0baf285328cf99500@mail.gmail.com>
 <A3EABCF079964F4FA6058F30EBF80FD8@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A3EABCF079964F4FA6058F30EBF80FD8@alyakaslap>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: linux-xfs@vger.kernel.org, Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, dchinner@redhat.com

On Tue, Aug 01, 2017 at 08:30:31PM +0300, Alex Lyakas wrote:
> Greetings XFS developers, David, Brian,
> 
> We did additional debugging on this issue. The problematic flow
> happens to be the following:
> 
> - New inode (regular file) is being created.
> - As part of creation, due to parent directory having a default ACL,
> initial ACL is applied to the inode.
> - This ACL is applied as an extended attribute with name
> "SGI_ACL_FILE" and value length of 100 bytes.
> - XFS tries to add this attribute into the inline inode attribute
> fork area (AKA shortform).
> - But 100 bytes is too large for the shortform, so XFS creates an
> empty shortform and then calls xfs_attr_shortform_to_leaf()
> - This calls xfs_attr3_leaf_create() and creates a leaf with zero
> attributes.
> - Before XFS is able to add the attribute to the leaf, the xfsaild
> thread wants to write this leaf to disk, and trips over the assert
> in xfs_attr3_leaf_verify, that ichdr.count should not be 0

Ok, this makes it pretty obvious as to what's going on here. The new
attribute leaf buffer is not held locked across the transaction roll
between the shortform->leaf modification and the addition of the new
entry. As a result the attribute buffer modification being made is
not atomic from an operational perspective. Hence the AIL push can
grab it in the transient state of "just created" after the initial
transaction is rolled because the buffer has been released.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
