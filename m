Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C18957CDF
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 13:48:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 775A88F8035
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 11:48:18 -0700 (PDT)
Received: from mail-oi0-f52.google.com (mail-oi0-f52.google.com
	[209.85.218.52]) by cuda.sgi.com with ESMTP id f4VKHw7AzqrLoBIX
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 11:48:16 -0700 (PDT)
Received: by mail-oi0-f52.google.com with SMTP id v145so168647299oie.0
	for <xfs@oss.sgi.com>; Mon, 02 May 2016 11:48:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57279D57.5020800@plexistor.com>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
	<5727753F.6090104@plexistor.com>
	<CAPcyv4jWPTDbbw6uMFEEt2Kazgw+wb5Pfwroej--uQPE+AtUbA@mail.gmail.com>
	<57277EDA.9000803@plexistor.com>
	<CAPcyv4jnz69a3S+XZgLaLojHZmpfoVXGDkJkt_1Q=8kk0gik9w@mail.gmail.com>
	<572791E1.7000103@plexistor.com>
	<CAPcyv4hGV07gpADT32xn=3brEq75P4RJA592vp-1A+jXMQCeOQ@mail.gmail.com>
	<57279D57.5020800@plexistor.com>
Date: Mon, 2 May 2016 11:48:15 -0700
Message-ID: <CAPcyv4i3QteM508fVams8DxzoPTo5AXT6RQQ4=gR-iAN-B4-6g@mail.gmail.com>
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
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, Vishal Verma <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Mon, May 2, 2016 at 11:32 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> On 05/02/2016 09:10 PM, Dan Williams wrote:
> <>
>>
>> The semantic I am talking about preserving is:
>>
>> buffered / unaligned write of a bad sector => -EIO on reading into the
>> page cache
>>
>
> What about aligned buffered write? like write 0-to-eof
> This still broken? (and is what restore apps do)
>
>> ...and that the only guaranteed way to clear an error (assuming the
>> block device supports it) is an O_DIRECT write.
>>
>
> Sure fixing dax_do_io will guaranty that.
>
> <>
>> I still think we're talking past each other on this point.
>
> Yes we are!
>
>> This patch
>> set is not overloading error semantics, it's fixing the error handling
>> problem that was introduced in this commit:
>>
>>    d475c6346a38 dax,ext2: replace XIP read and write with DAX I/O
>>
>> ...where we started overloading O_DIRECT and dax_do_io() semantics.
>>
>
> But above does not fix them does it? it just completely NULLs DAX for
> O_DIRECT which is a great pity, why did we do all this work in the first
> place.

This is hyperbole.  We don't impact "all the work" we did for the mmap
I/O case and the acceleration of the non-direct-I/O case.

> And then it keeps broken the aligned buffered writes, which are still
> broken after this set.

...identical to the current situation with a traditional disk.

> I have by now read the v2 patches. And I think you guys did not yet try
> the proper fix for dax_do_io. I think you need to go deeper into the loops
> and selectively call bdev_* when error on a specific page copy. No need to
> go through direct_IO path at all.

We still reach a point where the minimum granularity of
bdev_direct_access() is larger than a sector, so you end up still
needing to have the application understand how to send a properly
aligned I/O.  The semantics of how to send a properly aligned
direct-I/O are already well understood, so we simply reuse that path.

> Do you need that I send you a patch to demonstrate what I mean?

I remain skeptical of what you are proposing, but yes, a patch has a
better chance to move the discussion forward.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
