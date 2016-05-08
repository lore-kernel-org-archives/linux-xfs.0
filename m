Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DFC517CA0
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 04:28:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5343304032
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 02:28:11 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 7OAKLtAcs3HckwAB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 May 2016 02:28:08 -0700 (PDT)
Date: Sun, 8 May 2016 02:27:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 0/8] block: prepare for multipage bvecs
Message-ID: <20160508092758.GA29621@infradead.org>
References: <1460928615-20894-1-git-send-email-ming.lei@canonical.com>
	<CACVXFVOw2dnO0tw5n2dPXUQh_tkGLCo742AXpJ8mMQG6LQZVUA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACVXFVOw2dnO0tw5n2dPXUQh_tkGLCo742AXpJ8mMQG6LQZVUA@mail.gmail.com>
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
Cc: linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On Tue, May 03, 2016 at 09:03:58AM +0800, Ming Lei wrote:
> Any possibility to make v5 into v4.7 so that we can move on about
> multipage bvecs?
> 
> BTW, even though not considering mp bvecs, this patchset is still a
> good cleanup.

Agreed.  I'm fine with the series and it looks harmless enough for
4.7.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
