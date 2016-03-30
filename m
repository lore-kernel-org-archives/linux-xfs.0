Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B07E67CB2
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 01:56:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42128AC005
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 23:56:52 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id dYj3HUPDAO1pyIq0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 23:56:50 -0700 (PDT)
Date: Tue, 29 Mar 2016 23:56:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Message-ID: <20160330065646.GA13123@infradead.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<20160330063415.GA2132@infradead.org>
	<1459320877.4102.3.camel@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459320877.4102.3.camel@kernel.org>
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
To: Vishal Verma <vishal@kernel.org>
Cc: linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>, Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Wed, Mar 30, 2016 at 12:54:37AM -0600, Vishal Verma wrote:
> On Tue, 2016-03-29 at 23:34 -0700, Christoph Hellwig wrote:
> > Hi Vishal,
> > 
> > still NAK to calling the direct I/O code directly from the dax code.
> 
> Hm, I thought this was what you meant -- do the fallback/retry attempts
> at the callers of dax_do_io instead of the new dax wrapper function..
> Did I misunderstand you?

Sorry, it is.  I misread fs/block_dev.c as fs/dax.c before my first
coffee this morning.  I'll properly review the series in the afternoon..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
