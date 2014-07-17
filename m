Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 480797FD3
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 01:08:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A8428F804C
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 23:08:05 -0700 (PDT)
Received: from mail-pa0-f48.google.com (mail-pa0-f48.google.com
	[209.85.220.48]) by cuda.sgi.com with ESMTP id bhxXAOIIoAHJWp23
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Jul 2014 23:08:03 -0700 (PDT)
Received: by mail-pa0-f48.google.com with SMTP id et14so2700761pad.35
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 23:08:02 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED flag
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
Date: Thu, 17 Jul 2014 00:07:57 -0600
Message-Id: <B58DEEA8-561A-4173-B9F5-528B73E06C6D@dilger.ca>
References: <cover.1386778302.git.dsterba@suse.cz>
	<4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
	<20131212232443.GL31386@dastard>
	<9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3614905744946436750=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: David Sterba <dsterba@suse.cz>
Cc: linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, Btrfs Developer List <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com


--===============3614905744946436750==
Content-Type: multipart/signed; boundary="Apple-Mail=_EB988F7E-B0DC-452A-BBB0-40EEBDBADAE7"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_EB988F7E-B0DC-452A-BBB0-40EEBDBADAE7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

David,
any progress on this patch series?

I never saw an updated version of this patch series after the last round =
of
reviews, but it would be great to move it forward.  I have filefrag =
patches
in my e2fsprogs tree waiting for an updated version of your patch.

I recall the main changes were:
- add FIEMAP_EXTENT_PHYS_LENGTH flag to indicate if fe_phys_length was =
valid
- rename fe_length to fe_logi_length and #define fe_length =
fe_logi_length
- always fill in fe_phys_length (=3D fe_logi_length for uncompressed =
files)
  and set FIEMAP_EXTENT_PHYS_LENGTH whether the extent is compressed or =
not
- add WARN_ONCE() in fiemap_fill_next_extent() as described below

I don't know if there was any clear statement about whether there should =
be
separate FIEMAP_EXTENT_PHYS_LENGTH and FIEMAP_EXTENT_DATA_COMPRESSED =
flags,
or if the latter should be implicit?  Probably makes sense to have =
separate
flags.  It should be fine to use:

#define FIEMAP_EXTENT_PHYS_LENGTH	0x00000010

since this flag was never used.

Cheers, Andreas

