Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 11:33:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7JIXnbm002471
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 11:33:51 -0700
Received: from Liberator.local (unknown [10.0.0.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id EEA6D18DF93B1
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 13:33:54 -0500 (CDT)
Message-ID: <46C88D1A.1020709@sandeen.net>
Date: Sun, 19 Aug 2007 13:34:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] make xfs stats Kconfigurable
References: <46C750C9.8040604@sandeen.net> <46C87C05.5040905@sandeen.net>
In-Reply-To: <46C87C05.5040905@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Oops, typo in Makefile (CONFIG_XFS_STAT vs _STATS).
> 
> ----
> 
> 
> xfs stats are already optional based on CONFIG_PROC_FS, and there
> is already a (never-set) macro XFS_STATS_OFF which can turn them
> off.  Making it a configurable option, if I turn them off I can
> get a little stack savings on x86, gcc 4.1:

This causes feature -q in xfsqa to report no quotas, because
/proc/fs/xfs/xqm isn't present, but I think that check should just be
removed...?

-Eric
