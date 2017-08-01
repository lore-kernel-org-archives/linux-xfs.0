Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:37063 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbdHAS5n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 14:57:43 -0400
Received: by mail-wr0-f179.google.com with SMTP id 33so10352164wrz.4
        for <linux-xfs@vger.kernel.org>; Tue, 01 Aug 2017 11:57:42 -0700 (PDT)
Message-ID: <8EDAE4D35FF54E00BE6005F72FD7193F@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <d161b07cad6536b0baf285328cf99500@mail.gmail.com> <A3EABCF079964F4FA6058F30EBF80FD8@alyakaslap> <b1f0c224-11b6-ba24-23e4-187f13d5cf17@sandeen.net>
In-Reply-To: <b1f0c224-11b6-ba24-23e4-187f13d5cf17@sandeen.net>
Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()
Date: Tue, 1 Aug 2017 21:57:36 +0300
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="UTF-8";
        reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>
Cc: Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, dchinner@redhat.com, david@fromorbit.com

Hi Eric,

Thanks for your response.

I confirm that during log replay we also see this issue from time to time. 
However, our main problem is that during normal operation we trip on this 
assert, and this causes XFS to shutdown, causing outage. Please see the 
stack trace that I posted in the previous email; it does not happen during 
log replay. But [2] shows an example of this happening during log replay.

Thanks,
Alex.

[2]
Aug  1 10:45:10.787639 vsa-0000000a-vc-0 kernel: [177569.829977] XFS 
(dm-79): Mounting V4 Filesystem
Aug  1 10:45:11.268635 vsa-0000000a-vc-0 kernel: [177570.310819] XFS 
(dm-79): Starting recovery (logdev: internal)
Aug  1 10:45:15.529417 vsa-0000000a-vc-0 kernel: [177574.570695] 
[10050][at]xfs*[xfs_attr3_leaf_verify:202] XFS(dm-79): ichdr.count==0 
bp[0xcc4cfff50]
Aug  1 10:45:15.529424 vsa-0000000a-vc-0 kernel: [177574.570723] XFS 
(dm-79): Metadata corruption detected at 
xfs_attr3_leaf_read_verify+0x4f/0xf0 [xfs], block 0xcc4cfff50
Aug  1 10:45:15.529426 vsa-0000000a-vc-0 kernel: [177574.571788] XFS 
(dm-79): Unmount and run xfs_repair
Aug  1 10:45:15.531314 vsa-0000000a-vc-0 kernel: [177574.572271] XFS 
(dm-79): First 64 bytes of corrupted metadata buffer:
Aug  1 10:45:15.531316 vsa-0000000a-vc-0 kernel: [177574.572887] 
ffff88014f0a8000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00 
................
Aug  1 10:45:15.531317 vsa-0000000a-vc-0 kernel: [177574.573698] 
ffff88014f0a8010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... 
..........
Aug  1 10:45:15.532953 vsa-0000000a-vc-0 kernel: [177574.574514] 
ffff88014f0a8020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
Aug  1 10:45:15.532956 vsa-0000000a-vc-0 kernel: [177574.575332] 
ffff88014f0a8030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
Aug  1 10:45:15.534630 vsa-0000000a-vc-0 kernel: [177574.576161] XFS 
(dm-79): metadata I/O error: block 0xcc4cfff50 ("xfs_trans_read_buf_map") 
error 117 numblks 8
Aug  1 10:45:15.556831 vsa-0000000a-vc-0 kernel: [177574.598119] 
[10050][at]xfs*[xfs_attr3_leaf_verify:202] XFS(dm-79): ichdr.count==0 
bp[0xd7c4c4ab0]
Aug  1 10:45:15.556837 vsa-0000000a-vc-0 kernel: [177574.598134] XFS 
(dm-79): Metadata corruption detected at 
xfs_attr3_leaf_read_verify+0x4f/0xf0 [xfs], block 0xd7c4c4ab0
Aug  1 10:45:15.556838 vsa-0000000a-vc-0 kernel: [177574.599210] XFS 
(dm-79): Unmount and run xfs_repair
Aug  1 10:45:15.557937 vsa-0000000a-vc-0 kernel: [177574.599686] XFS 
(dm-79): First 64 bytes of corrupted metadata buffer:
Aug  1 10:45:15.557939 vsa-0000000a-vc-0 kernel: [177574.600319] 
ffff880150b63000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00 
................
Aug  1 10:45:15.559643 vsa-0000000a-vc-0 kernel: [177574.601180] 
ffff880150b63010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... 
..........
Aug  1 10:45:15.559646 vsa-0000000a-vc-0 kernel: [177574.602023] 
ffff880150b63020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
Aug  1 10:45:15.561367 vsa-0000000a-vc-0 kernel: [177574.602887] 
ffff880150b63030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
Aug  1 10:45:15.562632 vsa-0000000a-vc-0 kernel: [177574.603787] XFS 
(dm-79): metadata I/O error: block 0xd7c4c4ab0 ("xfs_trans_read_buf_map") 
error 117 numblks 8
Aug  1 10:45:15.562636 vsa-0000000a-vc-0 kernel: [177574.604767] XFS 
(dm-79): Ending recovery (logdev: internal)

-----Original Message----- 
From: Eric Sandeen
Sent: Tuesday, August 01, 2017 9:22 PM
To: Alex Lyakas ; linux-xfs@vger.kernel.org
Cc: Shyam Kaushik ; bfoster@redhat.com ; dchinner@redhat.com ; 
david@fromorbit.com
Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()



On 8/1/17 12:30 PM, Alex Lyakas wrote:
> Greetings XFS developers, David, Brian,
>
> We did additional debugging on this issue. The problematic flow happens to 
> be the following:
>
> - New inode (regular file) is being created.
> - As part of creation, due to parent directory having a default ACL, 
> initial ACL is applied to the inode.
> - This ACL is applied as an extended attribute with name "SGI_ACL_FILE" 
> and value length of 100 bytes.
> - XFS tries to add this attribute into the inline inode attribute fork 
> area (AKA shortform).
> - But 100 bytes is too large for the shortform, so XFS creates an empty 
> shortform and then calls xfs_attr_shortform_to_leaf()
> - This calls xfs_attr3_leaf_create() and creates a leaf with zero 
> attributes.
> - Before XFS is able to add the attribute to the leaf, the xfsaild thread 
> wants to write this leaf to disk, and trips over the assert in 
> xfs_attr3_leaf_verify, that ichdr.count should not be 0
>
> So this seems like a race condition, where xfsaild writes a 
> not-fully-prepared xfs_buf to disk. To my understanding this can lead to 
> different kinds of corruptions.

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

