Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:52460 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731359AbfGOXx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 19:53:26 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
Date: Mon, 15 Jul 2019 23:53:23 +0000
Message-ID: <BYAPR04MB58168662947D0573419EAD0FE7CF0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
 <1562951415.2741.18.camel@dubeyko.com>
 <BYAPR04MB5816F3DE20A3C82B82192B94E7F20@BYAPR04MB5816.namprd04.prod.outlook.com>
 <1563209654.2741.39.camel@dubeyko.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Viacheslav Dubeyko <slava@dubeyko.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

On 2019/07/16 1:54, Viacheslav Dubeyko wrote:=0A=
[...]=0A=
>>> Do you have in mind some special use-case?=0A=
>> As the commit message mentions, zonefs is not a traditional file=0A=
>> system by any=0A=
>> mean and much closer to a raw block device access interface than=0A=
>> anything else.=0A=
>> This is the entire point of this exercise: allow replacing the raw=0A=
>> block device=0A=
>> accesses with the easier to use file system API. Raw block device=0A=
>> access is also=0A=
>> file API so one could argue that this is nonsense. What I mean here=0A=
>> is that by=0A=
>> abstracting zones with files, the user does not need to do the zone=0A=
>> configuration discovery with ioctl(BLKREPORTZONES), does not need to=0A=
>> do explicit=0A=
>> zone resets with ioctl(BLKRESETZONE), does not have to "start from=0A=
>> one sector=0A=
>> and write sequentially from there" management for write() calls (i.e.=0A=
>> seeks),=0A=
>> etc. This is all replaced with the file abstraction: directory entry=0A=
>> list=0A=
>> replace zone information, truncate() replace zone reset, file current=0A=
>> position=0A=
>> replaces the application zone write pointer management.=0A=
>>=0A=
>> This simplifies implementing support of applications for zoned block=0A=
>> devices,=0A=
>> but only in cases where said applications:=0A=
>> 1) Operate with large files=0A=
>> 2) have no or only minimal need for random writes=0A=
>>=0A=
>> A perfect match for this as mentioned in the commit message are LSM-=0A=
>> tree based=0A=
>> applications such as LevelDB or RocksDB. Other examples, related,=0A=
>> include=0A=
>> Bluestore distributed object store which uses RocksDB but still has a=0A=
>> bluefs=0A=
>> layer that could be replaced with zonefs.=0A=
>>=0A=
>> As an illustration of this, Ting Yao of Huazhong University of=0A=
>> Science and=0A=
>> Technology (China) and her team modified LevelDB to work with zonefs.=0A=
>> The early=0A=
>> prototype code is on github here: https://github.com/PDS-Lab/GearDB/t=0A=
>> ree/zonefs=0A=
>>=0A=
>> LSM-Tree applications typically operate on large files, in the same=0A=
>> range as=0A=
>> zoned block device zone size (e.g. 256 MB or so). While this is=0A=
>> generally a=0A=
>> parameter that can be changed, the use of zonefs and zoned block=0A=
>> device forces=0A=
>> using the zone size as the SSTable file maximum size. This can have=0A=
>> an impact on=0A=
>> the DB performance depending on the device type, but that is another=0A=
>> discussion.=0A=
>> The point here is the code simplifications that zonefs allows.=0A=
>>=0A=
>> For more general purpose use cases (small files, lots of random=0A=
>> modifications),=0A=
>> we already have the dm-zoned device mapper and f2fs support and we=0A=
>> are also=0A=
>> currently working on btrfs support. These solutions are in my opinion=0A=
>> more=0A=
>> appropriate than zonefs to address the points you raised.=0A=
>>=0A=
> =0A=
> Sounds pretty reasonable. But I still have two worries.=0A=
> =0A=
> First of all, even modest file system could contain about 100K files on=
=0A=
> a volume. So, if our zone is 256 MB then we need in 24 TB storage=0A=
> device for 100K files. Even if we consider some special use-case of=0A=
> database, for example, then it's pretty easy to imagine the creation a=0A=
> lot of files. So, are we ready to provide such huge storage devices=0A=
> (especially, for the case of SSDs)?=0A=
=0A=
The small file use case you are describing is not zonefs target use case. I=
t=0A=
does not make any sense to discuss small files in the context of zonefs. If=
=0A=
small file is the use case needed for an application, then a "normal" file=
=0A=
system should be use such as f2fs or btrfs (zoned block device support is b=
eing=0A=
worked on, see patches posted on btrfs list).=0A=
=0A=
As mentioned previously, zonefs goal is to represent zones of a zoned block=
=0A=
device with files, thus providing a simple abstraction one file =3D=3D one =
zone and=0A=
simplifying application implementation. And this means that the only sensib=
le=0A=
use case for zonefs is applications using large container like files. LSM-t=
ree=0A=
based applications being a very good match in this respect.=0A=
=0A=
> Secondly, the allocation scheme is too simplified for my taste and it=0A=
> could create a significant fragmentation of a volume. Again, 256 MB is=0A=
> pretty big size. So, I assume that, mostly, it will be allocated only=0A=
> one zone at first for a created file. If file grows then it means that=0A=
> it will need to allocate the two contigous zones and to move the file's=
=0A=
> content. Finally, it sounds for me that it is possible to create a lot=0A=
> of holes and to achieve the volume state when it exists a lot of free=0A=
> space but files will be unable to grow and it will be impossible to add=
=0A=
> a new data on the volume. Have you made an estimation of the suggested=0A=
> allocation scheme?=0A=
=0A=
What do you mean allocation scheme ? There is none ! one file =3D=3D one zo=
ne and=0A=
all files are fully provisioned and allocated on mount. zonefs does not all=
ow=0A=
the creation of files and there is no dynamic "block allocation". Again, pl=
ease=0A=
do not consider zonefs as a normal file system. It is closer to a raw block=
=0A=
device interface than to a fully featured file system.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
