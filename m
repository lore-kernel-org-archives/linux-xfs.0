Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D72D7CA1
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 13:30:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1E2CAC005
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 11:30:06 -0700 (PDT)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	xUTxfYMY3qahPxjM for <xfs@oss.sgi.com>;
	Tue, 03 May 2016 11:30:05 -0700 (PDT)
From: "Rudoff, Andy" <andy.rudoff@intel.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Tue, 3 May 2016 18:30:04 +0000
Message-ID: <FBB11841-7DFE-4223-9973-3457034260C2@intel.com>
References: <1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
	<1461604476.3106.12.camel@intel.com>
	<20160425232552.GD18496@dastard> <1461628381.1421.24.camel@intel.com>
	<20160426004155.GF18496@dastard>
	<x49pot4ebeb.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4jfUVXoge5D+cBY1Ph=t60165sp6sF_QFZUbFv+cNcdHg@mail.gmail.com>
	<20160503004226.GR26977@dastard>
	<D26BCF92-ED25-4ACA-9CC8-7B1C05A1D5FC@intel.com>
	<20160503024948.GT26977@dastard>
In-Reply-To: <20160503024948.GT26977@dastard>
Content-Language: en-US
Content-ID: <7D8FE82952539F48983E0B1A68FA405B@intel.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>

>
>And when the filesystem says no because the fs devs don't want to
>have to deal with broken apps because app devs learn that "this is a
>go fast knob" and data integrity be damned? It's "fsync is slow so I
>won't use it" all over again...
...
>
>And, please keep in mind: many application developers will not
>design for pmem because they also have to support traditional
>storage backed by page cache. If they use msync(), the app will work
>on any storage stack, but just be much, much faster on pmem+DAX. So,
>really, we have to make the msync()-only model work efficiently, so
>we may as well design for that in the first place....

Both of these snippets seem to be arguing that we should make msync/fsync
more efficient.  But I don't think anyone is arguing the opposite.  Is
someone saying we shouldn't make the msync()-only model work efficiently?

Said another way: the common case for DAX will be applications simply
following the POSIX model.  open, mmap, msync...  That will work fine
and of course we should optimize that path as much as possible.  Less
common are latency-sensitive applications built to leverage to byte-
addressable nature of pmem.  File systems supporting this model will
indicate it using a new ioctl that says doing CPU cache flushes is
sufficient to flush stores to persistence.  But I don't see how that
direction is getting turned into an argument against msync() efficiency.

>Which brings up another point: advanced new functionality
>is going to require native pmem filesystems.

I agree there's opportunity for new filesystems (and old) to leverage
what pmem provides.  But the word "require" implies that's the only
way to go and we know that's not the case.  Using ext4+dax to map
pmem into an application allows that application to use the pmem
directly and a good number of software projects are doing exactly that.

-andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
