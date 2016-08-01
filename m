Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA2E47CDD
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:28:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ADC648F8035
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:28:54 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id DA4Ml7gUS3cbnftW (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:28:53 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:28:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/17] xfs/179: use scratch device helpers
Message-ID: <20160801062851.GL596@infradead.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914483981.11762.15707981777571396710.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146914483981.11762.15707981777571396710.stgit@birch.djwong.org>
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
Cc: linux-btrfs@vger.kernel.org, eguan@redhat.com, fstests@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 21, 2016 at 04:47:19PM -0700, Darrick J. Wong wrote:
> Use the helper functions for scratch devices.  This fixes a problem
> where xfs/179 fails when there's a realtime device.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
