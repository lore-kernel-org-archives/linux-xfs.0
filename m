Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932670AbeFUUKF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 16:10:05 -0400
Subject: Re: [PATCH] xfs_bmap: remove -c from manpage
References: <20180621195524.GH4838@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <86b4d1ed-716f-f485-a2d1-a28d1d1f9dac@redhat.com>
Date: Thu, 21 Jun 2018 15:10:03 -0500
MIME-Version: 1.0
In-Reply-To: <20180621195524.GH4838@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 6/21/18 2:55 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There is no -c switch so remove the documentation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, it still lives and is advertised in xfs_io, but *shrug*
that's ok, that can be patch 3 if we care.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man8/xfs_bmap.8 |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/man/man8/xfs_bmap.8 b/man/man8/xfs_bmap.8
> index ae923481..dd925b12 100644
> --- a/man/man8/xfs_bmap.8
> +++ b/man/man8/xfs_bmap.8
> @@ -36,10 +36,6 @@ no matter what the filesystem's block size is.
>  If this option is specified, information about the file's
>  attribute fork is printed instead of the default data fork.
>  .TP
> -.B \-c
> -If this option is specified, information about the file's
> -copy on write fork is printed instead of the default data fork.
> -.TP
>  .B \-d
>  If portions of the file have been migrated offline by
>  a DMAPI application, a DMAPI read event will be generated to
> 

