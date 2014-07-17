Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C0647FD1
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 04:07:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BCDC2AC003
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 02:07:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id PCj3DqsY9QTDGfCG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 02:07:16 -0700 (PDT)
Date: Thu, 17 Jul 2014 02:07:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/007: add project quota Q_XQUOTRM test
Message-ID: <20140717090714.GA16015@infradead.org>
References: <53C73562.3010005@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53C73562.3010005@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: fstests@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jul 17, 2014 at 10:30:58AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Add test for project quota Q_XQUOTRM operations, this patch also
> update the golden output file to match the new output.

Changing the test to require crc filesystems seems like a bad idea.

I'd suggest to simply do two passes instead: the first one unchanged,
and the second one testing project instead of group quotas.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
