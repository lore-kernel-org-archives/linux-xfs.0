Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 32A3F7F5A
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 18:43:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AC4F5AC01B
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 16:43:38 -0800 (PST)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
	[209.85.220.46]) by cuda.sgi.com with ESMTP id eeATjeBjBfIIXzWU
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Nov 2015 16:43:35 -0800 (PST)
Received: by pacej9 with SMTP id ej9so8428852pac.2
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 16:43:34 -0800 (PST)
Subject: Re: [PATCH v2 03/11] pmem: enable REQ_FUA/REQ_FLUSH handling
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CAPcyv4j4arHE+iAALn1WPDzSb_QSCDy8udtXU1FV=kYSZDfv8A@mail.gmail.com>
Date: Fri, 13 Nov 2015 17:43:28 -0700
Message-Id: <22E0F870-C1FB-431E-BF6C-B395A09A2B0D@dilger.ca>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<1447459610-14259-4-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4j4arHE+iAALn1WPDzSb_QSCDy8udtXU1FV=kYSZDfv8A@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6948502939838009548=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: X86 ML <x86@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <matthew.r.wilcox@intel.com>


--===============6948502939838009548==
Content-Type: multipart/signed; boundary="Apple-Mail=_1216766E-B738-4495-BFC0-CB153BFD6B45"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_1216766E-B738-4495-BFC0-CB153BFD6B45
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 13, 2015, at 5:20 PM, Dan Williams <dan.j.williams@intel.com> =
wrote:
>=20
> On Fri, Nov 13, 2015 at 4:06 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
>> Currently the PMEM driver doesn't accept REQ_FLUSH or REQ_FUA bios.  =
These
>> are sent down via blkdev_issue_flush() in response to a fsync() or =
msync()
>> and are used by filesystems to order their metadata, among other =
things.
>>=20
>> When we get an msync() or fsync() it is the responsibility of the DAX =
code
>> to flush all dirty pages to media.  The PMEM driver then just has =
issue a
>> wmb_pmem() in response to the REQ_FLUSH to ensure that before we =
return all
>> the flushed data has been durably stored on the media.
>>=20
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>=20
> Hmm, I'm not seeing why we need this patch.  If the actual flushing of
> the cache is done by the core why does the driver need support
> REQ_FLUSH?  Especially since it's just a couple instructions.  REQ_FUA
> only makes sense if individual writes can bypass the "drive" cache,
> but no I/O submitted to the driver proper is ever cached we always
> flush it through to media.

If the upper level filesystem gets an error when submitting a flush
request, then it assumes the underlying hardware is broken and cannot
be as aggressive in IO submission, but instead has to wait for in-flight
IO to complete.  Since FUA/FLUSH is basically a no-op for pmem devices,
it doesn't make sense _not_ to support this functionality.

Cheers, Andreas






--Apple-Mail=_1216766E-B738-4495-BFC0-CB153BFD6B45
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVkaDsXKl2rkXzB/gAQibwBAAgoTcZevnn7sprjKcrySWAvw9bcubKzY8
W4c6wkFftY8858ROsblZ/0+OhZPFlf2zJ2G3g+8sJ4Upv1s0MpyGHYS6QVu/QLn3
xy4O7ivbLMtFOfMFWfheKAb8GxJxzpklB5yhyHaMnxtCxEg71K5D9mnqTi/jPIv6
L0yWugsuzeSVeJ423NsFCxRZkWN2wrSuT6PS7bPeN/VBUC8wfU+LMXnmye9+tl1Z
EkZWf11PQOz5kkEkN6Xk+ShgAVz7GR6w3jYHxDvNbZ+bDvlPGsV8Wvf+GZIo0Q4/
SdhfRfNG/D2KKQlCAfZyyEdcSRcoSvkhAPny+ocGW9+rUNd86LMllbvfGzkRNH9Y
pfocoQZHxcJ9G52XeqVVJvFzajQhPryzdOePg5YwnckY5h6Td0K46THztFKMN51K
vXNhhbV/EHy7EjgNOsu+4tTfWrVdSGB4AiKlJlZ4SU5e4FaJxLR00jzm5nVSZpbC
NW8NO+uE8deVLw1BJbVFq6S4qm1NshY0EZ4SYuksdJaAwo3kZtdjvbmnFq2Er+ta
PVoWA5oJl5pZ0WRxEckchTIXC7iqwgVdBtPBqiAOZ4u+X3caU7kx+hYpjCymozvy
6RdWl1hfgIv5lkJGf1SBOaLz1KSu2ElTtGDbWaQpxnKNnsE0Ye/gTd4m9bb86e+O
b5j4DzeyM0E=
=ibQq
-----END PGP SIGNATURE-----

--Apple-Mail=_1216766E-B738-4495-BFC0-CB153BFD6B45--


--===============6948502939838009548==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6948502939838009548==--
