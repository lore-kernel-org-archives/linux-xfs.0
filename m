Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4AF5B7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 10:15:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19FD6304032
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 08:15:40 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com
	[209.85.218.49]) by cuda.sgi.com with ESMTP id KdrVGdIVUzFUhkti
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 May 2016 08:15:33 -0700 (PDT)
Received: by mail-oi0-f49.google.com with SMTP id k142so106005739oib.1
	for <xfs@oss.sgi.com>; Thu, 05 May 2016 08:15:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160505142433.GA4557@infradead.org>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
	<5727753F.6090104@plexistor.com>
	<20160505142433.GA4557@infradead.org>
Date: Thu, 5 May 2016 08:15:32 -0700
Message-ID: <CAPcyv4gdmo5m=Arf5sp5izJfNaaAkaaMbOzud8KRcBEC8RRu1Q@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <axboe@fb.com>, linux-nvdimm <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Thu, May 5, 2016 at 7:24 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, May 02, 2016 at 06:41:51PM +0300, Boaz Harrosh wrote:
>> > All IO in a dax filesystem used to go through dax_do_io, which cannot
>> > handle media errors, and thus cannot provide a recovery path that can
>> > send a write through the driver to clear errors.
>> >
>> > Add a new iocb flag for DAX, and set it only for DAX mounts. In the IO
>> > path for DAX filesystems, use the same direct_IO path for both DAX and
>> > direct_io iocbs, but use the flags to identify when we are in O_DIRECT
>> > mode vs non O_DIRECT with DAX, and for O_DIRECT, use the conventional
>> > direct_IO path instead of DAX.
>> >
>>
>> Really? What are your thinking here?
>>
>> What about all the current users of O_DIRECT, you have just made them
>> 4 times slower and "less concurrent*" then "buffred io" users. Since
>> direct_IO path will queue an IO request and all.
>> (And if it is not so slow then why do we need dax_do_io at all? [Rhetorical])
>>
>> I hate it that you overload the semantics of a known and expected
>> O_DIRECT flag, for special pmem quirks. This is an incompatible
>> and unrelated overload of the semantics of O_DIRECT.
>
> Agreed - makig O_DIRECT less direct than not having it is plain stupid,
> and I somehow missed this initially.

Of course I disagree because like Dave argues in the msync case we
should do the correct thing first and make it fast later, but also
like Dave this arguing in circles is getting tiresome.

> This whole DAX story turns into a major nightmare, and I fear all our
> hodge podge tweaks to the semantics aren't helping it.
>
> It seems like we simply need an explicit O_DAX for the read/write
> bypass if can't sort out the semantics (error, writer synchronization)
> just as we need a special flag for MMAP.

I don't see how O_DAX makes this situation better if the goal is to
accelerate unmodified applications...

Vishal, at least the "delete a file with a badblock" model will still
work for implicitly clearing errors with your changes to stop doing
block clearing in fs/dax.c.  This combined with a new -EBADBLOCK (as
Dave suggests) and explicit logging of I/Os that fail for this reason
at least gives a chance to communicate errors in files to suitably
aware applications / environments.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
