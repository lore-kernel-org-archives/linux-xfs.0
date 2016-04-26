Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC1A27CE7
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 12:16:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2CCFDAC002
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 10:16:29 -0700 (PDT)
Received: from mail-ob0-f172.google.com (mail-ob0-f172.google.com
	[209.85.214.172]) by cuda.sgi.com with ESMTP id
	VIb1m5c6XZQC0AtI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Apr 2016 10:16:23 -0700 (PDT)
Received: by mail-ob0-f172.google.com with SMTP id bg3so10217840obb.1
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 10:16:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160426153118.GI27612@quack2.suse.cz>
References: <20160425083114.GA27556@infradead.org>
	<1461604476.3106.12.camel@intel.com>
	<20160425232552.GD18496@dastard>
	<CAPcyv4i6iwm1iY2mQ5yRbYfRexQroUX_R0B-db4ROU837fratw@mail.gmail.com>
	<20160426001157.GE18496@dastard>
	<CAPcyv4i0qnCrzsTQT-v84OhnhjmVBFJ8gKoyu6XkuUwH0babfQ@mail.gmail.com>
	<20160426025645.GG18496@dastard>
	<CAPcyv4hg6O3nvD7aXuFm_GAB-1GJxqfNn=RZswj47COa9bVygA@mail.gmail.com>
	<20160426082711.GC26977@dastard>
	<CAPcyv4h19Cp93f+vQXapnmXLEXHE2RZGyQVo7dCnAqcmnW1GEg@mail.gmail.com>
	<20160426153118.GI27612@quack2.suse.cz>
Date: Tue, 26 Apr 2016 10:16:22 -0700
Message-ID: <CAPcyv4ghC3YCeZJ4UuSGjVLJ-9gmopZrkrdzZPgdJ5H9rH3fTA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jan Kara <jack@suse.cz>
Cc: "axboe@fb.com" <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "Verma,
	Vishal L" <vishal.l.verma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

On Tue, Apr 26, 2016 at 8:31 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 26-04-16 07:59:10, Dan Williams wrote:
>> On Tue, Apr 26, 2016 at 1:27 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, Apr 25, 2016 at 09:18:42PM -0700, Dan Williams wrote:
>> [..]
>> > It seems to me you are focussing on code/technologies that exist
>> > today instead of trying to define an architecture that is more
>> > optimal for pmem storage systems. Yes, working code is great, but if
>> > you can't tell people how things like robust error handling and
>> > redundancy are going to work in future then it's going to take
>> > forever for everyone else to handle such errors robustly through the
>> > storage stack...
>>
>> Precisely because higher order redundancy is built on top this baseline.
>>
>> MD-RAID can't do it's error recovery if we don't have -EIO and
>> clear-error-on-write.  On the other hand, you're absolutely right that
>> we have a gaping hole on top of the SIGBUS recovery model, and don't
>> have a kernel layer we can interpose on top of DAX to provide some
>> semblance of redundancy.
>>
>> In the meantime, a handful of applications with a team of full-time
>> site-reliability-engineers may be able to plug in external redundancy
>> infrastructure on top of what is defined in these patches.  For
>> everyone else, the hard problem, we need to do a lot more thinking
>> about a trap and recover solution.
>
> So we could actually implement some kind of redundancy with DAX with
> reasonable effort. We already do track dirty storage PFNs in the radix
> tree. After DAX locking patches get merged we also have a reliable way to
> write-protect them when we decide to do 'writeback' (translates to flushing
> CPU caches) for them. When we do that, we have all the infrastructure in
> place to provide 'stable pages' while some mirroring or other redundancy
> mechanism in kernel works with the data.
>
> But as Dave said, we should do some writeup of how this is all supposed to
> work and e.g. which layer is going to be responsible for the redundancy. Do
> we want to have that in DAX code? Or just provide stable page guarantees
> from DAX and do the redundancy from device mapper? This needs more
> thought...
>

[ adding Mike, since his ears are likely burning by this point ]

If we had the ability to specify a range or list of ranges to
blkdev_issue_flush() that would allow the driver level to implement
redundancy at sync time.  And no, before someone flies off the handle,
this isn't rehashing the same argument I lost about where to track
dirty pfns.  Rather this relies on the radix to track dirty pfns, but
asks the driver to do the flush operation.  In the nominal case this
is a clflush / clwb loop or wbinvd in the pmem driver, in the
redundancy case the pmem driver is swapped out for a driver that uses
the flush request as a trigger point to synchronize redundant data.

We want this at the driver level to take advantage of standard
asynchronous completions, and make it administratively equivalent to
the dm/md layering people are used to using.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
