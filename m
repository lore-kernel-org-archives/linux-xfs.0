Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FBFB7CDC
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:31:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 637B88F8035
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:31:34 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id BmQo3AnL3NIbKUCY (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:31:32 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:31:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: cap dedupe request structure size at PAGE_SIZE
Message-ID: <20160801063128.GA15590@infradead.org>
References: <20160728183534.GB15753@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160728183534.GB15753@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>, Vlastimil Babka <vbabka@suse.cz>

On Thu, Jul 28, 2016 at 11:35:34AM -0700, Darrick J. Wong wrote:
> Kirill A. Shutemov reports that the kernel doesn't try to cap dest_count
> in any way, and uses the number to allocate kernel memory.  This causes
> high order allocation warnings in the kernel log if someone passes in a
> big enough value.  We should clamp the allocation at PAGE_SIZE to avoid
> stressing the VM.
> 
> The two existing users of the dedupe ioctl never send more than 120
> requests, so we can safely clamp dest_range at PAGE_SIZE, because with
> 4k pages we can handle up to 127 dedupe candidates.  Given the max
> extent length of 16MB, we can end up doing 2GB of IO which is plenty.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> @@ -582,6 +582,10 @@ static int ioctl_file_dedupe_range(struct file *file, void __user *arg)

This function returns long in mainline.  Maybe you should resend your
return type fix to Al while you're at it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
