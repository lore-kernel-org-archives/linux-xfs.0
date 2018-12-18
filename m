Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f50.google.com ([209.85.221.50]:46009 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbeLRUmd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:42:33 -0500
Received: by mail-wr1-f50.google.com with SMTP id t6so17115719wrr.12
        for <linux-xfs@vger.kernel.org>; Tue, 18 Dec 2018 12:42:32 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: XFS metadata corruption
From: Predrag Mijatovic <predmijat@gmail.com>
In-Reply-To: <5804b809-4656-9471-9d06-64c5a58e99b0@sandeen.net>
Date: Tue, 18 Dec 2018 21:42:29 +0100
Content-Transfer-Encoding: quoted-printable
Message-Id: <9CE4CDCD-DDCE-470D-9AE8-69D2E5C6E1FE@gmail.com>
References: <93641AD9-AD79-4400-8C7F-14C5D7746709@gmail.com> <5fe33e22-e034-db8c-f62d-8124e731c5dd@sandeen.net> <6E2E81FA-9677-4385-9ADF-46E06B6F5150@gmail.com> <5804b809-4656-9471-9d06-64c5a58e99b0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

I realize it will be less than 12T (btw it=E2=80=99s almost full) but it wil=
l still take a lot (more than few GBs), no?

Also, I read on RedHat website that it should be unmounted...

> On Dec 18, 2018, at 9:32 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>=20
>> On 12/18/18 2:26 PM, Predrag Mijatovic wrote:
>> It=E2=80=99s a 12T partition so it will take a while (plus I can=E2=80=99=
t start it before tomorrow morning)
>=20
> Just FYI, a metadump is metadata-only so the time and space it takes will
> be a) much less than a full 12T and b) proportional to the amount of
> metadata you have in the filesystem.
>=20
> Note, the fs does need to be offline to get a metadump.
>=20
> Thanks,
> -Eric
>=20
>=20
