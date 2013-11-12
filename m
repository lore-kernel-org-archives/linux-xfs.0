Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 474F729E17
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 12:30:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6EE1AC008
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 10:30:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id LqQCmesTEjyZNiPd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 10:30:32 -0800 (PST)
Date: Tue, 12 Nov 2013 10:30:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfststs: add a helper to get the minimum dio size
Message-ID: <20131112183031.GA8106@infradead.org>
References: <20131106105932.GA7807@infradead.org>
	<52826FBC.4000003@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52826FBC.4000003@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Nov 12, 2013 at 12:13:16PM -0600, Eric Sandeen wrote:
> On 11/6/13, 4:59 AM, Christoph Hellwig wrote:
> > Various tests opencode checks to find out the minimum support direct I/O
> > size.  Replace those with a generic helper that handles network filesystems as
> > well.  Also remove the Linux 2.4 workaround we had in once place.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> No callers of min_dio_alignment w/o a blockdev right?  But I guess
> that fallback is harmless.

All network filesystems will not have a device here.  Not sure how the
btrfs pool names work, but that would be another suspect.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
