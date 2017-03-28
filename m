Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37646 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755560AbdC1Tjk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 15:39:40 -0400
Received: by mail-it0-f43.google.com with SMTP id 190so31483726itm.0
        for <linux-xfs@vger.kernel.org>; Tue, 28 Mar 2017 12:39:34 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <5E78AA22-2C44-4A94-9CEA-A954D836FC6C@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_39247FA5-6706-45AE-B353-0C1386B7B504";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: statx manpage
Date: Tue, 28 Mar 2017 13:39:09 -0600
In-Reply-To: <1490641451.9691.4.camel@poochiereds.net>
References: <20170327154003.GA5716@birch.djwong.org>
 <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk> <20170324205322.GA4986@gmail.com>
 <E6DB8461-22DE-496C-8A4A-B0A2F3702750@dilger.ca>
 <23715.1490631926@warthog.procyon.org.uk>
 <20170327164628.GA15147@infradead.org>
 <1490641451.9691.4.camel@poochiereds.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@poochiereds.net>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Biggers <ebiggers3@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>


--Apple-Mail=_39247FA5-6706-45AE-B353-0C1386B7B504
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 27, 2017, at 1:04 PM, Jeff Layton <jlayton@poochiereds.net> =
wrote:
>=20
> On Mon, 2017-03-27 at 09:46 -0700, Christoph Hellwig wrote:
>> On Mon, Mar 27, 2017 at 05:25:26PM +0100, David Howells wrote:
>>> That means a filesystem can't simply return non-basic data =
unconditionally if
>>> possible.  I prefer letting it do so if it doesn't incur any extra =
I/O
>>> overheads.
>>=20
>> This seems like it will lead to userspace expecting certain fields to
>> just be there, and a lot harder to properly verify for tests.  Which =
btw
>> we all need for these odd behaviors.  If we can't get them any time =
soon
>> (e.g. before -rc6) I think we'll simply have to revert statx instead =
of
>> leaving this untested mess in the tree.
>=20
> I don't think so.
>=20
> I think we just have to clearly document that that will not be the
> case. If they really expect the field to be there, then they need to
> set the bit in the "want" mask -- it's really as simple as that.

It would be my preference to only return attributes which are explicitly
requested (Lustre won't return fields for which the bit is not set), but
there was a request for this behaviour in NFS I recall.

That said, there are also flags for "lazy" attributes for NFS. I wonder =
if
it is enough to pass AT_STATX_DONT_SYNC and request STATX_SIZE | =
STATX_CTIME,
or whatever NFS is worried about, and return the client-local version of =
the
attributes?

I guess the real question is what an application is going to do with =
fields
that it didn't actually request, and has no way to know if they are =
valid or
contain garbage?

Cheers, Andreas






--Apple-Mail=_39247FA5-6706-45AE-B353-0C1386B7B504
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY2rvdpIg59Q01vtYRAvPMAJ0SHc9TqUI2OxqnaIToEWYZDTr+6wCeIB9e
pah2UELW9yJlmWw1/fsdoCw=
=wgrj
-----END PGP SIGNATURE-----

--Apple-Mail=_39247FA5-6706-45AE-B353-0C1386B7B504--
