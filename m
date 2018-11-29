Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49018 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbeK2LlK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Nov 2018 06:41:10 -0500
Subject: Re: [PATCH 7/6] xfs_db: add missing string name for DBM_COWDATA
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <20181127231545.GA8125@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7730aacc-0b44-bc48-df57-e29aa64eac03@sandeen.net>
Date: Wed, 28 Nov 2018 18:37:40 -0600
MIME-Version: 1.0
In-Reply-To: <20181127231545.GA8125@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 11/27/18 5:15 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In db/check.c, typename[] is supposed to have strings for every DBM_
> type, but we forgot one.  Add it now.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/check.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/db/check.c b/db/check.c
> index 352aab3f..f5b5e845 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -164,6 +164,7 @@ static const char	*typename[] = {
>  	"btrmap",
>  	"btrefcnt",
>  	"rldata",
> +	"cowdata",
>  	NULL
>  };
>  static int		verbose;

Maybe:

/* Every type plus the NULL at the end */
BUILD_BUG_ON(ARRAY_SIZE(typename) != DBM_NDBM + 1);

in init() to avoid this next time?

-Eric
