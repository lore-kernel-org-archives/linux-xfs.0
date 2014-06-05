Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A8607F3F
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 14:39:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0E47430406B
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 12:39:48 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	dnyC7i7czWtEWDXw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Jun 2014 12:39:46 -0700 (PDT)
Received: by mail-wi0-f182.google.com with SMTP id r20so4169742wiv.15
	for <xfs@oss.sgi.com>; Thu, 05 Jun 2014 12:39:45 -0700 (PDT)
Message-ID: <5390C77E.4020003@gmail.com>
Date: Thu, 05 Jun 2014 22:39:42 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
	<538DA7FF.4080002@gmail.com> <20140603212834.GG14410@dastard>
	<538E4E1B.1020003@gmail.com> <20140605005538.GB4523@dastard>
In-Reply-To: <20140605005538.GB4523@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Dear Dave,

Thanks for your patience, and I'd like to ask a few more questions if
I may.

You mentioned that XFS is primarily for server type environment and
specifically mentioned multipath access to storage devices. I had a
setup in the past, blade center with a shared SCSI array where
everything was duplicated. The blades had two connections one to each
of a pair of switches, the switches had duplicated connections to two
controllers (4 connections) and the controllers had access to the SCSI
drives (a dozen). So in this scenario each blade had two SCSI drives
showing for each volume on the array. So.....

Does XFS bind to both devices? If so, does it start using the second
if it loses access to the one it uses right now? E.g. when you do
maintenance on one of the redundant switches. Also, if so, does XFS
pick the device up when the device comes back (e.g. maintenance done).
This assumes of course that only one of the pair is down at a time.
... Or does XFS just prevent the use of the redundant device in order
to prevent problems related to writing to the same device by two FS
instances?

Martin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTkMdoAAoJELsEaSRwbVYrbfgP/0zfMZaKz4f8Si9eIkdVLn1o
nnS0KRo3Ma751vvRWeu8Nf9Mki4rSW9bTE9au2O5jameUTGJl/4TbeC91HTbnRq7
tVjjNw9rf7I36kLEv0fZmm5zjlpn4WLSulcjdOEJqGB4NGng2HULqIUJQ62MPvW4
ZRluzgq3fZPg3wOpKinEUviwDjcwOe/9grCIieNxgVwk7GKwal8ytH/Z58++AoFW
5PB5MBlPTYFOTfIWupkGoWGyUS3M7+Ddwq9RmD871XXFnQOeyRlxF8iGp4Kqw1h1
D+jhUqiMZWApzprs6V1zQJ9Z7NbBZyHk/xwbB2EF/aQUsiukLchsX7rxgPFShWkA
dJ8biDbbqQY4+ZFYt5NXi9TlffpGoCutWkU73DdGxWArM5cI6eFOCSRPE7Gfm8zR
ZhUeq1g6UP9mefsm7ZOlVq4KanbEgdkkh2I1y/aTSUHd80O7Fge2vpN089Ub1LnI
kcRcTN0b11Ut6nJkPAbVpVnCBpz6F0qAYUlW6ECW0F5w3Qvd5VZhRN5OLL3OTjo/
2k+YRA/9g9tlZNNcZWdFR08TZLzMACxNef6uNb0HIlIJNEq8+a1JipklWgOjqOt2
2/eGduI5ijt0i+4MqUnrhStIUb0ac0al4vliQ0ijAfpD8WbnrzznvGBAZoCUSjWC
1cKR41L/uYmjdLmB6AHc
=lbaf
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
