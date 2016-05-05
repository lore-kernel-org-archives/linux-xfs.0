Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2EC7C7CA7
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 16:39:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F36F28F8050
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 14:39:17 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id A5vWkqxReAoNFyR9 for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 14:39:17 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
Date: Thu, 5 May 2016 21:39:14 +0000
Message-ID: <1462484343.29294.1.camel@intel.com>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
	<5727753F.6090104@plexistor.com> <20160505142433.GA4557@infradead.org>
In-Reply-To: <20160505142433.GA4557@infradead.org>
Content-Language: en-US
Content-ID: <A85A0D742E7D4047B1D16786AE1B7AF0@intel.com>
MIME-Version: 1.0
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
To: "hch@infradead.org" <hch@infradead.org>, "boaz@plexistor.com" <boaz@plexistor.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "matthew@wil.cx" <matthew@wil.cx>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu, 2016-05-05 at 07:24 -0700, Christoph Hellwig wrote:
> On Mon, May 02, 2016 at 06:41:51PM +0300, Boaz Harrosh wrote:
> > 
> > > 
> > > All IO in a dax filesystem used to go through dax_do_io, which
> > > cannot
> > > handle media errors, and thus cannot provide a recovery path that
> > > can
> > > send a write through the driver to clear errors.
> > > 
> > > Add a new iocb flag for DAX, and set it only for DAX mounts. In
> > > the IO
> > > path for DAX filesystems, use the same direct_IO path for both DAX
> > > and
> > > direct_io iocbs, but use the flags to identify when we are in
> > > O_DIRECT
> > > mode vs non O_DIRECT with DAX, and for O_DIRECT, use the
> > > conventional
> > > direct_IO path instead of DAX.
> > > 
> > Really? What are your thinking here?
> > 
> > What about all the current users of O_DIRECT, you have just made
> > them
> > 4 times slower and "less concurrent*" then "buffred io" users. Since
> > direct_IO path will queue an IO request and all.
> > (And if it is not so slow then why do we need dax_do_io at all?
> > [Rhetorical])
> > 
> > I hate it that you overload the semantics of a known and expected
> > O_DIRECT flag, for special pmem quirks. This is an incompatible
> > and unrelated overload of the semantics of O_DIRECT.
> Agreed - makig O_DIRECT less direct than not having it is plain
> stupid,
> and I somehow missed this initially.

How is it any 'less direct'? All it does now is follow the blockdev
O_DIRECT path. There still isn't any page cache involved..

> 
> This whole DAX story turns into a major nightmare, and I fear all our
> hodge podge tweaks to the semantics aren't helping it.
> 
> It seems like we simply need an explicit O_DAX for the read/write
> bypass if can't sort out the semantics (error, writer synchronization)
> just as we need a special flag for MMAP..
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
