Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q06FsSI1028368 for <xfs@oss.sgi.com>; Fri, 6 Jan 2012 09:54:28 -0600
Message-ID: <4F071935.9050201@sgi.com>
Date: Fri, 06 Jan 2012 09:54:29 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add SEEK_DATA/SEEK_HOLE sanity checker
References: <4EFB1C8D.8070405@oracle.com>
In-Reply-To: <4EFB1C8D.8070405@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On 12/28/11 07:41, Jeff Liu wrote:

> +
> +static ssize_t do_pwrite(int fd, const void *buf, size_t count, off_t
> offset)
> +{
> +       ssize_t ret, written = 0;
> +
> +       while (count>  written) {
> +               ret = pwrite(fd, buf + written, count - written, offset
> + written);
>


I believe there is a missing "-" between "offset" and "written".

The patchworks version (3108) was truncated.

There are some line wraps on the patch file, which give patch/quilt errors.

Minor text editing.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
