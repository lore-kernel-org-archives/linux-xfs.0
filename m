Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38735 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdC0Aqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Mar 2017 20:46:52 -0400
Received: by mail-it0-f54.google.com with SMTP id y18so36781812itc.1
        for <linux-xfs@vger.kernel.org>; Sun, 26 Mar 2017 17:46:51 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_F52FC516-7A27-4C25-8BC5-174481132167";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: statx manpage
Date: Sun, 26 Mar 2017 18:46:43 -0600
In-Reply-To: <20170324205322.GA4986@gmail.com>
References: <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk> <20170324205322.GA4986@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>


--Apple-Mail=_F52FC516-7A27-4C25-8BC5-174481132167
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Mar 24, 2017, at 2:53 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
>=20
> On Tue, Mar 07, 2017 at 05:22:55PM +0000, David Howells wrote:
>> STATX_ALL	[All currently available stuff]
>> .TE
>> .in
>> .PP
>> .B "Do not"
>> simply set
>> .I mask
>> to UINT_MAX as one or more bits may, in future, be used to specify an =
extension
>> to the buffer.
>=20
> To clarify, will an "extension to the buffer" be an increase in the =
size of
> struct statx?  I think it would have to be, otherwise programs filling =
a struct
> statx with STATX_ALL would start breaking as soon as they're rebuilt =
with the
> new value of STATX_ALL, no?  Or would these "extension to the buffer" =
bits not
> be added to STATX_ALL ...?

The value of STATX_ALL would match the size of struct statx in the =
header at
compilation time, so this would always be consistent.
>=20
> And I don't suppose there's anything we can do to stop programs from =
asking
> for mask bits that haven't been defined yet, then breaking later if =
they
> happen to be defined as "extensions"?  Maybe adding an extra "buffer =
size"
> argument to the syscall?

You can't stop applications from doing dumb things, like asking to read =
1MB
of data into a buffer that is only 512KB in size.  That will also work =
fine
as long as the application only reads a files smaller than 512KB.

Similarly, if the statx() API says that the STATX_ALL mask is the list =
of
currently-supported bits, but the app asks for more bits than it =
allocates
a buffer for, there isn't much that the kernel can do.

> I'm concerned that the idea of "extensions" isn't well thought out, =
and in
> practice we'll just be stuck with the current struct size (256 bytes) =
forever.

The extensions work exactly as they should - the client sets bits for =
fields
that it needs (and by definition it shouldn't ask for anything that it =
doesn't
understand), and the kernel masks this down to the bits that it =
understands.

If the client asks for more bits than the kernel understands, it is =
likely a
newer application on an older kernel, and it will only get back the =
fields
that the kernel understands.  The reverse (client asking for fewer bits =
than
the kernel understands) is normal behaviour for this interface.  The =
kernel should only fill in fields that the client requested and for =
which there is
space in the struct.

Cheers, Andreas






--Apple-Mail=_F52FC516-7A27-4C25-8BC5-174481132167
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY2GD1pIg59Q01vtYRAt7dAJ9aF7EIBGB/H1qvktbMFzkiUL4ZUACgtXoc
gshL8c6Gk6CTRiTIXY8pL5A=
=/vD0
-----END PGP SIGNATURE-----

--Apple-Mail=_F52FC516-7A27-4C25-8BC5-174481132167--
