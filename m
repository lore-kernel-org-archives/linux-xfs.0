Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7246 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfDOCVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Apr 2019 22:21:30 -0400
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH] nvme/012 & 013: avoid extremely slow xfs IO
Date: Mon, 15 Apr 2019 02:21:27 +0000
Message-ID: <SN6PR04MB45271891C853B09EFEB0E2A6862B0@SN6PR04MB4527.namprd04.prod.outlook.com>
References: <20190415012229.20689-1-ming.lei@redhat.com>
 <SN6PR04MB4527DD7C84A15184AE5F7947862B0@SN6PR04MB4527.namprd04.prod.outlook.com>
 <CACVXFVMa1Zvqm=GYf=4_oB+wTuoKMGaStfsKSTGBbVKACGvGQQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <tom.leiming@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Eric Sandeen <esandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On 4/14/19 7:11 PM, Ming Lei wrote:=0A=
> On Mon, Apr 15, 2019 at 10:02 AM Chaitanya Kulkarni=0A=
> <Chaitanya.Kulkarni@wdc.com> wrote:=0A=
>>=0A=
>> Thanks for the patch Ming. Couple of comments below.=0A=
>> On 4/14/19 6:22 PM, Ming Lei wrote:=0A=
>>> It is observed that nvme/012 may take ~17 minutes to complete on aarch6=
4,=0A=
>>> even worse it may trigger IO timeout on nvme-loop.=0A=
>>>=0A=
>>> Eric and Dave replied that it is because of too small log size on small=
=0A=
>>> disk.=0A=
>>>=0A=
>>> So pass '-l size=3D32m' to avoid the issue.=0A=
>>>=0A=
>>> With this patch, nvme/012 can be completed in one minute.=0A=
>>>=0A=
>> Then we should set the QUICK=3D1 if its taking shorter time.=0A=
> =0A=
> That should have been a QUICK test, it is fine to set it, but it shouldn'=
t=0A=
> belong to this patch.=0A=
> =0A=
>>=0A=
>>> Cc: Eric Sandeen <esandeen@redhat.com>=0A=
>>> Cc: Dave Chinner <dchinner@redhat.com>=0A=
>>> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>=0A=
>>> Cc: linux-xfs@vger.kernel.org=0A=
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>=0A=
>>> ---=0A=
>>>    tests/nvme/012 | 2 +-=0A=
>>>    tests/nvme/013 | 2 +-=0A=
>>>    2 files changed, 2 insertions(+), 2 deletions(-)=0A=
>>>=0A=
>>> diff --git a/tests/nvme/012 b/tests/nvme/012=0A=
>>> index 9a6801511df7..d7a8751ec752 100755=0A=
>>> --- a/tests/nvme/012=0A=
>>> +++ b/tests/nvme/012=0A=
>>> @@ -46,7 +46,7 @@ test() {=0A=
>>>=0A=
>>>        umount ${mount_dir} > /dev/null 2>&1=0A=
>>>=0A=
>>> -     mkfs.xfs -f /dev/"${nvmedev}n1" > /dev/null 2>&1=0A=
>>> +     mkfs.xfs -l size=3D32m -f /dev/"${nvmedev}n1" > /dev/null 2>&1=0A=
>>>=0A=
>> As a part of this series lets move this to the helper mkfs in the=0A=
>> nvme/rc and use that call in all the file-backed ns related testcases.=
=0A=
>> Let me know if you want me to do that or you would like to do that as a=
=0A=
>> part of this series. I'm okay with anything.=0A=
> =0A=
> I am fine with either way.=0A=
> =0A=
Okay, let's get this in, will send out the refactoring.=0A=
> Thanks,=0A=
> Ming Lei=0A=
> =0A=
=0A=
