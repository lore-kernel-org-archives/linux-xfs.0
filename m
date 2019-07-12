Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8375 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbfGLW47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jul 2019 18:56:59 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
Date: Fri, 12 Jul 2019 22:56:55 +0000
Message-ID: <BYAPR04MB5816F3DE20A3C82B82192B94E7F20@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
 <1562951415.2741.18.camel@dubeyko.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Viacheslav Dubeyko <slava@dubeyko.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

On 2019/07/13 2:10, Viacheslav Dubeyko wrote:=0A=
> On Fri, 2019-07-12 at 12:00 +0900, Damien Le Moal wrote:=0A=
>> zonefs is a very simple file system exposing each zone of a zoned=0A=
>> block device as a file. This is intended to simplify implementation =0A=
> =0A=
> As far as I can see, a zone usually is pretty big in size (for example,=
=0A=
> 256MB). But [1, 2] showed that about 60% of files on a file system=0A=
> volume has size about 4KB - 128KB. Also [3] showed that modern=0A=
> application uses a very complex files' structures that are updated in=0A=
> random order. Moreover, [4] showed that=A090% of all files are not used=
=0A=
> after initial creation, those that are used are normally short-lived,=0A=
> and that if a file is not used in some manner the day after it is=0A=
> created, it will probably never be used; 1% of all files are used=0A=
> daily.=0A=
> =0A=
> It sounds for me that mostly this approach will lead to waste of zones'=
=0A=
> space. Also, the necessity to update data of the same file will be=0A=
> resulted in frequent moving of files' data from one zone to another=0A=
> one. If we are talking about SSDs then it sounds like quick and easy=0A=
> way to kill this device fast.=0A=
> =0A=
> Do you have in mind some special use-case?=0A=
=0A=
As the commit message mentions, zonefs is not a traditional file system by =
any=0A=
mean and much closer to a raw block device access interface than anything e=
lse.=0A=
This is the entire point of this exercise: allow replacing the raw block de=
vice=0A=
accesses with the easier to use file system API. Raw block device access is=
 also=0A=
file API so one could argue that this is nonsense. What I mean here is that=
 by=0A=
abstracting zones with files, the user does not need to do the zone=0A=
configuration discovery with ioctl(BLKREPORTZONES), does not need to do exp=
licit=0A=
zone resets with ioctl(BLKRESETZONE), does not have to "start from one sect=
or=0A=
and write sequentially from there" management for write() calls (i.e. seeks=
),=0A=
etc. This is all replaced with the file abstraction: directory entry list=
=0A=
replace zone information, truncate() replace zone reset, file current posit=
ion=0A=
replaces the application zone write pointer management.=0A=
=0A=
This simplifies implementing support of applications for zoned block device=
s,=0A=
but only in cases where said applications:=0A=
1) Operate with large files=0A=
2) have no or only minimal need for random writes=0A=
=0A=
A perfect match for this as mentioned in the commit message are LSM-tree ba=
sed=0A=
applications such as LevelDB or RocksDB. Other examples, related, include=
=0A=
Bluestore distributed object store which uses RocksDB but still has a bluef=
s=0A=
layer that could be replaced with zonefs.=0A=
=0A=
As an illustration of this, Ting Yao of Huazhong University of Science and=
=0A=
Technology (China) and her team modified LevelDB to work with zonefs. The e=
arly=0A=
prototype code is on github here: https://github.com/PDS-Lab/GearDB/tree/zo=
nefs=0A=
=0A=
LSM-Tree applications typically operate on large files, in the same range a=
s=0A=
zoned block device zone size (e.g. 256 MB or so). While this is generally a=
=0A=
parameter that can be changed, the use of zonefs and zoned block device for=
ces=0A=
using the zone size as the SSTable file maximum size. This can have an impa=
ct on=0A=
the DB performance depending on the device type, but that is another discus=
sion.=0A=
The point here is the code simplifications that zonefs allows.=0A=
=0A=
For more general purpose use cases (small files, lots of random modificatio=
ns),=0A=
we already have the dm-zoned device mapper and f2fs support and we are also=
=0A=
currently working on btrfs support. These solutions are in my opinion more=
=0A=
appropriate than zonefs to address the points you raised.=0A=
=0A=
Best regards.=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
