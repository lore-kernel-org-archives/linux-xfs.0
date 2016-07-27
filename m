Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F35A77CA0
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 16:51:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53667AC002
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 14:51:37 -0700 (PDT)
Received: from mail-lf0-f66.google.com (mail-lf0-f66.google.com
	[209.85.215.66]) by cuda.sgi.com with ESMTP id NDV4DNM9h7m0D8Vx
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2016 14:51:34 -0700 (PDT)
Received: by mail-lf0-f66.google.com with SMTP id f93so2721851lfi.0
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 14:51:34 -0700 (PDT)
Date: Thu, 28 Jul 2016 00:51:30 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 8/9] vfs: hoist the btrfs deduplication ioctl to the vfs
Message-ID: <20160727215130.GA18996@node.shutemov.name>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
	<20151219085559.12478.33700.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219085559.12478.33700.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, xfs@oss.sgi.com

On Sat, Dec 19, 2015 at 12:55:59AM -0800, Darrick J. Wong wrote:
> Hoist the btrfs EXTENT_SAME ioctl up to the VFS and make the name
> more systematic (FIDEDUPERANGE).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/compat_ioctl.c       |    1 
>  fs/ioctl.c              |   38 ++++++++++++++++++
>  fs/read_write.c         |  100 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h      |    4 ++
>  include/uapi/linux/fs.h |   30 ++++++++++++++
>  5 files changed, 173 insertions(+)
> 
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 70d4b10..eab31e7 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -1582,6 +1582,7 @@ COMPAT_SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd,
>  
>  	case FICLONE:
>  	case FICLONERANGE:
> +	case FIDEDUPERANGE:
>  		goto do_ioctl;
>  
>  	case FIBMAP:
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 84c6e79..fcdd33b 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -568,6 +568,41 @@ static int ioctl_fsthaw(struct file *filp)
>  	return thaw_super(sb);
>  }
>  
> +static long ioctl_file_dedupe_range(struct file *file, void __user *arg)
> +{
> +	struct file_dedupe_range __user *argp = arg;
> +	struct file_dedupe_range *same = NULL;
> +	int ret;
> +	unsigned long size;
> +	u16 count;
> +
> +	if (get_user(count, &argp->dest_count)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	size = offsetof(struct file_dedupe_range __user, info[count]);

Vlastimil triggered this during fuzzing:

http://paste.opensuse.org/view/raw/99203426

High order allocation without __GFP_NOWARN + fallback. That's not good.

Basically, we don't have any sanity check of 'dest_count' here. This u16
comes directly from userspace. And we call memdup_user() based on it.

Here's a program which makes kernel allocate order-9 page:

https://gist.github.com/kiryl/2b344b51da1fd2725be420a996b10d22

Should we put some reasonable upper limit for the 'dest_count'?
What is typical 'dest_count'?

> +
> +	same = memdup_user(argp, size);
> +	if (IS_ERR(same)) {
> +		ret = PTR_ERR(same);
> +		same = NULL;
> +		goto out;
> +	}
> +
> +	ret = vfs_dedupe_file_range(file, same);
> +	if (ret)
> +		goto out;
> +
> +	ret = copy_to_user(argp, same, size);
> +	if (ret)
> +		ret = -EFAULT;
> +
> +out:
> +	kfree(same);
> +	return ret;
> +}
> +

-- 
 Kirill A. Shutemov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
