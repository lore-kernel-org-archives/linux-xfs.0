Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbfGSOZb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jul 2019 10:25:31 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
        <x49zhlbe8li.fsf@segfault.boston.devel.redhat.com>
        <BYAPR04MB5816B59932372E2D97330308E7C80@BYAPR04MB5816.namprd04.prod.outlook.com>
Date: Fri, 19 Jul 2019 10:25:28 -0400
In-Reply-To: <BYAPR04MB5816B59932372E2D97330308E7C80@BYAPR04MB5816.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Thu, 18 Jul 2019 23:02:43 +0000")
Message-ID: <x49h87iqexz.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

Hi, Damien,

Thanks for your well-considered response.

Damien Le Moal <Damien.LeMoal@wdc.com> writes:

> Jeff,
>
> On 2019/07/18 23:11, Jeff Moyer wrote:
>> Hi, Damien,
>> 
>> Did you consider creating a shared library?  I bet that would also
>> ease application adoption for the use cases you're interested in, and
>> would have similar performance.
>> 
>> -Jeff
>
> Yes, it would, but to a lesser extent since system calls would need to be
> replaced with library calls. Earlier work on LevelDB by Ting used the library
> approach with libzbc, not quite a "libzonefs" but close enough. Working with
> LevelDB code gave me the idea for zonefs. Compared to a library, the added
> benefits are that specific language bindings are not a problem and further
> simplify the code changes needed to support zoned block devices. In the case of
> LevelDB for instance, C++ is used and file accesses are using streams, which
> makes using a library a little difficult, and necessitates more changes just for
> the internal application API itself. The needed changes spread beyond the device
> access API.
>
> This is I think the main advantage of this simple in-kernel FS over a library:
> the developer can focus on zone block device specific needs (write sequential
> pattern and garbage collection) and forget about the device access parts as the
> standard system calls API can be used.

OK, I can see how a file system eases adoption across multiple
languages, and may, in some cases, be easier to adopt by applications.
However, I'm not a fan of the file system interface for this usage.
Once you present a file system, there are certain expectations from
users, and this fs breaks most of them.

I'll throw out another suggestion that may or may not work (I haven't
given it much thought).  Would it be possible to create a device mapper
target that would export each zone as a separate block device?  I
understand that wouldn't help with the write pointer management, but it
would allow you to create a single "file" for each zone.

> Another approach I considered is using FUSE, but went for a regular (albeit
> simple) in-kernel approach due to performance concerns. While any difference in
> performance for SMR HDDs would probably not be noticeable, performance would
> likely be lower for upcoming NVMe zonenamespace devices compared to the
> in-kernel approach.
>
> But granted, most of the arguments I can put forward for an in-kernel FS
> solution vs a user shared library solution are mostly subjective. I think though
> that having support directly provided by the kernel brings zoned block devices
> into the "mainstream storage options" rather than having them perceived as
> fringe solutions that need additional libraries to work correctly. Zoned block
> devices are not going away and may in fact become more mainstream as
> implementing higher capacities more and more depends on the sequential write
> interface.

A file system like this would further cement in my mind that zoned block
devices are not maintstream storage options.  I guess this part is
highly subjective.  :)

Cheers,
Jeff
