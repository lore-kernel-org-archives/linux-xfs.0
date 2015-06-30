Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D8D5D7F86
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2015 13:38:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A722C304048
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2015 11:38:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4nDg1jevBie5MgDq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Jun 2015 11:38:06 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id AC29BBACA1
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2015 18:38:05 +0000 (UTC)
Date: Tue, 30 Jun 2015 14:38:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_quota: Better describe quota verbose output
Message-ID: <20150630183804.GA20427@bfoster.bfoster>
References: <1435154949-14223-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1435154949-14223-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 24, 2015 at 11:09:09AM -0300, Carlos Maiolino wrote:
> Due historical reasons, and to be compliant with the generic quota command,
> xfs_quota does not output any information when there is no used percentage of
> the available quota. Such behavior might make users confused, so, I believe it's
> better to have the reasons for such behavior better documented.
> 

Seems reasonable...

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  man/man8/xfs_quota.8 | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index 9b555e9..ef90bfb 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -197,7 +197,9 @@ option reports the numeric IDs rather than the name. The
>  .B \-N
>  option omits the header. The
>  .B \-v
> -option outputs verbose information. The
> +option outputs verbose information, displaying quota values even when there is
> +no used space. Such behavior was chosen to be compliant with the 'quota' command
> +and for historical reasons. The

... though this sounds a bit unclear to me. Specifically, it sounds like
it could be saying that the behavior of -v has some historical
justification, when in fact, it is the absense of output in the
non-verbose case that we're trying to document (assuming I understand
the commit log correctly).

As an example, something like the following sounds more clear to me:

"The -v option outputs verbose information and includes quota limits
with no consumption. By default, xfs_quota does not display limits with
no consumption to maintain compatibility with the 'quota' command."

... but I suspect it could still be worded better.

Brian

>  .B \-f
>  option sends the output to
>  .I file
> -- 
> 2.1.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
