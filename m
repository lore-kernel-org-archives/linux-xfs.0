Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1129E7F8E
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 08:38:56 -0500 (CDT)
Message-ID: <53469EF0.3030407@sgi.com>
Date: Thu, 10 Apr 2014 08:38:56 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 15/14] xfs_io: free memory on error path exit from bmap_f()
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
	<5345C751.8040803@sandeen.net>
In-Reply-To: <5345C751.8040803@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 04/09/14 17:18, Eric Sandeen wrote:
> If realloc() fails, the memory it was trying to realloc remains;
> free it on the error path.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> diff --git a/io/bmap.c b/io/bmap.c
> index a78cbb1..8e5d75e 100644
> --- a/io/bmap.c
> +++ b/io/bmap.c
> @@ -227,6 +227,7 @@ bmap_f(
>   				fprintf(stderr,
>   					_("%s: cannot realloc %d bytes\n"),
>   					progname, (int)(map_size*sizeof(*map)));
> +				free(map);
>   				exitcode = 1;
>   				return 0;
>   			}


Didn't it get into this block by comparing map to NULL?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
