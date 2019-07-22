Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:5323 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfGVAJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Jul 2019 20:09:25 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
Date: Mon, 22 Jul 2019 00:09:21 +0000
Message-ID: <BYAPR04MB58161B9942C0185E3136062DE7C40@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
 <x49zhlbe8li.fsf@segfault.boston.devel.redhat.com>
 <BYAPR04MB5816B59932372E2D97330308E7C80@BYAPR04MB5816.namprd04.prod.outlook.com>
 <x49h87iqexz.fsf@segfault.boston.devel.redhat.com>
 <BYAPR04MB58164A7ACFD3B6331404ECA3E7CA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20190722000424.GP7689@dread.disaster.area>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

On 2019/07/22 9:05, Dave Chinner wrote:=0A=
> On Sat, Jul 20, 2019 at 07:15:26AM +0000, Damien Le Moal wrote:=0A=
>> Jeff,=0A=
>>=0A=
>> On 2019/07/19 23:25, Jeff Moyer wrote:=0A=
>>> OK, I can see how a file system eases adoption across multiple=0A=
>>> languages, and may, in some cases, be easier to adopt by applications.=
=0A=
>>> However, I'm not a fan of the file system interface for this usage.=0A=
>>> Once you present a file system, there are certain expectations from=0A=
>>> users, and this fs breaks most of them.=0A=
>>=0A=
>> Your comments got me thinking more about zonefs specifications/features =
and I am=0A=
>> now wondering if I am not pushing this too far in terms of simplicity. S=
o here=0A=
>> is a new RFC/Question to chew on... While keeping as a target the concep=
t of=0A=
>> "file =3D=3D zone" or as close to it as possible, what do you think zone=
fs minimal=0A=
>> feature set should be ?=0A=
>>=0A=
>> One idea I have since a while back now is this:=0A=
>> 1) If a zone is unused, do not show a file for it. This means adding a d=
ynamic=0A=
>> "zone allocation" code and supporting O_CREAT on open, unlink, etc. So h=
ave more=0A=
>> normal file system calls behave as with a normal FS.=0A=
>> 2) Allow file names to be decided by the user instead of using a fixed n=
ames.=0A=
>> Again, have O_CREAT behave as expected=0A=
> =0A=
> So now you have to implement a persistent directory structure,=0A=
> atomic/transactional updates, etc. You've just added at least 2=0A=
> orders of magnitude complexity to zonefs and a very substantial=0A=
> amount of additional, ongoing QA to ensure it works correctly.=0A=
> =0A=
> I think keeping it simple by exposing all zones to userspace and=0A=
> leaving it to the application to track/index what zones it is=0A=
> using is the simplest way forward for everyone.=0A=
=0A=
OK. Anything more complicated would probably be better implemented within a=
n=0A=
existing file system.=0A=
=0A=
Thank you for your comments.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
