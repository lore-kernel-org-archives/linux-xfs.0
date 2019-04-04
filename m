Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50984 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbfDDVMU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 17:12:20 -0400
Subject: Re: [PATCH 38/36] xfs_io: don't read garbage stack contents if
 INUMBERS goes nuts
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193444.GB1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5a34954c-6174-ce78-73ad-a04f804c79c9@sandeen.net>
Date: Thu, 4 Apr 2019 16:12:18 -0500
MIME-Version: 1.0
In-Reply-To: <20190320193444.GB1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/19 2:34 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In theory INUMBERS will never return an ocount of zero, but on the off
> chance it ever does we'll negative index the igroup array and return
> stack contents for an inode number.  Don't do that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Is there more of a story behind this?  ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/open.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/io/open.c b/io/open.c
> index f5fbd2c4..a406ea54 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -698,6 +698,9 @@ get_last_inode(void)
>  		lastgrp = ocount;
>  	}
>  
> +	if (lastgrp == 0)
> +		return 0;
> +
>  	lastgrp--;
>  
>  	/* The last inode number in use */
> 
