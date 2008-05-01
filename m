Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 18:40:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m411eRan015607
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 18:40:29 -0700
Message-ID: <48191FE8.9080607@sgi.com>
Date: Thu, 01 May 2008 11:42:00 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Fix non-debug build for xfsidbg.c
References: <20080430065937.GC108924158@sgi.com> <48181D04.4030902@sgi.com> <20080501004925.GU108924158@sgi.com>
In-Reply-To: <20080501004925.GU108924158@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Sorry I should have been clearer.  What I actually meant was something
like this:

--- a/fs/xfs/xfsidbg.c	2008-05-01 11:34:55.000000000 +1000
+++ b/fs/xfs/xfsidbg.c	2008-05-01 11:35:18.000000000 +1000
@@ -5845,9 +5845,11 @@
  	kdb_printf("curr_cycle: %d  prev_cycle: %d  curr_block: %d  prev_block: %d\n",
  	     log->l_curr_cycle, log->l_prev_cycle, log->l_curr_block,
  	     log->l_prev_block);
-	kdb_printf("iclog_bak: 0x%p  iclog_size: 0x%x (%d)  num iclogs: %d\n",
-		log->l_iclog_bak, log->l_iclog_size, log->l_iclog_size,
-		log->l_iclog_bufs);
+#ifdef DEBUG
+	kdb_printf("iclog_bak: 0x%p\n", log->l_iclog_bak);
+#endif
+	kdb_printf("iclog_size: 0x%x (%d)  num iclogs: %d\n",
+		log->l_iclog_size, log->l_iclog_size, log->l_iclog_bufs);
  	kdb_printf("l_iclog_hsize %d l_iclog_heads %d\n",
  		log->l_iclog_hsize, log->l_iclog_heads);
  	kdb_printf("l_sectbb_log %u l_sectbb_mask %u\n",

This way there is no code duplicated between the debug and non-debug cases.
But I'm fine with your approach too.

Lachlan

David Chinner wrote:
> On Wed, Apr 30, 2008 at 05:17:24PM +1000, Lachlan McIlroy wrote:
>> Dave, would the code look cleaner if iclog_bak was printed on a line by 
>> itself?
>> That way we wouldn't need the #else and we wouldn't be duplicating code.
> 
> Yup, probably a good idea. I've changed it to match how this is handled
> in other places in xfsidbg.c:
> 
> @@ -5846,8 +5846,12 @@
>              log->l_curr_cycle, log->l_prev_cycle, log->l_curr_block,
>              log->l_prev_block);
>         kdb_printf("iclog_bak: 0x%p  iclog_size: 0x%x (%d)  num iclogs: %d\n",
> -               log->l_iclog_bak, log->l_iclog_size, log->l_iclog_size,
> -               log->l_iclog_bufs);
> +#ifdef DEBUG
> +               log->l_iclog_bak,
> +#else
> +               NULL,
> +#endif
> +               log->l_iclog_size, log->l_iclog_size, log->l_iclog_bufs);
>         kdb_printf("l_iclog_hsize %d l_iclog_heads %d\n",
>                 log->l_iclog_hsize, log->l_iclog_heads);
>         kdb_printf("l_sectbb_log %u l_sectbb_mask %u\n",
> 
> Cheers,
> 
> Dave.
