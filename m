Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47138 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbeJFEhv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 6 Oct 2018 00:37:51 -0400
Subject: Re: [PATCH 9/8] xfs_io: dedupe command should only complain if we
 don't dedupe anything
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
 <20181004222733.GM19324@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bda0d21d-d81e-7a16-2440-67037c307c84@sandeen.net>
Date: Fri, 5 Oct 2018 16:37:14 -0500
MIME-Version: 1.0
In-Reply-To: <20181004222733.GM19324@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 10/4/18 5:27 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The dedupe command should only complain about non-matching extents if
> the kernel hasn't managed to dedupe /any/ of the input range.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Should it be "no extents matched" then perhaps?

I mean xfs_io is not exactly-quite a purpose-built dedupe tool, but should
we be a bit more specific if we're issuing a message at all?

if (info->status == XFS_EXTENT_DATA_DIFFERS) {
	if (deduped == 0)
		fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
  			_("No extents matched."));
	else
		fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
  			_("Some extents did not match."));
}

And the manpage implies that any difference will make it fail:

> map length bytes at offset dst_offset in the open file to the same physical
> blocks that are mapped at offset src_offset in the file src_file, but only
> if the contents of both ranges are identical.

now you're telling me it'll make a best effort?  ;)  I think the manpage
needs clarification too ...

> ---


>  io/reflink.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/io/reflink.c b/io/reflink.c
> index 26eb2e32..72dfe32d 100644
> --- a/io/reflink.c
> +++ b/io/reflink.c
> @@ -70,7 +70,8 @@ dedupe_ioctl(
>  					_(strerror(-info->status)));
>  			goto done;
>  		}
> -		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
> +		if (deduped == 0 &&
> +		    info->status == XFS_EXTENT_DATA_DIFFERS) {
>  			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
>  					_("Extents did not match."));
>  			goto done;
> 
