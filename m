Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 170507CA2
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 08:43:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98A52AC007
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 06:43:33 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id kMssR1EBsERK3OTf (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 06:43:28 -0700 (PDT)
Date: Wed, 30 Mar 2016 06:43:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/206: filter out reflink related outputs
Message-ID: <20160330134327.GA16392@infradead.org>
References: <1459324609-5531-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459324609-5531-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: darrick.wong@oracle.com, fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 30, 2016 at 03:56:49PM +0800, Eryu Guan wrote:
> Commit 13717ffc96fe ("xfs/206: fix output when mkfs knows about
> reflink") added extra lines to xfs/206.out to fit the mkfs output with
> reflink support, but broke tests without reflink support.
> 
> Fix it by filtering out reflink related outputs, just like filtering out
> crc related outputs in the test.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
