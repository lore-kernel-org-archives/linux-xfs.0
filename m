Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39966 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbfGPQvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jul 2019 12:51:25 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so10398117pla.7
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 09:51:24 -0700 (PDT)
Message-ID: <1563295882.2741.49.camel@dubeyko.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
From: Viacheslav Dubeyko <slava@dubeyko.com>
Date: Tue, 16 Jul 2019 09:51:22 -0700
In-Reply-To: <BYAPR04MB58168662947D0573419EAD0FE7CF0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
         <1562951415.2741.18.camel@dubeyko.com>
         <BYAPR04MB5816F3DE20A3C82B82192B94E7F20@BYAPR04MB5816.namprd04.prod.outlook.com>
         <1563209654.2741.39.camel@dubeyko.com>
         <BYAPR04MB58168662947D0573419EAD0FE7CF0@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

On Mon, 2019-07-15 at 23:53 +0000, Damien Le Moal wrote:
> On 2019/07/16 1:54, Viacheslav Dubeyko wrote:
> [...]
> > 
> > > 
> > > > 
> > > > Do you have in mind some special use-case?
> > > As the commit message mentions, zonefs is not a traditional file
> > > system by any
> > > mean and much closer to a raw block device access interface than
> > > anything else.
> > > This is the entire point of this exercise: allow replacing the
> > > raw
> > > block device
> > > accesses with the easier to use file system API. Raw block device
> > > access is also
> > > file API so one could argue that this is nonsense. What I mean
> > > here
> > > is that by
> > > abstracting zones with files, the user does not need to do the
> > > zone
> > > configuration discovery with ioctl(BLKREPORTZONES), does not need
> > > to
> > > do explicit
> > > zone resets with ioctl(BLKRESETZONE), does not have to "start
> > > from
> > > one sector
> > > and write sequentially from there" management for write() calls
> > > (i.e.
> > > seeks),
> > > etc. This is all replaced with the file abstraction: directory
> > > entry
> > > list
> > > replace zone information, truncate() replace zone reset, file
> > > current
> > > position
> > > replaces the application zone write pointer management.
> > > 
> > > This simplifies implementing support of applications for zoned
> > > block
> > > devices,
> > > but only in cases where said applications:
> > > 1) Operate with large files
> > > 2) have no or only minimal need for random writes
> > > 
> > > A perfect match for this as mentioned in the commit message are
> > > LSM-
> > > tree based
> > > applications such as LevelDB or RocksDB. Other examples, related,
> > > include
> > > Bluestore distributed object store which uses RocksDB but still
> > > has a
> > > bluefs
> > > layer that could be replaced with zonefs.
> > > 
> > > As an illustration of this, Ting Yao of Huazhong University of
> > > Science and
> > > Technology (China) and her team modified LevelDB to work with
> > > zonefs.
> > > The early
> > > prototype code is on github here: https://github.com/PDS-Lab/Gear
> > > DB/t
> > > ree/zonefs
> > > 
> > > LSM-Tree applications typically operate on large files, in the
> > > same
> > > range as
> > > zoned block device zone size (e.g. 256 MB or so). While this is
> > > generally a
> > > parameter that can be changed, the use of zonefs and zoned block
> > > device forces
> > > using the zone size as the SSTable file maximum size. This can
> > > have
> > > an impact on
> > > the DB performance depending on the device type, but that is
> > > another
> > > discussion.
> > > The point here is the code simplifications that zonefs allows.
> > > 
> > > For more general purpose use cases (small files, lots of random
> > > modifications),
> > > we already have the dm-zoned device mapper and f2fs support and
> > > we
> > > are also
> > > currently working on btrfs support. These solutions are in my
> > > opinion
> > > more
> > > appropriate than zonefs to address the points you raised.
> > > 
> > Sounds pretty reasonable. But I still have two worries.
> > 
> > First of all, even modest file system could contain about 100K
> > files on
> > a volume. So, if our zone is 256 MB then we need in 24 TB storage
> > device for 100K files. Even if we consider some special use-case of
> > database, for example, then it's pretty easy to imagine the
> > creation a
> > lot of files. So, are we ready to provide such huge storage devices
> > (especially, for the case of SSDs)?
> The small file use case you are describing is not zonefs target use
> case. It
> does not make any sense to discuss small files in the context of
> zonefs. If
> small file is the use case needed for an application, then a "normal"
> file
> system should be use such as f2fs or btrfs (zoned block device
> support is being
> worked on, see patches posted on btrfs list).
> 
> As mentioned previously, zonefs goal is to represent zones of a zoned
> block
> device with files, thus providing a simple abstraction one file ==
> one zone and
> simplifying application implementation. And this means that the only
> sensible
> use case for zonefs is applications using large container like files.
> LSM-tree
> based applications being a very good match in this respect.
> 


I am talking not about file size but about number of files on the
volume here. I meant that file system could easily contain about
100,000 files on the volume. So, if every file uses 256 MB zone then
100,000 files need in 24 TB volume.


> > 
> > Secondly, the allocation scheme is too simplified for my taste and
> > it
> > could create a significant fragmentation of a volume. Again, 256 MB
> > is
> > pretty big size. So, I assume that, mostly, it will be allocated
> > only
> > one zone at first for a created file. If file grows then it means
> > that
> > it will need to allocate the two contigous zones and to move the
> > file's
> > content. Finally, it sounds for me that it is possible to create a
> > lot
> > of holes and to achieve the volume state when it exists a lot of
> > free
> > space but files will be unable to grow and it will be impossible to
> > add
> > a new data on the volume. Have you made an estimation of the
> > suggested
> > allocation scheme?
> What do you mean allocation scheme ? There is none ! one file == one
> zone and
> all files are fully provisioned and allocated on mount. zonefs does
> not allow
> the creation of files and there is no dynamic "block allocation".
> Again, please
> do not consider zonefs as a normal file system. It is closer to a raw
> block
> device interface than to a fully featured file system.
> 

OK. It sounds that a file cannot grow beyond the allocated number of
contigous zone(s) during the mount operation. Am I correct? But if a
file is needed to be resized what can be done in such case? Should it
need to re-mount the file system?

By the way, does this approach provides the way to use the device's
internal parallelism? What should anybody take into account for
exploiting the device's internal parallelism?

Thanks,
Viacheslav Dubeyko.
