Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 99BDF7CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 04:43:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 531C5304051
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 02:43:01 -0700 (PDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com
	[74.125.82.46]) by cuda.sgi.com with ESMTP id LeSuDGH7OdWPnDxh
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Jul 2016 02:42:58 -0700 (PDT)
Received: by mail-wm0-f46.google.com with SMTP id i5so59893007wmg.0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 02:42:58 -0700 (PDT)
Message-ID: <08BA7450B9BF4B64A74B8DF97986CD35@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <143E2E5E912B4C348E8C62AA987F0506@alyakaslap>
	<20160719231108.GH16044@dastard>
In-Reply-To: <20160719231108.GH16044@dastard>
Subject: Re: xfs_vm_releasepage() causing BUG at free_buffer_head()
Date: Wed, 20 Jul 2016 12:42:54 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hello Dave,

Grepping through my kernel source code, I see the following:
- direct users of b_assoc_buffers are nilfs2, reiserfs and jbd2. In my case, 
jbd2 is used by ext4. Looking at jbd2 usage, however, it looks like it 
handles this list correctly.
- the only other place where somebody can use the "b_assoc_buffers" link is 
by calling mark_buffer_dirty_inode(), which puts the bufferhead on 
"mapping->private_list" using the "b_assoc_buffers" link. There are several 
users of this API, but for my case the only relevant being again jbd2.

Therefore, I will ask on the ext4 community.

Thanks,
Alex.

-----Original Message----- 
From: Dave Chinner
Sent: Wednesday, July 20, 2016 2:11 AM
To: Alex Lyakas
Cc: xfs@oss.sgi.com
Subject: Re: xfs_vm_releasepage() causing BUG at free_buffer_head()

On Mon, Jul 18, 2016 at 09:00:41PM +0300, Alex Lyakas wrote:
> Greetings XFS community,
>
> We have hit the following BUG [1].
>
> This is in free_buffer_head():
> BUG_ON(!list_empty(&bh->b_assoc_buffers));

XFS doesn't use the bh->b_assoc_buffers field at all, so nothing in
XFS should ever corrupt it. Do you have any extN filesystems active,
or any other filesystems/block devices that use bufferheads than
might have a use after free bug? e.g. a long time ago (circa
~2.6.16, IIRC) we had a bufferhead corruption problem detected in
XFS that was actually caused by a reiserfs use after free.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
