Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 17:49:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m410mgiG012457
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 17:48:46 -0700
Date: Thu, 1 May 2008 10:49:25 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Fix non-debug build for xfsidbg.c
Message-ID: <20080501004925.GU108924158@sgi.com>
References: <20080430065937.GC108924158@sgi.com> <48181D04.4030902@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48181D04.4030902@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 30, 2008 at 05:17:24PM +1000, Lachlan McIlroy wrote:
> Dave, would the code look cleaner if iclog_bak was printed on a line by 
> itself?
> That way we wouldn't need the #else and we wouldn't be duplicating code.

Yup, probably a good idea. I've changed it to match how this is handled
in other places in xfsidbg.c:

@@ -5846,8 +5846,12 @@
             log->l_curr_cycle, log->l_prev_cycle, log->l_curr_block,
             log->l_prev_block);
        kdb_printf("iclog_bak: 0x%p  iclog_size: 0x%x (%d)  num iclogs: %d\n",
-               log->l_iclog_bak, log->l_iclog_size, log->l_iclog_size,
-               log->l_iclog_bufs);
+#ifdef DEBUG
+               log->l_iclog_bak,
+#else
+               NULL,
+#endif
+               log->l_iclog_size, log->l_iclog_size, log->l_iclog_bufs);
        kdb_printf("l_iclog_hsize %d l_iclog_heads %d\n",
                log->l_iclog_hsize, log->l_iclog_heads);
        kdb_printf("l_sectbb_log %u l_sectbb_mask %u\n",

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
