Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MKIRg0256666 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 15:18:27 -0500
Subject: Re: [PATCH] xfstests: add new getdents test
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1315786747-12109-1-git-send-email-notasas@gmail.com>
References: <1315786747-12109-1-git-send-email-notasas@gmail.com>
Date: Thu, 22 Sep 2011 15:18:22 -0500
Message-ID: <1316722702.2009.59.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, 2011-09-12 at 03:19 +0300, Grazvydas Ignotas wrote:
> The test checks if no duplicate d_off values are returned and that
> those values are seekable to the right inodes.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

I have two minor comments on the C program below,
but even if you don't want to address them this
looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> +#include <sys/syscall.h>
> +
> +struct linux_dirent64 {
> +	uint64_t	d_ino;
> +	uint64_t	d_off;
> +	unsigned short	d_reclen;
> +	unsigned char	d_type;
> +	char		d_name[0];
> +};
> +
> +#define BUF_SIZE 4096
> +#define HISTORY_LEN 1024
> +
> +static uint64_t d_off_histoty[HISTORY_LEN];
> +static uint64_t d_ino_histoty[HISTORY_LEN];

Is "histoty" intentional or a typo?

> +int
> +main(int argc, char *argv[])
> +{
> +	int fd, nread;
> +	char buf[BUF_SIZE];

. . .

> +
> +	/* check if seek works correctly */
> +	d = (struct linux_dirent64 *)buf;
> +	for (i = total - 1; i >= 0; i--)
> +	{
> +		lret = lseek(fd, i > 0 ? d_off_histoty[i - 1] : 0, SEEK_SET);
> +		if (lret == -1) {
> +			perror("lseek");
> +			exit(EXIT_FAILURE);
> +		}
> +
> +		nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);

You could just use sizeof (struct linux_dirent_64) rather than
BUF_SIZE here.  I suppose it doesn't hurt but there's no real
sense in reading more than the one you're going to look at.

> +		if (nread == -1) {
> +			perror("getdents");
> +			exit(EXIT_FAILURE);
> +		}
> +

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
