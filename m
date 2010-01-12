Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0C9kol2253805 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 03:46:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54F9B15C3DC
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 01:47:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5GDBWriR3aTpgNzE for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 01:47:46 -0800 (PST)
Date: Tue, 12 Jan 2010 04:47:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfsqa: filter log size in 206
Message-ID: <20100112094745.GB20017@infradead.org>
References: <1263271269-18997-1-git-send-email-david@fromorbit.com>
	<1263271269-18997-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263271269-18997-4-git-send-email-david@fromorbit.com>
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

On Tue, Jan 12, 2010 at 03:41:08PM +1100, Dave Chinner wrote:
> With the log size now going past 128MB, test 206 creates a filesystem
> with a much larger log than 128MB. The golden output expects at
> 128MB log size, so the test breaks. Filter the log size out of the
> mkfs output and golden output so that the test works on both older and
> newer mkfs binaries.

I guess you'll need a large enough test filesystem to hit this so I
don't see it, but it looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
