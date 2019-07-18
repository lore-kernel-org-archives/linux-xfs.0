Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11611 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 19:03:01 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
Date: Thu, 18 Jul 2019 23:02:43 +0000
Message-ID: <BYAPR04MB5816B59932372E2D97330308E7C80@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
 <x49zhlbe8li.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

Jeff,=0A=
=0A=
On 2019/07/18 23:11, Jeff Moyer wrote:=0A=
> Hi, Damien,=0A=
> =0A=
> Did you consider creating a shared library?  I bet that would also=0A=
> ease application adoption for the use cases you're interested in, and=0A=
> would have similar performance.=0A=
> =0A=
> -Jeff=0A=
=0A=
Yes, it would, but to a lesser extent since system calls would need to be=
=0A=
replaced with library calls. Earlier work on LevelDB by Ting used the libra=
ry=0A=
approach with libzbc, not quite a "libzonefs" but close enough. Working wit=
h=0A=
LevelDB code gave me the idea for zonefs. Compared to a library, the added=
=0A=
benefits are that specific language bindings are not a problem and further=
=0A=
simplify the code changes needed to support zoned block devices. In the cas=
e of=0A=
LevelDB for instance, C++ is used and file accesses are using streams, whic=
h=0A=
makes using a library a little difficult, and necessitates more changes jus=
t for=0A=
the internal application API itself. The needed changes spread beyond the d=
evice=0A=
access API.=0A=
=0A=
This is I think the main advantage of this simple in-kernel FS over a libra=
ry:=0A=
the developer can focus on zone block device specific needs (write sequenti=
al=0A=
pattern and garbage collection) and forget about the device access parts as=
 the=0A=
standard system calls API can be used.=0A=
=0A=
Another approach I considered is using FUSE, but went for a regular (albeit=
=0A=
simple) in-kernel approach due to performance concerns. While any differenc=
e in=0A=
performance for SMR HDDs would probably not be noticeable, performance woul=
d=0A=
likely be lower for upcoming NVMe zonenamespace devices compared to the=0A=
in-kernel approach.=0A=
=0A=
But granted, most of the arguments I can put forward for an in-kernel FS=0A=
solution vs a user shared library solution are mostly subjective. I think t=
hough=0A=
that having support directly provided by the kernel brings zoned block devi=
ces=0A=
into the "mainstream storage options" rather than having them perceived as=
=0A=
fringe solutions that need additional libraries to work correctly. Zoned bl=
ock=0A=
devices are not going away and may in fact become more mainstream as=0A=
implementing higher capacities more and more depends on the sequential writ=
e=0A=
interface.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
