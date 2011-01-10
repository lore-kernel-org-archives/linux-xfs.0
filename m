Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AKBNoE036706 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 14:11:23 -0600
Date: Mon, 10 Jan 2011 15:13:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12] xfsprogs: simplify leading '/' handling in
	generate_obfuscated_name()
Message-ID: <20110110201335.GB27277@infradead.org>
References: <1293741612.2294.354.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1293741612.2294.354.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 30, 2010 at 02:40:12PM -0600, Alex Elder wrote:
> In generate_obfuscated_name(), the incoming file name is allowed to
> start with a '/' character, in which case it is copied over to the
> new file name and ignored for the remainder of the hash calculation.
> Simplify the affected code by processing the '/' right away, and
> using a pointer thereafter for the start of the new file name.

The actual change looks good to me, but why would we ever have a /
in the filename, and if we do why would we treat it special?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
