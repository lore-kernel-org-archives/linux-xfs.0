Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:12807 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaGFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 02:05:02 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: lift the xfs writepage code into iomap v3
Date: Wed, 31 Jul 2019 06:04:59 +0000
Message-ID: <BYAPR04MB5816C29CC419B748F03BF5BAE7DF0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190722095024.19075-1-hch@lst.de>
 <20190730011705.GO1561054@magnolia>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Darrick,=0A=
=0A=
On 2019/07/30 10:17, Darrick J. Wong wrote:=0A=
> On Mon, Jul 22, 2019 at 11:50:12AM +0200, Christoph Hellwig wrote:=0A=
>> Hi all,=0A=
>>=0A=
>> this series cleans up the xfs writepage code and then lifts it to=0A=
>> fs/iomap.c so that it could be use by other file system.  I've been=0A=
>> wanting to this for a while so that I could eventually convert gfs2=0A=
>> over to it, but I never got to it.  Now Damien has a new zonefs=0A=
>> file system for semi-raw access to zoned block devices that would=0A=
>> like to use the iomap code instead of reinventing it, so I finally=0A=
>> had to do the work.=0A=
> =0A=
> I've posted a branch against -rc2 for us all to work from:=0A=
> =0A=
> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/log/?h=3Diomap-writeb=
ack=0A=
> =0A=
> and will be emailing the patches shortly to the list for completeness.=0A=
=0A=
I rebased zonefs on this branch and all tests passed, no compilation proble=
ms=0A=
either. I will send a v2 of zonefs patch with all of Dave's comments addres=
sed=0A=
shortly.=0A=
=0A=
Thank you.=0A=
=0A=
Best regards.=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
