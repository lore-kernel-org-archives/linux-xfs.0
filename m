Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:19273 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbeBYFLe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Feb 2018 00:11:34 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P4O00A00TZ4EZ00@pv33p36im-asmtp001.me.com> for
 linux-xfs@vger.kernel.org; Sun, 25 Feb 2018 04:11:32 +0000 (GMT)
Content-type: text/plain; charset=gb2312
MIME-version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH] xfs: fix potential memory leak in mount option parsing
From: Chengguang Xu <cgxu519@icloud.com>
In-reply-to: <5d92aa93-cec4-2495-70fa-61d082e1cb6b@sandeen.net>
Date: Sun, 25 Feb 2018 12:11:23 +0800
Content-transfer-encoding: quoted-printable
Message-id: <326CF29E-FC88-493B-B16E-7EA318169E9A@icloud.com>
References: <1519468406-67354-1-git-send-email-cgxu519@icloud.com>
 <5d92aa93-cec4-2495-70fa-61d082e1cb6b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org

>=20
> =D4=DA 2018=C4=EA2=D4=C225=C8=D5=A3=AC=C9=CF=CE=E71:58=A3=ACEric =
Sandeen <sandeen@sandeen.net> =D0=B4=B5=C0=A3=BA
>=20
> On 2/24/18 4:33 AM, Chengguang Xu wrote:
>> When specifying string type mount option (e.g., logdev)
>> several times in a mount, current option parsing may
>> cause memory leak. Hence, call kfree for previous one
>> in this case.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>=20
> IMHO multiple specifications of logdev or rtdev should not
> be allowed; only one may be chosen, and specifying twice
> should probably be considered and administrative error.
>=20
> I'd rather see something that fails and cleans up properly
> if either option is respecified.

Hi Eric,

Thanks for quick reply. I think your suggestion makes sense,
but considering of the consistency with other options,=20
we should check multiple specifications for all options.=20

So I think this patch is the cheapest way to fix the issue.
What do you think?


Thanks,
Chengguang.=
