Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 79BB27F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 16:25:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A533304064
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 14:25:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id unmcpSrSGOyqZlxM for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 14:25:11 -0700 (PDT)
Message-ID: <51A7C3B7.4090204@sandeen.net>
Date: Thu, 30 May 2013 16:25:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3 v2] 285: Fix indentation of do_pwrite
References: <1369948905-6693-1-git-send-email-jack@suse.cz>
	<1369948905-6693-2-git-send-email-jack@suse.cz>
In-Reply-To: <1369948905-6693-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 5/30/13 4:21 PM, Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  src/seek_sanity_test.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)

mmm, whitespace.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index eec6903..748eec2 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -120,19 +120,19 @@ static int do_sync_dirty_pages(int fd, off64_t offset, off64_t nbytes)
>  
>  static ssize_t do_pwrite(int fd, const void *buf, size_t count, off_t offset)
>  {
> -       ssize_t ret, written = 0;
> -
> -       while (count > written) {
> -               ret = pwrite(fd, buf + written, count - written, offset + written);
> -               if (ret < 0) {
> -                       fprintf(stderr, "  ERROR %d: Failed to write %ld "
> -                               "bytes\n", errno, (long)count);
> -                       return ret;
> -               }
> -               written += ret;
> -       }
> -
> -       return 0;
> +	ssize_t ret, written = 0;
> +
> +	while (count > written) {
> +		ret = pwrite(fd, buf + written, count - written, offset + written);
> +		if (ret < 0) {
> +			fprintf(stderr, "  ERROR %d: Failed to write %ld "
> +				"bytes\n", errno, (long)count);
> +			return ret;
> +		}
> +		written += ret;
> +	}
> +
> +	return 0;
>  }
>  
>  #define do_close(x)	do { if ((x) > -1) close(x); } while(0);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
