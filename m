Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D72BF7CA0
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 10:32:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B9338F8033
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 08:32:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UfEY7WMJrCtkiiTA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Apr 2016 08:32:12 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
Date: Mon, 25 Apr 2016 11:32:08 -0400
In-Reply-To: <20160425083114.GA27556@infradead.org> (hch@infradead.org's
	message of "Mon, 25 Apr 2016 01:31:14 -0700")
Message-ID: <x49r3dt7lhj.fsf@segfault.boston.devel.redhat.com>
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
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "Verma,
	Vishal L" <vishal.l.verma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@fb.com" <axboe@fb.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

"hch@infradead.org" <hch@infradead.org> writes:

> On Sat, Apr 23, 2016 at 06:08:37PM +0000, Verma, Vishal L wrote:
>> direct_IO might fail with -EINVAL due to misalignment, or -ENOMEM due
>> to some allocation failing, and I thought we should return the original
>> -EIO in such cases so that the application doesn't lose the information
>> that the bad block is actually causing the error.
>
> EINVAL is a concern here.  Not due to the right error reported, but
> because it means your current scheme is fundamentally broken - we
> need to support I/O at any alignment for DAX I/O, and not fail due to
> alignbment concernes for a highly specific degraded case.
>
> I think this whole series need to go back to the drawing board as I
> don't think it can actually rely on using direct I/O as the EIO
> fallback.

The only callers of dax_do_io are direct_IO methods.

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
