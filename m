Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F5BD7F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 11:35:20 -0600 (CST)
Message-ID: <5464EBD6.3040107@sgi.com>
Date: Thu, 13 Nov 2014 11:35:18 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/9] xfsdump: remove pointless if (dirty);
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
	<1415818638-32700-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1415818638-32700-5-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 11/12/14 12:57, Eric Sandeen wrote:
> "dirty" seems to be a remnant of unfinished code; other bits of
> it are there but commented out, so comment out "if (dirty);" as
> well, which is a no-op if statement which can't be true.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>   inventory/inv_stobj.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
> index becac17..84b15d9 100644
> --- a/inventory/inv_stobj.c
> +++ b/inventory/inv_stobj.c
> @@ -976,7 +976,9 @@ stobj_delete_mobj(int fd,
>
>   		}
>   		free ( mfiles );
> +/*
>   		if ( dirty );
> +*/
>   	}
>
>   	free ( strms );

Why not remove all the references to dirty in the function?
Like you said, it doesn't do anything.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
