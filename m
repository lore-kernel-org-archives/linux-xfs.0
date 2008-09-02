Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Sep 2008 00:03:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m82739wS022591
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2008 00:03:10 -0700
Message-ID: <48BCE564.5070408@sgi.com>
Date: Tue, 02 Sep 2008 17:04:04 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] buffer flag NONE is actually DONE
References: <48BCC8C2.7040103@sgi.com>
In-Reply-To: <48BCC8C2.7040103@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> Amazing but true.
> 
> --- a/fs/xfs/xfsidbg.c    2008-09-02 14:52:11.000000000 +1000
> +++ b/fs/xfs/xfsidbg.c    2008-09-02 14:51:04.000000000 +1000
> @@ -1926,7 +1926,7 @@ static int    kdbm_iptraceaddr(
> 
> static char    *bp_flag_vals[] = {
> /*  0 */ "READ", "WRITE", "MAPPED", "PARTIAL", "ASYNC",
> -/*  5 */ "NONE", "DELWRI",  "STALE", "FS_MANAGED", "FS_DATAIOD",
> +/*  5 */ "DONE", "DELWRI",  "STALE", "FS_MANAGED", "FS_DATAIOD",
> /* 10 */ "FORCEIO", "FLUSH", "READ_AHEAD", "DIRECTIO", "LOCK",
> /* 15 */ "TRYLOCK", "DONT_BLOCK", "PAGE_CACHE", "KMEM_ALLOC", "RUN_QUEUES",
> /* 20 */ "PRIVATE_BH", "DELWRI_Q",

Looks good.

Quick look at possible mismatching names:

11 "FLUSH" vs "ORDERED"
18 "KMEM_ALLOC" vs "PAGES"
22 NULL vs "PAGE_LOCKED"

--Tim
