Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51642 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751742AbdFUT2W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 15:28:22 -0400
Subject: Re: [PATCH] fsr: fix uninitialized fs usage after timeout
References: <b4921f6d-01c7-09eb-641f-47f1be998e61@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <118e7672-680a-689d-6b74-7169a38b3d89@sandeen.net>
Date: Wed, 21 Jun 2017 14:28:20 -0500
MIME-Version: 1.0
In-Reply-To: <b4921f6d-01c7-09eb-641f-47f1be998e61@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 6/2/17 1:20 PM, Jeff Mahoney wrote:
> In the main loop of fsrallfs, we exit when we've hit the timeout but
> we increment fs before we get there.  If we're operating on the last
> file system in the array, we'll hit an uninitialized fsdesc and
> crash in fsrall_cleanup.

Ugh, really - nobody should be using the defrag-the-world mode,
but we ship it, so ...

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fsr/xfs_fsr.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 517b75f0..e695c243 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -598,7 +598,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
>  	signal(SIGTERM, aborter);
> 
>  	/* reorg for 'howlong' -- checked in 'fsrfs' */
> -	while (endtime > time(0)) {
> +	for (; endtime > time(0); fs->npass++, fs++) {
>  		pid_t pid;
>  		if (fs == fsend)
>  			fs = fsbase;
> @@ -629,8 +629,6 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
>  			break;
>  		}
>  		startino = 0;  /* reset after the first time through */
> -		fs->npass++;
> -		fs++;
>  	}
>  	fsrall_cleanup(endtime <= time(0));
>  }

I hate to be that PITA maintainer who only wants to do it his way ;) but
would this be any tidier?

I'm just not that big a fan of "for(; ....)" loops.

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 517b75f..3a5f683 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -600,12 +600,6 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 	/* reorg for 'howlong' -- checked in 'fsrfs' */
 	while (endtime > time(0)) {
 		pid_t pid;
-		if (fs == fsend)
-			fs = fsbase;
-		if (fs->npass == npasses) {
-			fsrprintf(_("Completed all %d passes\n"), npasses);
-			break;
-		}
 		if (npasses > 1 && !fs->npass)
 			Mflag = 1;
 		else
@@ -631,6 +625,12 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 		startino = 0;  /* reset after the first time through */
 		fs->npass++;
 		fs++;
+		if (fs == fsend)
+			fs = fsbase;
+		if (fs->npass == npasses) {
+			fsrprintf(_("Completed all %d passes\n"), npasses);
+			break;
+		}
 	}
 	fsrall_cleanup(endtime <= time(0));
 }


