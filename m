Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B19EB7CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 02:52:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80CF08F8037
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 00:52:34 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id eXTrY0a8EvXv3jTP (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 00:52:33 -0700 (PDT)
Date: Thu, 31 Mar 2016 00:52:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 2/8] block: make 'struct bvec_iter' not depend on
	CONFIG_BLOCK
Message-ID: <20160331075228.GA2491@infradead.org>
References: <1459354637-17415-1-git-send-email-ming.lei@canonical.com>
	<1459354637-17415-3-git-send-email-ming.lei@canonical.com>
	<20160330171927.GA13320@infradead.org>
	<CACVXFVNtphY8bWrdMKcR7jYn5hD=H5H6jXrY111K0kZ8jJQHWw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACVXFVNtphY8bWrdMKcR7jYn5hD=H5H6jXrY111K0kZ8jJQHWw@mail.gmail.com>
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
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-block@vger.kernel.org, Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

On Thu, Mar 31, 2016 at 09:02:59AM +0800, Ming Lei wrote:
> That way may cause trouble to blk_type.h because it needs bvec_iter,
> then looks not good to always include bvec_iter.h into blk_type.h.

I'd expect bvec.h to be always included in blk_types.h, and replace
the inclusion of blk_types.h in fs.h eventually.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
