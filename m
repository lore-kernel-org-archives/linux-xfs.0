Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 225977CA3
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 09:24:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9BDECAC006
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 07:24:37 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id D8QNhH5vL1OdSWIh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 07:24:36 -0700 (PDT)
Date: Thu, 5 May 2016 07:24:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
Message-ID: <20160505142433.GA4557@infradead.org>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
	<5727753F.6090104@plexistor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5727753F.6090104@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>

On Mon, May 02, 2016 at 06:41:51PM +0300, Boaz Harrosh wrote:
> > All IO in a dax filesystem used to go through dax_do_io, which cannot
> > handle media errors, and thus cannot provide a recovery path that can
> > send a write through the driver to clear errors.
> > 
> > Add a new iocb flag for DAX, and set it only for DAX mounts. In the IO
> > path for DAX filesystems, use the same direct_IO path for both DAX and
> > direct_io iocbs, but use the flags to identify when we are in O_DIRECT
> > mode vs non O_DIRECT with DAX, and for O_DIRECT, use the conventional
> > direct_IO path instead of DAX.
> > 
> 
> Really? What are your thinking here?
> 
> What about all the current users of O_DIRECT, you have just made them
> 4 times slower and "less concurrent*" then "buffred io" users. Since
> direct_IO path will queue an IO request and all.
> (And if it is not so slow then why do we need dax_do_io at all? [Rhetorical])
> 
> I hate it that you overload the semantics of a known and expected
> O_DIRECT flag, for special pmem quirks. This is an incompatible
> and unrelated overload of the semantics of O_DIRECT.

Agreed - makig O_DIRECT less direct than not having it is plain stupid,
and I somehow missed this initially.

This whole DAX story turns into a major nightmare, and I fear all our
hodge podge tweaks to the semantics aren't helping it.

It seems like we simply need an explicit O_DAX for the read/write
bypass if can't sort out the semantics (error, writer synchronization)
just as we need a special flag for MMAP..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
