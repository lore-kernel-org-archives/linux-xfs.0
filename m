Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37913 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729533AbfGOQyR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 12:54:17 -0400
Received: by mail-pg1-f196.google.com with SMTP id z75so7993138pgz.5
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2019 09:54:16 -0700 (PDT)
Message-ID: <1563209654.2741.39.camel@dubeyko.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
From: Viacheslav Dubeyko <slava@dubeyko.com>
Date: Mon, 15 Jul 2019 09:54:14 -0700
In-Reply-To: <BYAPR04MB5816F3DE20A3C82B82192B94E7F20@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
         <1562951415.2741.18.camel@dubeyko.com>
         <BYAPR04MB5816F3DE20A3C82B82192B94E7F20@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

On Fri, 2019-07-12 at 22:56 +0000, Damien Le Moal wrote:
> On 2019/07/13 2:10, Viacheslav Dubeyko wrote:
> > 
> > On Fri, 2019-07-12 at 12:00 +0900, Damien Le Moal wrote:
> > > 
> > > zonefs is a very simple file system exposing each zone of a zoned
> > > block device as a file. This is intended to simplify
> > > implementation 
> > As far as I can see, a zone usually is pretty big in size (for
> > example,
> > 256MB). But [1, 2] showed that about 60% of files on a file system
> > volume has size about 4KB - 128KB. Also [3] showed that modern
> > application uses a very complex files' structures that are updated
> > in
> > random order. Moreover, [4] showed that 90% of all files are not
> > used
> > after initial creation, those that are used are normally short-
> > lived,
> > and that if a file is not used in some manner the day after it is
> > created, it will probably never be used; 1% of all files are used
> > daily.
> > 
> > It sounds for me that mostly this approach will lead to waste of
> > zones'
> > space. Also, the necessity to update data of the same file will be
> > resulted in frequent moving of files' data from one zone to another
> > one. If we are talking about SSDs then it sounds like quick and
> > easy
> > way to kill this device fast.
> > 
> > Do you have in mind some special use-case?
> As the commit message mentions, zonefs is not a traditional file
> system by any
> mean and much closer to a raw block device access interface than
> anything else.
> This is the entire point of this exercise: allow replacing the raw
> block device
> accesses with the easier to use file system API. Raw block device
> access is also
> file API so one could argue that this is nonsense. What I mean here
> is that by
> abstracting zones with files, the user does not need to do the zone
> configuration discovery with ioctl(BLKREPORTZONES), does not need to
> do explicit
> zone resets with ioctl(BLKRESETZONE), does not have to "start from
> one sector
> and write sequentially from there" management for write() calls (i.e.
> seeks),
> etc. This is all replaced with the file abstraction: directory entry
> list
> replace zone information, truncate() replace zone reset, file current
> position
> replaces the application zone write pointer management.
> 
> This simplifies implementing support of applications for zoned block
> devices,
> but only in cases where said applications:
> 1) Operate with large files
> 2) have no or only minimal need for random writes
> 
> A perfect match for this as mentioned in the commit message are LSM-
> tree based
> applications such as LevelDB or RocksDB. Other examples, related,
> include
> Bluestore distributed object store which uses RocksDB but still has a
> bluefs
> layer that could be replaced with zonefs.
> 
> As an illustration of this, Ting Yao of Huazhong University of
> Science and
> Technology (China) and her team modified LevelDB to work with zonefs.
> The early
> prototype code is on github here: https://github.com/PDS-Lab/GearDB/t
> ree/zonefs
> 
> LSM-Tree applications typically operate on large files, in the same
> range as
> zoned block device zone size (e.g. 256 MB or so). While this is
> generally a
> parameter that can be changed, the use of zonefs and zoned block
> device forces
> using the zone size as the SSTable file maximum size. This can have
> an impact on
> the DB performance depending on the device type, but that is another
> discussion.
> The point here is the code simplifications that zonefs allows.
> 
> For more general purpose use cases (small files, lots of random
> modifications),
> we already have the dm-zoned device mapper and f2fs support and we
> are also
> currently working on btrfs support. These solutions are in my opinion
> more
> appropriate than zonefs to address the points you raised.
> 

Sounds pretty reasonable. But I still have two worries.

First of all, even modest file system could contain about 100K files on
a volume. So, if our zone is 256 MB then we need in 24 TB storage
device for 100K files. Even if we consider some special use-case of
database, for example, then it's pretty easy to imagine the creation a
lot of files. So, are we ready to provide such huge storage devices
(especially, for the case of SSDs)?

Secondly, the allocation scheme is too simplified for my taste and it
could create a significant fragmentation of a volume. Again, 256 MB is
pretty big size. So, I assume that, mostly, it will be allocated only
one zone at first for a created file. If file grows then it means that
it will need to allocate the two contigous zones and to move the file's
content. Finally, it sounds for me that it is possible to create a lot
of holes and to achieve the volume state when it exists a lot of free
space but files will be unable to grow and it will be impossible to add
a new data on the volume. Have you made an estimation of the suggested
allocation scheme?

Thanks,
Viacheslav Dubeyko.
