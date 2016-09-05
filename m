Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9507B7CA1
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 09:55:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04F11AC002
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 07:55:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id F8lhiJ9Yi4HklurL (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2016 07:55:54 -0700 (PDT)
Date: Mon, 5 Sep 2016 07:55:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] vfs: cap dedupe request structure size at PAGE_SIZE
Message-ID: <20160905145549.GA7662@infradead.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
	<147216785429.525.1965983896010934181.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216785429.525.1965983896010934181.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, torvalds@linux-foundation.org
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, linux-xfs@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>

This really should go into 4.8 (and the previous patch probably as
well), and I've said that a couple of times, and you tried a few times
to send it to Al at least.

Al, do you want to pick it up or should Darrick send it straight to
Linus?

On Thu, Aug 25, 2016 at 04:30:54PM -0700, Darrick J. Wong wrote:
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
> 
> Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ioctl.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 26aba09..c415668 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -582,6 +582,10 @@ static int ioctl_file_dedupe_range(struct file *file, void __user *arg)
>  	}
>  
>  	size = offsetof(struct file_dedupe_range __user, info[count]);
> +	if (size > PAGE_SIZE) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
>  
>  	same = memdup_user(argp, size);
>  	if (IS_ERR(same)) {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
