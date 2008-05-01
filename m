Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:42:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m41Mg4Y9007090
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:42:06 -0700
Date: Fri, 2 May 2008 08:42:37 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfsqa 166 failure
Message-ID: <20080501224237.GO108924158@sgi.com>
References: <20080501205004.GA30384@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501205004.GA30384@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, May 01, 2008 at 10:50:04PM +0200, Christoph Hellwig wrote:
> Looks like the awk on my system (mawk-1.3.3-11 from Debian unstable) doesn't
> like the regex used in there.  I guess it's some kind of GNU awk
> extension:
> 
> 166	[ 2583.856446] XFS mounting filesystem hdd
> [ 2583.871549] Ending clean XFS mount for filesystem: hdd
>  - output mismatch (see 166.out.bad)
> 2,6c2,3
> < 0: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
> < 1: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
> < 2: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
> < 3: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
> < 4: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
> ---
> > awk: line 9: regular expression compile failed (missing operand)
>  * is the extent unwritten? *

gawk supports C comment syntax inside procedure blocks and doesn't
interpret them as regexes. I think the standard comment syntax
is supposed to be like bash - use "#". Of course, the gawk man
page doesn't define comment syntax at all, but mawk does.

Does the patch below fix it?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 xfstests/166 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfs-cmds/xfstests/166
===================================================================
--- xfs-cmds.orig/xfstests/166	2008-04-28 13:54:14.000000000 +1000
+++ xfs-cmds/xfstests/166	2008-05-02 08:39:46.746511614 +1000
@@ -40,7 +40,7 @@ _filter_blocks()
 		unwritten2 = ((1048576/512) / 2) - 2 * written_size
 	}
 
-	/* is the extent unwritten? */
+	# is the extent unwritten?
 	unwritten_ext = 0;
 	if ($7 >= 10000)
 		unwritten_ext = 1;
