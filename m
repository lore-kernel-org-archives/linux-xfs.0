Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A1BDF7CA0
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2016 11:54:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74285304032
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2016 09:54:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Id4NqYw69mWphDhA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 26 Mar 2016 09:54:07 -0700 (PDT)
Date: Sat, 26 Mar 2016 09:53:59 -0700
From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 5/5] dax: handle media errors in dax_do_io
Message-ID: <20160326165359.GA11387@infradead.org>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
	<1458861450-17705-6-git-send-email-vishal.l.verma@intel.com>
	<20160325104549.GB10525@infradead.org>
	<1458939566.5501.5.camel@intel.com>
	<CAPcyv4jFPYYP=eL72V6MmW2fcXFP3PfQfcO+zYV4NN7rdu1ksg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jFPYYP=eL72V6MmW2fcXFP3PfQfcO+zYV4NN7rdu1ksg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "hch@infradead.org" <hch@infradead.org>, "Verma,
	Vishal L" <vishal.l.verma@intel.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

On Fri, Mar 25, 2016 at 02:42:37PM -0700, Dan Williams wrote:
> That's their prerogative otherwise you are precluding an alternate
> handling of a dax_do_io() failure.  Maybe a fs or upper layer can
> recover in a different manner than re-submit the I/O to the
> __blockdev_direct_IO path.

Let's keep the interface separate because they are, well separate.
There is a reason direct I/O falls back to buffered I/O by returning
and error if it can't handle it instead of handling all the magic.

I also really want to get rid of get_block as soon as possible for
DAX and direct I/O.  For DAX that should actually be possible
really quickly, while direct I/O might take some time and will
be have to be gradual.  So tighter integration of the two interface is
not just bad design, but actively harmful at this point in time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
