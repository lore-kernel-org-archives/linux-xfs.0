Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n115A8cn152997 for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 23:10:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E32018A0767
	for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 21:09:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gCXtL6b7AfiK0Wvj for
	<xfs@oss.sgi.com>; Sat, 31 Jan 2009 21:09:27 -0800 (PST)
Date: Sun, 1 Feb 2009 00:09:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dm_get_dirattrs can write past end of user buffer
Message-ID: <20090201050927.GA18999@infradead.org>
References: <4984E904.3020509@kevinjamieson.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4984E904.3020509@kevinjamieson.com>
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
To: Kevin Jamieson <kevin@kevinjamieson.com>
Cc: xfs@oss.sgi.com

On Sat, Jan 31, 2009 at 04:12:52PM -0800, Kevin Jamieson wrote:
> The below patch appears to fix the problem.

The patch looks okay, but I don't think there's any uptodate tree
that includes dmapi support.

Btw, we'd also need to have a

	Signed-off-by: Kevin Jamieson <kevin@kevinjamieson.com>

please read Documentation/SubmittingPatches in the kernel tree and make
sure you agree with the conditions for the Signed-off-by:.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
