Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63643 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbfGRA5W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 20:57:22 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
Date: Thu, 18 Jul 2019 00:57:19 +0000
Message-ID: <BYAPR04MB5816F5F607F5061AD53499F5E7C80@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
 <1562951415.2741.18.camel@dubeyko.com>
 <BYAPR04MB5816F3DE20A3C82B82192B94E7F20@BYAPR04MB5816.namprd04.prod.outlook.com>
 <1563209654.2741.39.camel@dubeyko.com>
 <BYAPR04MB58168662947D0573419EAD0FE7CF0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <1563295882.2741.49.camel@dubeyko.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Viacheslav Dubeyko <slava@dubeyko.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

Slava,=0A=
=0A=
On 2019/07/17 1:51, Viacheslav Dubeyko wrote:=0A=
>> As mentioned previously, zonefs goal is to represent zones of a zoned=0A=
>> block=0A=
>> device with files, thus providing a simple abstraction one file =3D=3D=
=0A=
>> one zone and=0A=
>> simplifying application implementation. And this means that the only=0A=
>> sensible=0A=
>> use case for zonefs is applications using large container like files.=0A=
>> LSM-tree=0A=
>> based applications being a very good match in this respect.=0A=
>>=0A=
> =0A=
> =0A=
> I am talking not about file size but about number of files on the=0A=
> volume here. I meant that file system could easily contain about=0A=
> 100,000 files on the volume. So, if every file uses 256 MB zone then=0A=
> 100,000 files need in 24 TB volume.=0A=
=0A=
zonefs provides a different representation of the raw device. It is not=0A=
abstracting it. One file is one zone. So if the use case needs more files, =
then=0A=
another device model must be used (higher capacity or smaller zone size). I=
t is=0A=
as simple as that.=0A=
=0A=
>> What do you mean allocation scheme ? There is none ! one file =3D=3D one=
=0A=
>> zone and=0A=
>> all files are fully provisioned and allocated on mount. zonefs does=0A=
>> not allow=0A=
>> the creation of files and there is no dynamic "block allocation".=0A=
>> Again, please=0A=
>> do not consider zonefs as a normal file system. It is closer to a raw=0A=
>> block=0A=
>> device interface than to a fully featured file system.=0A=
>>=0A=
> =0A=
> OK. It sounds that a file cannot grow beyond the allocated number of=0A=
> contigous zone(s) during the mount operation. Am I correct? But if a=0A=
> file is needed to be resized what can be done in such case? Should it=0A=
> need to re-mount the file system?=0A=
=0A=
In the case of sequential zone files, one file always represents a single z=
one.=0A=
In the case of conventional zones, the default behavior is the same, and=0A=
optionally one file can be a set of contiguous conventional zones. And a re=
mount=0A=
can switch between one conventional zone per file or aggregated conventiona=
l=0A=
zones files. Conventional zone files have a fixed size set to the zone size=
.=0A=
These files cannot be truncated. For sequential zone files, only truncation=
 to 0=0A=
is possible. That is equivalent to doing a zone reset.=0A=
=0A=
A remount will not allow resizing the maximum size of files because that is=
=0A=
determine by the device zone size, which is fixed and cannot be changed.=0A=
=0A=
> By the way, does this approach provides the way to use the device's=0A=
> internal parallelism? What should anybody take into account for=0A=
> exploiting the device's internal parallelism?=0A=
=0A=
zonefs uses the standard BIO interface which does not have any provision fo=
r=0A=
exposing HW specific parallel resources. So no, there is no such feature=0A=
implemented. Zoned block devices are for now SMR HDDs only anyway, and HDDs=
 are=0A=
have no parallelism.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
