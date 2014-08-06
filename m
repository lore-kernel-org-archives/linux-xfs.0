Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD1FA7F6B
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 09:28:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9BA9630404E
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 07:28:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id qp4WdVbbg7cjtpNV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Aug 2014 07:28:49 -0700 (PDT)
Date: Wed, 6 Aug 2014 07:28:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Remove typedef xfs_uu_t
Message-ID: <20140806142847.GA9757@infradead.org>
References: <20140806141343.GA15659@himangi-Dell>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140806141343.GA15659@himangi-Dell>
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
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 06, 2014 at 07:43:43PM +0530, Himangi Saraogi wrote:
> The Linux kernel coding style guidelines suggest not using typedefs
> for structure types. This patch gets rid of the typedef for xfs_uu_t.
> Also the names of the struct is changed to drop the _t, to make the
> name look less typedef-like.

The right fix is to just kill the type, and read the values directly
from the uuid_t type using get_unaligned_be16.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
