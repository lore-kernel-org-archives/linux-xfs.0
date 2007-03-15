Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Mar 2007 21:53:06 -0700 (PDT)
Received: from s62.xrea.com (s62.xrea.com [221.186.251.67])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2F4r06p011797
	for <xfs@oss.sgi.com>; Wed, 14 Mar 2007 21:53:02 -0700
Message-ID: <45F8CAEA.3050408@list.rakugaki.org>
Date: Thu, 15 Mar 2007 13:26:18 +0900
From: Taisuke Yamada <tyamadajp@list.rakugaki.org>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <200703131440.56678.clflush@chello.be> <1173890016.20671.11.camel@localhost.localdomain>
In-Reply-To: <1173890016.20671.11.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

- From end-user's POV, this infamous XFS behavior is somewhat
taken as XFS's inferiority compared to other filesystems.
Even with "bad" applications (ex. firefox), this rarely happens
on others, so regardless of what's on the FAQ, people logically
concludes that the fault belongs to XFS anyway.

So, what is the correct way to do IO?
Is what firefox (and other bad apps) doing is so obvious(ly buggy),
that it'll be acknowledged as a bug once reported? Or is it simply
a mismatch between application expectation and XFS behavior,
requiring a non-(obvious|generic) fix?

Although I'm not a filesystem developer, I'm pretty impressed with
XFS and willing to file a report/patch to those "buggy" apps if the
issue is explainable to other app developers.

>> was to press the reset button on the computer. After the reboot, when I 
>> opened Firefox again, I noticed that all my bookmarks were gone. Those 
>> bookmarks were imported from my desktop machine a few days after I configured 
>> the new server.
> 
> This is a firefox bug - I've seen it before (on my mother's machine).
> 
> It's due to firefox not doing the correct thing with IO on the bookmarks
> file.

- --
Taisuke Yamada <tyamadajp@spam.rakugaki.org>, http://rakugaki.org/
2268 E9A2 D4F9 014E F11D  1DF7 DCA3 83BC 78E5 CD3A

Message to my public address may not be handled in a timely manner.
For a direct contact, please use my private address on my namecard.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF+Mrq3KODvHjlzToRAu/vAKC8pky15WJwocHbWhbRx9f2H+c5aQCeIeYp
ZJPcSeawAIbZN80GXJz+kYg=
=oAY3
-----END PGP SIGNATURE-----
