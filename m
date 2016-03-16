Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 77EE67CF5
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 07:04:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CDCE8AC002
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 05:04:34 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wXdwPjrTkozeqC8G (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 05:04:29 -0700 (PDT)
Date: Wed, 16 Mar 2016 05:04:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/073: filter out finobt warning from mkfs.xfs
Message-ID: <20160316120416.GA18030@infradead.org>
References: <1458129204-31882-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458129204-31882-1-git-send-email-eguan@redhat.com>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 16, 2016 at 07:53:24PM +0800, Eryu Guan wrote:
> When testing xfs/073 with MKFS_OPTIONS="-m crc=1,finobt=1" set, it fails
> due to extra warning about disabling finobt feature:
> 
>  +warning: finobt not supported without CRC support, disabled.
> 
> Because xfs/073 disables crc unconditionally and finobt can not be
> enabled either.

How about explicitly disabling finobt as well?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
