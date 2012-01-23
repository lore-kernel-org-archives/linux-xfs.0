Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NJxPsV135624 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 13:59:25 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	760RZgtQrUSvYG92 for <xfs@oss.sgi.com>;
	Mon, 23 Jan 2012 11:59:23 -0800 (PST)
Date: Mon, 23 Jan 2012 14:59:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: check for size parsing errors in xfs_quota
Message-ID: <20120123195922.GA2366@infradead.org>
References: <4F1D9989.8060808@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F1D9989.8060808@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: James Lawrie <james@jdlawrie.co.uk>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jan 23, 2012 at 11:31:53AM -0600, Eric Sandeen wrote:
> Doing something like 
> 
> # xfs_quota -x -c 'limit -u bhard=1.2g ...
> 
> will cause cvtnum to fail and return a value of -1LL (because it
> cannot parse the decimal), but the quota caller doesn't check
> for this error value, casts it to U64, shifts right, and we end
> up with an answer of 16 petabytes rather than erroring out.
> Fix this.

Can you add a test case for it, please?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
