Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 623947CA0
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2016 11:36:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37631304032
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2016 09:36:50 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id B7K5M3xC1K3xVL06 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 26 Mar 2016 09:36:43 -0700 (PDT)
Date: Sat, 26 Mar 2016 09:36:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Weird behaviour of mkfs.xfs
Message-ID: <20160326163642.GA19464@infradead.org>
References: <20160326145037.3b5c6302@harpe.intellique.com>
	<20160326154619.3649ebdf@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160326154619.3649ebdf@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Mar 26, 2016 at 03:46:19PM +0100, Emmanuel Florac wrote:
> Actually I was too impatient; it finally ended avec 30 minutes of
> burning bits to the flash. I don't understand the behaviour, though.
> I'm used to mkfs.xfs making its magic extremely quickly, even on
> humongous devices. Here it's a very fast array of only 3.2 TB...

Trey doing a mkfs.xfs -K, without that it diascards the whole device.
I've seen some NVMe device misbehaving under discard storms, up to
the point of resetting the controller..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
