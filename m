Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GF9igO042078 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 10:09:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 885B951D3DA
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 08:09:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FpuD3G4CvaaIuIKq for <xfs@oss.sgi.com>;
	Thu, 16 Jun 2011 08:09:43 -0700 (PDT)
Date: Thu, 16 Jun 2011 11:09:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: suse xfs patches
Message-ID: <20110616150941.GA28112@infradead.org>
References: <20110614201238.GA17586@infradead.org>
	<20110614220550.GA9138@baloo.cartoons>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110614220550.GA9138@baloo.cartoons>
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
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, neilb@suse.de, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 14, 2011 at 05:05:50PM -0500, Goldwyn Rodrigues wrote:
> 
> Yes sure. I suppose you are refering to the patch attached.
> I did not send it upstream because the upstream code had taken a
> different approach and the patch was relevant to the SLES kernel
> tree only.

That, and "XFS: force log before waiting for a pinned buffer".

They look similar, but different enough from things that we have
in mainline that make me really curious if you a) were hitting the
same things, and b) came to different conclusions under different
workloads.

Looking over it in more detail the bufd patch should be fully superceed
by current mainline code, altough less so by the commit you quote, but
rather by the LRU-ification of the xfs_buf code.

Similarly the other one you quote isn't really related to what you have
in tree, in fact you are still missing that case in the suse tree - the
addition to xfs_buf_lock that you're adding only in one caller was added
in commit ed3b4d6cdc81e8feefdbfa3c584614be301b6d39, but that was still
missing the trylock case.

Either way the mainline code only handles pinned and stale buffers,
which from my understanding are what matters, but the changelog from
Neil reads like he saw a case where even non-stale buffers might
matter - except that it's not explained very well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
