Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:3831 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729229AbfGTBHa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jul 2019 21:07:30 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
Date: Sat, 20 Jul 2019 01:07:25 +0000
Message-ID: <BYAPR04MB5816A2630B1EBC0696CBEC71E7CA0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
 <x49zhlbe8li.fsf@segfault.boston.devel.redhat.com>
 <BYAPR04MB5816B59932372E2D97330308E7C80@BYAPR04MB5816.namprd04.prod.outlook.com>
 <x49h87iqexz.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

On 2019/07/19 23:25, Jeff Moyer wrote:=0A=
> Hi, Damien,=0A=
> =0A=
> Thanks for your well-considered response.=0A=
> =0A=
> Damien Le Moal <Damien.LeMoal@wdc.com> writes:=0A=
> =0A=
>> Jeff,=0A=
>>=0A=
>> On 2019/07/18 23:11, Jeff Moyer wrote:=0A=
>>> Hi, Damien,=0A=
>>>=0A=
>>> Did you consider creating a shared library?  I bet that would also=0A=
>>> ease application adoption for the use cases you're interested in, and=
=0A=
>>> would have similar performance.=0A=
>>>=0A=
>>> -Jeff=0A=
>>=0A=
>> Yes, it would, but to a lesser extent since system calls would need to b=
e=0A=
>> replaced with library calls. Earlier work on LevelDB by Ting used the li=
brary=0A=
>> approach with libzbc, not quite a "libzonefs" but close enough. Working =
with=0A=
>> LevelDB code gave me the idea for zonefs. Compared to a library, the add=
ed=0A=
>> benefits are that specific language bindings are not a problem and furth=
er=0A=
>> simplify the code changes needed to support zoned block devices. In the =
case of=0A=
>> LevelDB for instance, C++ is used and file accesses are using streams, w=
hich=0A=
>> makes using a library a little difficult, and necessitates more changes =
just for=0A=
>> the internal application API itself. The needed changes spread beyond th=
e device=0A=
>> access API.=0A=
>>=0A=
>> This is I think the main advantage of this simple in-kernel FS over a li=
brary:=0A=
>> the developer can focus on zone block device specific needs (write seque=
ntial=0A=
>> pattern and garbage collection) and forget about the device access parts=
 as the=0A=
>> standard system calls API can be used.=0A=
> =0A=
> OK, I can see how a file system eases adoption across multiple=0A=
> languages, and may, in some cases, be easier to adopt by applications.=0A=
> However, I'm not a fan of the file system interface for this usage.=0A=
> Once you present a file system, there are certain expectations from=0A=
> users, and this fs breaks most of them.=0A=
=0A=
Yes, that is true. zonefs differs significantly from regular file systems. =
But I=0A=
would argue that breaking the users expectation is OK because that would ha=
ppen=0A=
only and only if the user does not understand the hardware it is dealing wi=
th. I=0A=
still get emails regularly about mkfs.ext4 not working with SMR drives :)=
=0A=
In other words, since kernel 4.10 and exposure of HM SRM HDDs as regular bl=
ock=0A=
device files, we already are in a sense breaking legacy user expectations=
=0A=
regarding the devices under device files... So I am not too worried about t=
his=0A=
point.=0A=
=0A=
If zonefs makes it into the kernel, I probably will be getting more emails =
about=0A=
"it does not work !" until SMR drive users out there understand what they a=
re=0A=
dealing with. We are making a serious effort with documenting everything re=
lated=0A=
to zoned block devices. See https://zonedstorage.io. zonefs, if included in=
 the=0A=
kernel, will be part of that documentation effort. Of note is that this=0A=
documentation is external to the kernel, we still need to increase our=0A=
contribution to the kernel docs for zoned block devices. And we will.=0A=
=0A=
> I'll throw out another suggestion that may or may not work (I haven't=0A=
> given it much thought).  Would it be possible to create a device mapper=
=0A=
> target that would export each zone as a separate block device?  I=0A=
> understand that wouldn't help with the write pointer management, but it=
=0A=
> would allow you to create a single "file" for each zone.=0A=
=0A=
Well, I do not think you need a new device mapper for this. dm-linear suppo=
rts=0A=
zoned block devices and will happily allow mapping a single zone and expose=
 a=0A=
block device file for it. My problem with this approach is that SMR drives =
are=0A=
huge, and getting bigger. A 15 TB drive has 55380 zones of 256 MB. Upcoming=
 20=0A=
TB drives have more than 75000 zones. Using dm-linear or any per-zone devic=
e=0A=
mapper target would create a huge resources pressure as the amount of memor=
y=0A=
alone that would be used per zone would be much higher than with a file sys=
tem=0A=
and the setup would also take far longer to complete compared to zonefs mou=
nt.=0A=
=0A=
>> Another approach I considered is using FUSE, but went for a regular (alb=
eit=0A=
>> simple) in-kernel approach due to performance concerns. While any differ=
ence in=0A=
>> performance for SMR HDDs would probably not be noticeable, performance w=
ould=0A=
>> likely be lower for upcoming NVMe zonenamespace devices compared to the=
=0A=
>> in-kernel approach.=0A=
>>=0A=
>> But granted, most of the arguments I can put forward for an in-kernel FS=
=0A=
>> solution vs a user shared library solution are mostly subjective. I thin=
k though=0A=
>> that having support directly provided by the kernel brings zoned block d=
evices=0A=
>> into the "mainstream storage options" rather than having them perceived =
as=0A=
>> fringe solutions that need additional libraries to work correctly. Zoned=
 block=0A=
>> devices are not going away and may in fact become more mainstream as=0A=
>> implementing higher capacities more and more depends on the sequential w=
rite=0A=
>> interface.=0A=
> =0A=
> A file system like this would further cement in my mind that zoned block=
=0A=
> devices are not maintstream storage options.  I guess this part is=0A=
> highly subjective.  :)=0A=
=0A=
Yes, it is subjective :) Many (even large scale) data centers are already=
=0A=
switching to "all SMR" backend storage, relying on traditional block device=
s=0A=
(SSDs mostly) for active data. For these systems, SMR is a mainstream solut=
ion.=0A=
=0A=
When saying "mainstream", I was referring more to the software needed to us=
e=0A=
these drives rather than the drives as a solution. zonefs allows mapping th=
e=0A=
zone sequential write constraint to a known concept: file append write. And=
 in=0A=
this sense, I think we can consider zonefs as progress.=0A=
=0A=
Ideally, I would not bother with this at all and point people to Btrtfs (wo=
rk in=0A=
progress) or XFS (next in the pipeline) for using an FS on zoned block devi=
ces.=0A=
But there is definitely a tendency for many distributed applications to try=
 to=0A=
do without any file system at all (Ceph -> Bluestore is one example). And a=
s=0A=
mentioned before, some other use cases where a fully POSIX compliant file s=
ystem=0A=
is not really necessary at all (LevelDB, RocksDB). zonefs fits in the middl=
e=0A=
ground here between removing the normal file system and going to raw block=
=0A=
device. Bluestore has "bluefs" underneath rocksdb after all. One cannot rea=
lly=0A=
never go directly raw block device and in most cases some level of abstract=
ion=0A=
(space management) is needed. That is where zonefs fits.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