On Dec 12, 2013, at 5:02 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Dec 12, 2013, at 4:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Thu, Dec 12, 2013 at 04:25:59PM +0100, David Sterba wrote:
>>> This flag was not accepted when fiemap was proposed [2] due to lack =
of
>>> in-kernel users. Btrfs has compression for a long time and we'd like =
to
>>> see that an extent is compressed in the output of 'filefrag' utility
>>> once it's taught about it.
>>>=20
>>> For that purpose, a reserved field from fiemap_extent is used to let =
the
>>> filesystem store along the physcial extent length when the flag is =
set.
>>> This keeps compatibility with applications that use FIEMAP.
>>=20
>> I'd prefer to just see the new physical length field always filled
>> out, regardless of whether it is a compressed extent or not. In
>> terms of backwards compatibility to userspace, it makes no
>> difference because the value of reserved/unused fields is undefined
>> by the API. Yes, the implementation zeros them, but there's nothing
>> in the documentation that says "reserved fields must be zero".
>> Hence I think we should just set it for every extent.
>=20
> I'd actually thought the same thing while reading the patch, but I =
figured
> people would object because it implies that old kernels will return a
> physical length of 0 bytes (which might be valid) and badly-written =
tools
> will not work correctly on older kernels.  That said, applications =
_should_
> be checking the FIEMAP_EXTENT_DATA_COMPRESSED flag, and I suspect in =
the
> future fewer developers will be confused if fe_phys_length =3D=3D =
fe_length
> going forward.
>=20
> If the initial tools get it right (in particular filefrag), then =
hopefully
> others will get it correct also.
>=20
>> =46rom the point of view of the kernel API (fiemap_fill_next_extent),
>> passing the physical extent size in the "len" parameter for normal
>> extents, then passing 0 for the "physical length" makes absolutely
>> no sense.
>>=20
>> IOWs, what you have created is a distinction between the extent's
>> "logical length" and it's "physical length". For uncompressed
>> extents, they are both equal and they should both be passed to
>> fiemap_fill_next_extent as the same value. Extents where they are
>> different (i.e.  encoded extents) is when they can be different.
>> Perhaps fiemap_fill_next_extent() should check and warn about
>> mismatches when they differ and the relevant flags are not set...
>=20
> Seems reasonable to have a WARN_ONCE() in that case.  That would catch =
bugs
> in the filesystem, code as well:
>=20
> 	WARN_ONCE(phys_len !=3D lgcl_len &&
> 		  !(flags & FIEMAP_EXTENT_DATA_COMPRESSED),
> 		  "physical len %llu !=3D logical length %llu without =
DATA_COMPRESSED\n",
> 		  phys_len, logical_len, phys_len, logical_len);
>=20
>>> diff --git a/include/uapi/linux/fiemap.h =
b/include/uapi/linux/fiemap.h
>>> index 93abfcd..0e32cae 100644
>>> --- a/include/uapi/linux/fiemap.h
>>> +++ b/include/uapi/linux/fiemap.h
>>> @@ -19,7 +19,9 @@ struct fiemap_extent {
>>> 	__u64 fe_physical; /* physical offset in bytes for the start
>>> 			    * of the extent from the beginning of the =
disk */
>>> 	__u64 fe_length;   /* length in bytes for this extent */
>>> -	__u64 fe_reserved64[2];
>>> +	__u64 fe_phys_length; /* physical length in bytes, undefined if
>>> +			       * DATA_COMPRESSED not set */
>>> +	__u64 fe_reserved64;
>>> 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
>>> 	__u32 fe_reserved[3];
>>> };
>>=20
>> The comment for fe_length needs to change, too, because it needs to
>> indicate that it is the logical extent length and that it may be
>> different to the fe_phys_length depending on the flags that are set
>> on the extent.
>=20
> Would it make sense to rename fe_length to fe_logi_length (or =
something,
> I'm open to suggestions), and have a compat macro:
>=20
> #define fe_length fe_logi_length
>=20
> around for older applications?  That way, new developers would start =
to
> use the new name, old applications would still compile for both newer =
and
> older interfaces, and it doesn't affect the ABI at all.
>=20
>> And, FWIW, I wouldn't mention specific flags in the comment here,
>> but do it at the definition of the flags that indicate there is
>> a difference between physical and logical extent lengths....
>=20
> Actually, I was thinking just the opposite for this field.  It seems =
useful
> that the requirement for DATA_COMPRESSED being set is beside =
fe_phys_length
> so that anyone using this field sees the correlation clearly.  I don't =
expect
> everyone would read and understand the meaning of all the flags when =
looking
> at the data structure.
>=20
> Cheers, Andreas
>=20
>>> @@ -50,6 +52,8 @@ struct fiemap {
>>> 						    * Sets =
EXTENT_UNKNOWN. */
>>> #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can =
not be read
>>> 						    * while fs is =
unmounted */
>>> +#define FIEMAP_EXTENT_DATA_COMPRESSED	0x00000040 /* Data is =
compressed by fs.
>>> +						    * Sets =
EXTENT_ENCODED */
>>=20
>> i.e. here.
>>=20
>> Cheers,
>>=20
>> Dave.
>> --=20
>> Dave Chinner
>> david@fromorbit.com
>=20
>=20
> Cheers, Andreas
>=20
>=20
>=20
>=20
>=20


Cheers, Andreas






--Apple-Mail=_EB988F7E-B0DC-452A-BBB0-40EEBDBADAE7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU8doPXKl2rkXzB/gAQIZ7Q/+O1cLLU7hlJCt0crwEJSvXr5emItdtgIq
hW38z7p02SwbFbr9xkDlCiRGOG7CU9VibUEkol4bLOdX7EltvPJ4uiFCTzbIBWIT
8dLUkJYlw1K5PyS/Op+9P1vil+Oxse90O1PLJbPH3PYQ/T8dfOA7hUieF9vtPoNq
iNp5KQXDSyoXG2g+6R0r6kYss7t/YCaaNAr3XOazeN3OyNitW51/XNQT0l7YMX7n
YC2GhShDHMgReKI26BNmJQEhbJ5/vv8SulozVF3v/8pUi1D5OgVHa7FeiANO9VvR
5fqPbd0VcHJLftfuGMP339uCIx5ZaB87zK3brJ/4XQOLE45FTRs/MkMF5/Pna7WU
mZehgBZdq0Ijmqr4GCGavI0ukR5NT7cC77L1p3iRE3cqb+9SOytpBDMWx4v5xHU7
0+8bt7Ad0bm83REVxh7dSRn9eNU+Qy+7a/Qwyw/b/QSPAywXN0x6nLuyDSnmZpIt
nIdjwSWzxtAl41wbA/vEuXNY6WCV/vndbmMyPONJjOiWQYnEAkQ9WUVUvEkm1oXO
n1vxKfrjsUwyhDaEVDGKlbwUiczjedRBTUzmx5HnStinLV11u4rNw1+gaAVFb7jQ
o8N1CtgC+iiRIf3qu3Rc0ZJBjREDbZinIziElc0/x/SbmasOPZMN6WXoSLVWzd6r
mrc1S77/RLE=
=J9bc
-----END PGP SIGNATURE-----

--Apple-Mail=_EB988F7E-B0DC-452A-BBB0-40EEBDBADAE7--


--===============3614905744946436750==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3614905744946436750==--
