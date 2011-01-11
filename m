Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0BHaWdg103483 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 11:36:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A3941D24D98
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 09:38:45 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KZ2LLCnNPnC30A9Q for
	<xfs@oss.sgi.com>; Tue, 11 Jan 2011 09:38:45 -0800 (PST)
Date: Tue, 11 Jan 2011 12:38:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add simple splice test
Message-ID: <20110111173845.GC24025@infradead.org>
References: <1294702344-15035-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294702344-15035-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> +echo "Feel the serenity."
> +
> +SRC=$TEST_DIR/$seq.src
> +DST=$TEST_DIR/$seq.dst
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0xa5a55a5a 0 32768k" -c fsync $SRC > /dev/null 2>&1
> +$XFS_IO_PROG -f -c "sendfile -i $SRC 0 32768k" -c fsync $DST > /dev/null 2>&1
> +
> +diff $SRC $DST

I think this should removfe the two files to make sure the test is
reproducible and doesn't overwrite an existing file during the second
run.  Also I'd recomment not to redirect the output to /dev/null but use
our normal xfs_io filters and make the output part of the golden output.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
