Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59145 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752632AbdHQWyc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 18:54:32 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: xfs_repair fails: mismatched UUID?
From: Link Dupont <link@sub-pop.net>
In-Reply-To: <d83f6b0d-6881-edc1-4353-eb357ed55730@sandeen.net>
Date: Thu, 17 Aug 2017 15:54:30 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <1AF5F743-A613-4E2A-9D50-9DF84D4D3532@sub-pop.net>
References: <1502946903.3034.25.camel@sub-pop.net> <d31ec46a-cc4c-5865-6ee4-fffdcb32c254@sandeen.net> <e285d801-755b-b84e-028a-b889f4ee336c@sandeen.net> <1502948579.29878.8.camel@sub-pop.net> <d83f6b0d-6881-edc1-4353-eb357ed55730@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org



> On Aug 16, 2017, at 10:48 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>=20
>=20
>=20
>> On 8/17/17 12:42 AM, Link Dupont wrote:
>>> On Thu, 2017-08-17 at 00:26 -0500, Eric Sandeen wrote:
>>> Oh right, you did say RAID enclosure.
>>>=20
>>> My money is on the enclosure no longer presenting you with sectors in
>>> the original order, or in an otherwise severely damaged form, for
>>> whatever reason.
>>=20
>> The problem *could* be from the enclosure itself; I don't have a second o=
ne to
>> test. I'm fairly sure the cause is a failing drive (I get a red LED from o=
ne of
>> the two status LEDs on the front of the enclosure).
>>=20
>>> xfs_repair restores filesystem consistency but it is not a data recovery=
 or
>>> storage repair tool.  ;)
>>=20
>> I get that. But since the files are there, it seemed like the file-system=
 could
>> be repaired. I'll dig up the output.
>=20
> My worry is that the "log uuid" was neither zeros nor the proper UUID; it w=
as
> something else.  So it wasn't bad, unreadable sectors which got filled in w=
ith
> zeros by ddrescue, it was apparently some random data coughed up by the
> enclosure for some unknown reason.
>=20
> If it did that to the log, it may well have done that to many other parts
> of the filesystem as well.
>=20
> -Eric
>=20

This almost makes it seem more like the enclosure controller is at fault her=
e. I'll chase down another one.=

