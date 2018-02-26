Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:29758 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751924AbeBZBuJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Feb 2018 20:50:09 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P4Q00C00I9HMC00@pv33p36im-asmtp002.me.com> for
 linux-xfs@vger.kernel.org; Mon, 26 Feb 2018 01:50:08 +0000 (GMT)
Content-type: text/plain; charset=gb2312
MIME-version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH] xfs: fix potential memory leak in mount option parsing
From: Chengguang Xu <cgxu519@icloud.com>
In-reply-to: <fe6ac2e6-bac0-7f8f-4a24-f72439365848@sandeen.net>
Date: Mon, 26 Feb 2018 09:49:56 +0800
Content-transfer-encoding: quoted-printable
Message-id: <459A9791-08EF-49A5-A8BF-916D0BB58E8B@icloud.com>
References: <1519468406-67354-1-git-send-email-cgxu519@icloud.com>
 <5d92aa93-cec4-2495-70fa-61d082e1cb6b@sandeen.net>
 <326CF29E-FC88-493B-B16E-7EA318169E9A@icloud.com>
 <20180225180916.GB19312@magnolia>
 <fe6ac2e6-bac0-7f8f-4a24-f72439365848@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

>=20
> =D4=DA 2018=C4=EA2=D4=C226=C8=D5=A3=AC=C9=CF=CE=E72:11=A3=ACEric =
Sandeen <sandeen@sandeen.net> =D0=B4=B5=C0=A3=BA
>=20
>=20
>=20
> On 2/25/18 12:09 PM, Darrick J. Wong wrote:
>> On Sun, Feb 25, 2018 at 12:11:23PM +0800, Chengguang Xu wrote:
>>>>=20
>>>> =D4=DA 2018=C4=EA2=D4=C225=C8=D5=A3=AC=C9=CF=CE=E71:58=A3=ACEric =
Sandeen <sandeen@sandeen.net> =D0=B4=B5=C0=A3=BA
>>>>=20
>>>> On 2/24/18 4:33 AM, Chengguang Xu wrote:
>>>>> When specifying string type mount option (e.g., logdev)
>>>>> several times in a mount, current option parsing may
>>>>> cause memory leak. Hence, call kfree for previous one
>>>>> in this case.
>>>>>=20
>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>=20
>>>> IMHO multiple specifications of logdev or rtdev should not
>>>> be allowed; only one may be chosen, and specifying twice
>>>> should probably be considered and administrative error.
>>>>=20
>>>> I'd rather see something that fails and cleans up properly
>>>> if either option is respecified.
>>>=20
>>> Hi Eric,
>>>=20
>>> Thanks for quick reply. I think your suggestion makes sense,
>>> but considering of the consistency with other options,=20
>>> we should check multiple specifications for all options.=20
>>>=20
>>> So I think this patch is the cheapest way to fix the issue.
>>> What do you think?
>>=20
>> I think the all the mount options should be cleaned up to allow one
>> specification only.
>=20
> Yeah, I think so too, though perhaps it's fair to have one patch
> to fix the leak as it stands today, and another to clean up the
> respecification problem.  They are two separate issues in the end,
> I suppose, so two separate patches seems reasonable.

More accurately, we don=A1=AFt allow respecification with different =
value, right?


Thanks,
Chengguang.=
