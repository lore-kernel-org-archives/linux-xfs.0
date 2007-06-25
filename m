Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 22:45:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5P5jTdo017155
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 22:45:30 -0700
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 9D2B018011E91
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 23:53:03 -0500 (CDT)
Message-ID: <467F4A2F.2060101@sandeen.net>
Date: Sun, 24 Jun 2007 23:53:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] remove hard-coded fnames from tracing functions
References: <467F48B9.7060504@sandeen.net>
In-Reply-To: <467F48B9.7060504@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> This has been on my stack a while, still compiles clean but feel free
> to double-check. :-)
> 
>  xfs_alloc.c      |   53 ++--------
>  xfs_bmap.c       |  266 +++++++++++++++++++++++--------------------------------
>  xfs_bmap.h       |    6 -
>  xfs_bmap_btree.c |   88 +++---------------
>  xfs_inode.c      |    8 -
>  5 files changed, 149 insertions(+), 272 deletions(-)
> 
> ---------------
> 
> Remove the hardcoded "fnames" for tracing, and just embed
> them in tracing macros via __FUNCTION__.  Kills a lot of #ifdefs
> too.

Hm... guess I did send this one already, but don't see it in cvs...
Dave, is it in your stack yet?

-Eric
