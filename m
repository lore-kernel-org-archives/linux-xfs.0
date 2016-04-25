Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 759AA7CA0
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 03:31:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CBE2304032
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 01:31:21 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id g3lUtASgtDBEjROo (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Apr 2016 01:31:18 -0700 (PDT)
Date: Mon, 25 Apr 2016 01:31:14 -0700
From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Message-ID: <20160425083114.GA27556@infradead.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461434916.3695.7.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

On Sat, Apr 23, 2016 at 06:08:37PM +0000, Verma, Vishal L wrote:
> direct_IO might fail with -EINVAL due to misalignment, or -ENOMEM due
> to some allocation failing, and I thought we should return the original
> -EIO in such cases so that the application doesn't lose the information
> that the bad block is actually causing the error.

EINVAL is a concern here.  Not due to the right error reported, but
because it means your current scheme is fundamentally broken - we
need to support I/O at any alignment for DAX I/O, and not fail due to
alignbment concernes for a highly specific degraded case.

I think this whole series need to go back to the drawing board as I
don't think it can actually rely on using direct I/O as the EIO
fallback.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
