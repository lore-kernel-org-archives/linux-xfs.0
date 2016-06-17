Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB7767CB7
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 06:33:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45FEBAC004
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:33:17 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id muzc3kkTupQslAxM (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:33:16 -0700 (PDT)
Date: Fri, 17 Jun 2016 04:33:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 003/119] xfs: check offsets of variable length structures
Message-ID: <20160617113314.GB19042@infradead.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612629195.12839.14090954204243398929.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612629195.12839.14090954204243398929.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:18:12PM -0700, Darrick J. Wong wrote:
> Some of the directory/attr structures contain variable-length objects,
> so the enclosing structure doesn't have a meaningful fixed size at
> compile time.  We can check the offsets of the members before the
> variable-length member, so do those.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine, and should go in independently of the rmap work:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
