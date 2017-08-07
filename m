Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:34199 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdHGObe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2017 10:31:34 -0400
Received: by mail-wr0-f175.google.com with SMTP id 12so2548647wrb.1
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2017 07:31:33 -0700 (PDT)
Message-ID: <3391D6AD89BD4CA8A30EDBEADFD77C7E@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <d161b07cad6536b0baf285328cf99500@mail.gmail.com> <A3EABCF079964F4FA6058F30EBF80FD8@alyakaslap> <20170801231839.GQ17762@dastard> <7AF4FEF16E034B868577B3ED535D5C41@alyakaslap> <20170802115030.GS17762@dastard>
In-Reply-To: <20170802115030.GS17762@dastard>
Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()
Date: Mon, 7 Aug 2017 17:31:29 +0300
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="iso-8859-1";
        reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, dchinner@redhat.com

Hello Dave, Brian,

I have posted an RFC patch, which seems to fix the issue in:
https://www.spinics.net/lists/linux-xfs/msg08895.html

Can you please review it?

I am now working on posting a patch based on 4.13-rc4, which hopefully will 
make it easier to be accepted.

Thanks,
Alex.


-----Original Message----- 
From: Dave Chinner
Sent: Wednesday, August 02, 2017 2:50 PM
To: Alex Lyakas
Cc: linux-xfs@vger.kernel.org ; Shyam Kaushik ; bfoster@redhat.com ; 
dchinner@redhat.com
Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()

On Wed, Aug 02, 2017 at 11:38:36AM +0300, Alex Lyakas wrote:
> Hello Dave,
>
> Thank you for your analysis. It sounds like this issue exists in
> recent kernels as well.

It's effectively a zero day bug. The two-transaction conversion to
leaf form is recognisable in this commit from Jun 1995:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=d4e0d38051ce61f9d8f330f59e0a99ed710d5f9e

This was about a month after attr support first shows up in the XFS
commit history, so it's been there forever....

> We are reviewing some of the paths that operate xfs_buf's, but still
> we don't have enough understanding on how to properly lock out the
> xfs_buf from AIL grabbing it. Can you please point us at similar
> flows, where such locking is done?

It's simple - if the buffer is locked, the AIL can't grab it. The
buffer needs to be held locked across transaction commit
and then rejoined to the new transaction after it is rolled. THis is
acheived by using xfs_trans_bhold() in the initial transaction
context, and after commit it is rejoined to the new transaction
context.

See the inode chunk allocation code in xfs_dir_ialloc() for an
example of how this works.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

