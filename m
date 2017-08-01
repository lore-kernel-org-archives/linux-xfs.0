Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34606 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdHASWj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 14:22:39 -0400
Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()
References: <d161b07cad6536b0baf285328cf99500@mail.gmail.com>
 <A3EABCF079964F4FA6058F30EBF80FD8@alyakaslap>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b1f0c224-11b6-ba24-23e4-187f13d5cf17@sandeen.net>
Date: Tue, 1 Aug 2017 13:22:37 -0500
MIME-Version: 1.0
In-Reply-To: <A3EABCF079964F4FA6058F30EBF80FD8@alyakaslap>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>, linux-xfs@vger.kernel.org
Cc: Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, dchinner@redhat.com, david@fromorbit.com



On 8/1/17 12:30 PM, Alex Lyakas wrote:
> Greetings XFS developers, David, Brian,
> 
> We did additional debugging on this issue. The problematic flow happens to be the following:
> 
> - New inode (regular file) is being created.
> - As part of creation, due to parent directory having a default ACL, initial ACL is applied to the inode.
> - This ACL is applied as an extended attribute with name "SGI_ACL_FILE" and value length of 100 bytes.
> - XFS tries to add this attribute into the inline inode attribute fork area (AKA shortform).
> - But 100 bytes is too large for the shortform, so XFS creates an empty shortform and then calls xfs_attr_shortform_to_leaf()
> - This calls xfs_attr3_leaf_create() and creates a leaf with zero attributes.
> - Before XFS is able to add the attribute to the leaf, the xfsaild thread wants to write this leaf to disk, and trips over the assert in xfs_attr3_leaf_verify, that ichdr.count should not be 0
> 
> So this seems like a race condition, where xfsaild writes a not-fully-prepared xfs_buf to disk. To my understanding this can lead to different kinds of corruptions.

Interesting, this seems possibly related to this commit, which
addresses a similar issue only during log replay:

commit 2e1d23370e75d7d89350d41b4ab58c7f6a0e26b2
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Dec 9 16:49:47 2016 +1100

    xfs: ignore leaf attr ichdr.count in verifier during log replay
    
    When we create a new attribute, we first create a shortform
    attribute, and try to fit the new attribute into it.
    If that fails, we copy the (empty) attribute into a leaf attribute,
    and do the copy again.  Thus there can be a transient state where
    we have an empty leaf attribute.
    
    If we encounter this during log replay, the verifier will fail.
    So add a test to ignore this part of the leaf attr verification
    during log replay.
    
    Thanks as usual to dchinner for spotting the problem.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>


-Eric
