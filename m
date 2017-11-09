Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45048 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751017AbdKIUqq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:46:46 -0500
Subject: Re: [PATCH v4 4/4] xfs_io: Allow partial writes
References: <20171109192648.6356-1-rgoldwyn@suse.de>
 <20171109192648.6356-4-rgoldwyn@suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c1a81a46-597f-7c6b-1294-aa5411c95914@sandeen.net>
Date: Thu, 9 Nov 2017 14:46:45 -0600
MIME-Version: 1.0
In-Reply-To: <20171109192648.6356-4-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-xfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>

On 11/9/17 1:26 PM, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Partial writes are performed when there is an error midway
> while performing the I/O. Perform the write exactly once and
> return the number of bytes written so far, until the error.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  io/io.h           |  1 +
>  io/pwrite.c       | 25 ++++++++++++++++++++++++-
>  man/man8/xfs_io.8 |  3 +++
>  3 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/io/io.h b/io/io.h
> index 6a0fe657..3862985f 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -25,6 +25,7 @@
>  #define IO_RANDOM	( 0)
>  #define IO_FORWARD	( 1)
>  #define IO_BACKWARD	(-1)
> +#define IO_ONCE		( 2)
>  
>  /*
>   * File descriptor options
> diff --git a/io/pwrite.c b/io/pwrite.c
> index c218f686..b77c0975 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -47,6 +47,7 @@ pwrite_help(void)
>  " -W   -- call fsync(2) at the end (included in timing results)\n"
>  " -B   -- write backwards through the range from offset (backwards N bytes)\n"
>  " -F   -- write forwards through the range of bytes from offset (default)\n"
> +" -O   -- perform pwrite call once and return (maybe partial) bytes written\n"

This also needs to be added to the short help; (and the synopsis
in the manpage; other options too ...)  I'll do it on the way in.

This is always a fun job to update new options in half a dozen references ;)

-Eric
