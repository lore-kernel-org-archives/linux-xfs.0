Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47F097CCF
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 03:33:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0850030404E
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 01:33:39 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id x2DdobY3C8YDIkIq (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Apr 2016 01:33:35 -0700 (PDT)
Date: Tue, 26 Apr 2016 01:33:32 -0700
From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Message-ID: <20160426083332.GB364@infradead.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
	<1461604476.3106.12.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461604476.3106.12.camel@intel.com>
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

On Mon, Apr 25, 2016 at 05:14:36PM +0000, Verma, Vishal L wrote:
> - Application hits EIO doing dax_IO or load/store io
> 
> - It checks badblocks and discovers it's files have lost data
> 
> - It write()s those sectors (possibly converted to file offsets using
> fiemap)
> ?? ?? * This triggers the fallback path, but if the application is doing
> this level of recovery, it will know the sector is bad, and write the
> entire sector

This sounds like a mess.

> I think if we want to keep allowing arbitrary alignments for the
> dax_do_io path, we'd need:
> 1. To represent badblocks at a finer granularity (likely cache lines)
> 2. To allow the driver to do IO to a *block device* at sub-sector
> granularity

It's not a block device if it supports DAX.  It's byte addressable
memory masquerading as a block device.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
