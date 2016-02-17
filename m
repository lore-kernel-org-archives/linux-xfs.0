Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F27B77CA5
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 10:55:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E6B2AC005
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 08:55:06 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HqUbN9LXSs5JDWE0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 08:55:04 -0800 (PST)
Date: Wed, 17 Feb 2016 08:55:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3 V2] xfs: sanitize remount options
Message-ID: <20160217165504.GB16723@infradead.org>
References: <56BBC982.50804@redhat.com> <56BBCA55.3000506@sandeen.net>
	<56C3F721.8080705@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56C3F721.8080705@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Tue, Feb 16, 2016 at 10:29:21PM -0600, Eric Sandeen wrote:
> Perform basic sanitization of remount options by
> passing the option string and a dummy mount structure
> through xfs_parseargs and returning the result.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
