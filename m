Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 663BF7CA3
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 18:11:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8FCAAC002
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 16:11:33 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UwlMnEPYcHaBbfPK for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2016 16:11:29 -0700 (PDT)
Date: Wed, 20 Jul 2016 09:11:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_vm_releasepage() causing BUG at free_buffer_head()
Message-ID: <20160719231108.GH16044@dastard>
References: <143E2E5E912B4C348E8C62AA987F0506@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <143E2E5E912B4C348E8C62AA987F0506@alyakaslap>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alex Lyakas <alex@zadarastorage.com>
Cc: xfs@oss.sgi.com

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
