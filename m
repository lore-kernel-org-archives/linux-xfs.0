Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44005 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390228AbfHHSxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 14:53:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id r26so8568222pgl.10
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 11:53:31 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <69E22C32-5EDC-4507-9407-A1622BC31560@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_39697C0F-3B43-4F6C-B46F-487A1EAB1FEB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Date: Thu, 8 Aug 2019 12:53:25 -0600
In-Reply-To: <20190808071257.ufbk5i35xpkf4byh@pegasus.maiolino.io>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-5-cmaiolino@redhat.com>
 <20190731231217.GV1561054@magnolia>
 <20190802091937.kwutqtwt64q5hzkz@pegasus.maiolino.io>
 <20190802151400.GG7138@magnolia>
 <20190805102729.ooda6sg65j65ojd4@pegasus.maiolino.io>
 <20190805151258.GD7129@magnolia> <20190806224138.GW30113@42.do-not-panic.com>
 <20190808071257.ufbk5i35xpkf4byh@pegasus.maiolino.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, rpeterso@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>


--Apple-Mail=_39697C0F-3B43-4F6C-B46F-487A1EAB1FEB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 8, 2019, at 1:12 AM, Carlos Maiolino <cmaiolino@redhat.com> =
wrote:
>=20
>>>=20
>>>> Maybe I am not seeing something or having a different thinking you =
have, but
>>>> this is the behavior we have now, without my patches. And we can't =
really change
>>>> it; the user view of this implementation.
>>>> That's why I didn't try to change the result, so the truncation =
still happens.
>>>=20
>>> I understand that we're not generally supposed to change existing
>>> userspace interfaces, but the fact remains that allowing truncated
>>> responses causes *filesystem corruption*.
>>>=20
>>> We know that the most well known FIBMAP callers are bootloaders, and =
we
>>> know what they do with the information they get -- they use it to =
record
>>> the block map of boot files.  So if the IPL/grub/whatever installer
>>> queries the boot file and the boot file is at block 12345678901 (a
>>> 34-bit number), this interface truncates that to 3755744309 (a =
32-bit
>>> number) and that's where the bootloader will think its boot files =
are.
>>> The installation succeeds, the user reboots and *kaboom* the system =
no
>>> longer boots because the contents of block 3755744309 is not a =
bootloader.
>>>=20
>>> Worse yet, grub1 used FIBMAP data to record the location of the grub
>>> environment file and installed itself between the MBR and the start =
of
>>> partition 1.  If the environment file is at offset 1234578901, grub =
will
>>> write status data to its environment file (which it thinks is at
>>> 3755744309) and *KABOOM* we've just destroyed whatever was in that
>>> block.
>>>=20
>>> Far better for the bootloader installation script to hit an error =
and
>>> force the admin to deal with the situation than for the system to =
become
>>> unbootable.  That's *why* the (newer) iomap bmap implementation does =
not
>>> return truncated mappings, even though the classic implementation =
does.
>>>=20
>>> The classic code returning truncated results is a broken behavior.
>>=20
>> How long as it been broken for? And if we do fix it, I'd just like =
for
>> a nice commit lot describing potential risks of not applying it. *If*
>> the issue exists as-is today, the above contains a lot of information
>> for addressing potential issues, even if theoretical.
>>=20
>=20
> It's broken since forever. This has always been the FIBMAP behavior.

It's been broken since forever, but only for filesystems larger than 4TB =
or
16TB (2^32 blocks), which are only becoming commonplace for root disks =
recently.
Also, doesn't LILO have a limit on the location of the kernel image, in =
the
first 1GB or similar?

So maybe this is not an issue that FIBMAP users ever hit in practise =
anyway,
but I agree that it doesn't make sense to return bad data (32-bit =
wrapped block
numbers) and 0 should be returned in such cases.


Cheers, Andreas






--Apple-Mail=_39697C0F-3B43-4F6C-B46F-487A1EAB1FEB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl1Mb6YACgkQcqXauRfM
H+DXIw/9E7jMcw2a2hvhRw3vkhG3/68LSALNdU8k0FLKxlB9tv+PyYEBi0ykBQhd
kq6f5QB0onO6RXk5OG8ylftrIASFPl40JFXoOAgheHnVuH6TUlpmG0/S+Lr2AAxF
jkg7jeGFurNF3NVTd0MiwFYbQbx5VzeKgDVB8Q1RWP4z5pcc1mT522LiYx4OXhhn
EPZxa76LNvOi5mfZLRu8tvonFjoBUy5Ui0YulEJcY85E/v+euu2vdOCzmfbTujq+
AG8XCAdwegg9OltIWzzBHNMvPT1mKdxeGT/5KomOy/R0I9Q5QBrYJe6rw32FS72L
9PytFAk3l71c1sehdVqkCqpaJdwWR/8Fylk0kTz85LKMyaQ2SCav9zPaBrqCG8Xh
p/XVxfFkolk6OLGmsH4ICGdBi3l2z1ZOWt8U+QTvUu50I3RLIUPdyD53YAkomEr5
daHE7zx5yCNqx8zEz/V3Vp6CoPzaTMNbzCI8rKy3PwUG/qiPIcAJBa9HNqv8nVxY
sXHdbawi+wCJz+MCibiXOQTXgCvZiuVhDeylr6ic6d64LP6dMUCrOhdAM0Qr1ylm
O0kQVEp4IifaM7VaheZxukwHERl0a+jRqMuFstuHRTJp/PLw6s6mzQVgdDykCPZV
fVGJ5xE55qwrQDJvUH8tnSLHx8MmgbeIhZV5qUjux3Uc5xT4FP0=
=vAPg
-----END PGP SIGNATURE-----

--Apple-Mail=_39697C0F-3B43-4F6C-B46F-487A1EAB1FEB--
