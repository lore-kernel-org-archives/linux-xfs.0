Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BDAFB7F50
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 02:28:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98F928F804B
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 00:28:36 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 61At1VheiFKcd8F1 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 00:28:35 -0700 (PDT)
Date: Wed, 12 Aug 2015 00:28:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxfs: readahead of dir3 data blocks should use the
	read verifier
Message-ID: <20150812072834.GC32399@infradead.org>
References: <20150811235038.GL10043@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150811235038.GL10043@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 11, 2015 at 04:50:38PM -0700, Darrick J. Wong wrote:
> In the dir3 data block readahead function, use the regular read
> verifier to check the block's CRC and spot-check the block contents
> instead of directly calling only the spot-checking routine.  This
> prevents corrupted directory data blocks from being read into the
> kernel, which can lead to garbage ls output and directory loops (if
> say one of the entries contains slashes and other junk).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
