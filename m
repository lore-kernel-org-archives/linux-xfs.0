Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E62467CA0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:57:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE9A18F8033
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 10:57:33 -0700 (PDT)
Received: from mail-ob0-f177.google.com (mail-ob0-f177.google.com
	[209.85.214.177]) by cuda.sgi.com with ESMTP id
	kcGRfE3u9K2zrCgJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 10:57:28 -0700 (PDT)
Received: by mail-ob0-f177.google.com with SMTP id tz8so68273370obc.0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 10:57:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460741821.3012.11.camel@intel.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<1460739288.3012.3.camel@intel.com>
	<x49potq6bm2.fsf@segfault.boston.devel.redhat.com>
	<1460741821.3012.11.camel@intel.com>
Date: Fri, 15 Apr 2016 10:57:27 -0700
Message-ID: <CAPcyv4hemNM4uQYCPBXyH+DWTOLvyBNBeMYstKbPdad_Cw48HQ@mail.gmail.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

On Fri, Apr 15, 2016 at 10:37 AM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Fri, 2016-04-15 at 13:11 -0400, Jeff Moyer wrote:
[..]
>> >
>> > But, how does _EIOCBQUEUED work? Maybe we need an exception for it?
>> For async direct I/O, only the setup phase of the I/O is performed
>> and
>> then we return to the caller.  -EIOCBQUEUED signifies this.
>>
>> You're heading towards code that looks like this:
>>
>>         if (IS_DAX(inode)) {
>>                 ret = dax_do_io(iocb, inode, iter, offset,
>> blkdev_get_block,
>>                                 NULL, DIO_SKIP_DIO_COUNT);
>>                 if (ret == -EIO && (iov_iter_rw(iter) == WRITE))
>>                         ret_saved = ret;
>>                 else
>>                         return ret;
>>         }
>>
>>         ret = __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter,
>> offset,
>>                                     blkdev_get_block, NULL, NULL,
>>                                     DIO_SKIP_DIO_COUNT);
>>         if (ret < 0 && ret != -EIOCBQUEUED && ret_saved)
>>                 return ret_saved;
>>
>> There's a lot of special casing here, so you might consider adding
>> comments.
>
> Correct - maybe we should reconsider wrapper-izing this? :)

Another option is just to skip dax_do_io() and this special casing
fallback entirely if errors are present.  I.e. only attempt dax_do_io
when: IS_DAX() && gendisk->bb && bb->count == 0.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
