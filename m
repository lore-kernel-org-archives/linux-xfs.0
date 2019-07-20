Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:53556 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfGTHPc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jul 2019 03:15:32 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
Date: Sat, 20 Jul 2019 07:15:26 +0000
Message-ID: <BYAPR04MB58164A7ACFD3B6331404ECA3E7CA0@BYAPR04MB5816.namprd04.prod.outlook.com>
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

Jeff,=0A=
=0A=
On 2019/07/19 23:25, Jeff Moyer wrote:=0A=
> OK, I can see how a file system eases adoption across multiple=0A=
> languages, and may, in some cases, be easier to adopt by applications.=0A=
> However, I'm not a fan of the file system interface for this usage.=0A=
> Once you present a file system, there are certain expectations from=0A=
> users, and this fs breaks most of them.=0A=
=0A=
Your comments got me thinking more about zonefs specifications/features and=
 I am=0A=
now wondering if I am not pushing this too far in terms of simplicity. So h=
ere=0A=
is a new RFC/Question to chew on... While keeping as a target the concept o=
f=0A=
"file =3D=3D zone" or as close to it as possible, what do you think zonefs =
minimal=0A=
feature set should be ?=0A=
=0A=
One idea I have since a while back now is this:=0A=
1) If a zone is unused, do not show a file for it. This means adding a dyna=
mic=0A=
"zone allocation" code and supporting O_CREAT on open, unlink, etc. So have=
 more=0A=
normal file system calls behave as with a normal FS.=0A=
2) Allow file names to be decided by the user instead of using a fixed name=
s.=0A=
Again, have O_CREAT behave as expected=0A=
3) Potentially allow files to grow beyond a single zone, while keeping the =
space=0A=
allocation unit as a zone.=0A=
=0A=
Thinking of our current LevelDB/RocksDB use cases, (1) and (2) would allow =
even=0A=
further simplifying the support code since with these, the SSTable file=0A=
management can essentially stay completely untouched.=0A=
=0A=
(3) is not necessary for LSM-Tree type use cases since typically zones are =
large=0A=
and so aligning SSTables to zones the most efficient approach. However, I c=
an=0A=
see other use cases that would benefit from (3). One example would be=0A=
Surveillance system video recording or any system dealing with high bitrate=
=0A=
Video. E.g. A 256 MB zone size is only 100s of high definition broadcasting=
 (20=0A=
Mbps or so). SO managing storage space in such big chunks is OK with such u=
se cases.=0A=
=0A=
These 3 additional features would make zonefs much closer to a regular FS=
=0A=
behavior while keeping its IO path simple enough to be in par with fast raw=
=0A=
block device accesses. Additional metadata management, completely absent fo=
r=0A=
now, would be needed though. But by not allowing directories (flat namespac=
e),=0A=
this metadata management would be reduced to an inode table and a bitmap fo=
r=0A=
zone use management. Anything beyond these features and I think we would be=
=0A=
better off with a regular file system.=0A=
=0A=
Thoughts ?=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
