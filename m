Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06Gd3ts094279 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 10:39:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B299ED7934
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 08:39:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id npyqBMEqHt6lMGMm for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2010 08:39:54 -0800 (PST)
Date: Wed, 6 Jan 2010 11:39:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] use CFLAGS in src/Makefile
Message-ID: <20100106163953.GA4209@infradead.org>
References: <alpine.DEB.2.01.1001021409290.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1001021409290.3483@bogon.housecafe.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Sat, Jan 02, 2010 at 02:16:08PM -0800, Christian Kujau wrote:
> Hi,
> 
> while compiling xfstests after configuring with a different CFLAGS value, 
> gcc fails in ./src:
> 
> [...]
> make[2]: Entering directory `/usr/local/src/xfstests-git/src'
> gcc -g -O2 -DDEBUG  -I../include -DVERSION=\"1.0.0\" -L/opt/xfsprogs/lib  
> -DREAD iopat.c -o preallo_rw_pattern_reader
> iopat.c:21:21: error: xfs/xfs.h: No such file or directory
> [...]
> 
> Somehow CFLAGS isn't passed to gcc, but "GCFLAGS" is. I'm not too savvy 
> with the xfstests build system, but in include/builddefs.in we see:
> 
>    # Global, Platform, Local CFLAGS
>    CFLAGS += $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
> 
> ...thus I'm proposing the following fix:

This looks correct, or at least better than what we had before.
But I really dislike how we defeat the abstraction used for compiling
all the other tools.

What might be better is to add a small
preallo_rw_pattern_writer.c file that just contains:

#define WRITE
#include iopat.c

and the same for the reader side and use the normal rules to compile
the program.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
