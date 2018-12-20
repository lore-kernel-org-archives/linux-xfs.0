Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f44.google.com ([209.85.221.44]:39488 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731279AbeLTOTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 09:19:53 -0500
Received: by mail-wr1-f44.google.com with SMTP id t27so1944422wra.6
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 06:19:52 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: XFS metadata corruption
From: Predrag Mijatovic <predmijat@gmail.com>
In-Reply-To: <9d535706-8b75-7eb7-bf6c-a7bace790ed1@sandeen.net>
Date: Thu, 20 Dec 2018 15:19:49 +0100
Content-Transfer-Encoding: quoted-printable
Message-Id: <BD7C2D2C-0B16-4BA1-8F81-39A4E5F7461E@gmail.com>
References: <93641AD9-AD79-4400-8C7F-14C5D7746709@gmail.com>
 <5fe33e22-e034-db8c-f62d-8124e731c5dd@sandeen.net>
 <6E2E81FA-9677-4385-9ADF-46E06B6F5150@gmail.com>
 <5804b809-4656-9471-9d06-64c5a58e99b0@sandeen.net>
 <9CE4CDCD-DDCE-470D-9AE8-69D2E5C6E1FE@gmail.com>
 <9d535706-8b75-7eb7-bf6c-a7bace790ed1@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Had to cancel it at 24G at size after I read that it can be 10% of =
actual partition size :)

> On Dec 18, 2018, at 9:43 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>=20
> On 12/18/18 2:42 PM, Predrag Mijatovic wrote:
>> I realize it will be less than 12T (btw it=E2=80=99s almost full) but =
it will still take a lot (more than few GBs), no?
>=20
> yes, possibly.  If it's unwieldy we can try to do some remote
> debugging with xfs_db, but having a metadata image can be very helpful
> at times.  No promises though.  ;)
>=20
> Thanks,
> -Eric
>=20
>> Also, I read on RedHat website that it should be unmounted...
>>=20
>>> On Dec 18, 2018, at 9:32 PM, Eric Sandeen <sandeen@sandeen.net> =
wrote:
>>>=20
>>>> On 12/18/18 2:26 PM, Predrag Mijatovic wrote:
>>>> It=E2=80=99s a 12T partition so it will take a while (plus I =
can=E2=80=99t start it before tomorrow morning)
>>>=20
>>> Just FYI, a metadump is metadata-only so the time and space it takes =
will
>>> be a) much less than a full 12T and b) proportional to the amount of
>>> metadata you have in the filesystem.
>>>=20
>>> Note, the fs does need to be offline to get a metadump.
>>>=20
>>> Thanks,
>>> -Eric
>>>=20
>>>=20
>>=20
