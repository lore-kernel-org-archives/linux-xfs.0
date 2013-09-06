Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4BD527F50
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 09:41:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2891E304059
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 07:41:15 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id TMwewtjimhlPDjc4 for <xfs@oss.sgi.com>;
	Fri, 06 Sep 2013 07:41:13 -0700 (PDT)
Message-ID: <5229E980.3000904@suse.com>
Date: Fri, 06 Sep 2013 10:41:04 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix device lookup in btrfs/003
References: <52266055.9050004@suse.com> <20130906140337.GK32382@twin.jikos.cz>
In-Reply-To: <20130906140337.GK32382@twin.jikos.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5638383918674976579=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: dsterba@suse.cz, Linux FS Maling List <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============5638383918674976579==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="rVwNBkkWOGKNK3PDMHI3ts77Rp9KVSSA5"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rVwNBkkWOGKNK3PDMHI3ts77Rp9KVSSA5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/6/13 10:03 AM, David Sterba wrote:
> On Tue, Sep 03, 2013 at 06:19:01PM -0400, Jeff Mahoney wrote:
>> The DEVHTL lookup in btrfs/003 is broken. It can only handle full LUNs=
 and
>> not partitions on a disk.
>>
>> Rather than returning 2:0:0:0 for /dev/sdc7, it returns 'block' and we=
 see:
>> ./common/rc: line 2081: /sys/class/scsi_device/block/device/delete:
>> No such file or directory
>>
>> If we look up the device by dev instead of by name, we can handle work=
ing
>> with full disks and partitions more easily and get the ability to use
>> any device name rather than just the ones that match sysfs.
>>
>> @@ -137,9 +137,21 @@ _test_replace()
>>  	#pick the 2nd last disk=20
>>  	ds=3D${devs[@]:$(($n-1)):1}
>> =20
>> -	# retrive the HTL for this scsi disk
>> -	d=3D`echo $ds|cut -d"/" -f3`
>> -	DEVHTL=3D`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`=

>> +	HEXMAJOR=3D"$(stat -c "%t" "$ds")"
>> +	HEXMINOR=3D"$(stat -c "%T" "$ds")"
>> +	if [ -z "$HEXMAJOR" -o -z "$HEXMINOR" ]; then
>> +		_fail "tr: HEXMAJOR and/or HEXMINOR is unset for $ds"
>> +	fi
>> +
>> +	DIR=3D"/sys/dev/block/$(( 0x$HEXMAJOR )):$(( 0x$HEXMINOR ))"
>> +
>> +	if [ -L "$DIR/device" ]; then # whole disk
>> +		DEVHTL=3D"$(basename $(readlink "$DIR/device"))"
>> +	elif [ -L "$DIR/../device" ]; then # partition
>> +		DEVHTL=3D"$(basename $(readlink "$DIR/../device"))"
>> +	else
>> +		_fail "tr: Can't locate device backing $ds"
>> +	fi
>> =20
>>  	#fail disk
>>  	_devmgt_remove ${DEVHTL}
>=20
> The test assumes tha SCRATCH_DEV_POOL consists of standalone devices
> and more strongly that they can be removed from the system by
>=20
> $ echo 1 > /sys/class/scsi_device/sdx/device/delete
>=20
> via _devmgt_remove. Ordinary sdX devices are ok, but eg. MD devices are=

> not because they do not have a corresponding "2:0:0:0"-like entry (I
> haven't checked device-mapper devices).
>=20
> Looks like the tests have to do more fine grained checks of the devices=

> in SCRATCH_DEV_POOL because eg. the 'device replace' test btrfs/011 is
> just fine with partitions.

Yeah. It doesn't work with any type of device that doesn't present a
SCSI-style host interface with a delete sysfs entry. I wasn't looking to
make it work everywhere, just allow it to work with the types of devices
it was originally targeting in a slightly less fragile way.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--rVwNBkkWOGKNK3PDMHI3ts77Rp9KVSSA5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSKemDAAoJEB57S2MheeWy+JAQALipYPfwK8wOk3tfqpPDuyks
dG8WRbuRnhxeVolWcv0FlaagQUuDN+wmY6UoQ1ZiK6UoGXLzfmn2KjbLA8A0Js0c
a4Z8fRpHULCmMnZH5t+mopI8EiPN9QYrsIjV23w+U52mD/LecDp1QqGHDJiV88KN
KhoPa0p4rBgdu3UXwZQ+tPPgLy8A7yR9H+pLcrgrSWPlOCQiOo5NVWwnKa7BcEes
NxfKEN3QcDkFbPPRUOWY9ZEOpV8wP3gImsz4BAfdYNSW8u3xcSbKM+SIVkQ5eTIP
ivk8X/2Z8X2psRujjkYObiHA5FPXvFWLJiwQIuuaKkL09jobNaPGIl5vPuNVx0JF
EODRA8NDN0e8uyylQQQzRKDF0CKM/OYFdV4xuhv2KFgDdpnJhW1XRZ6qQZusl8sJ
SO8jlhtYkUhSwTuD1dv36TfVIfXvDkWF0UzS0zU+G4cHI6knLcMFFeXUrYWjsKwG
vd4T2UOHYQ+f1f1Ld3KzlZWACcojokp5NX2Uovx9bjuhnhqDpIruvmaykj/6sqEk
vPCH8ajwE6s8GSiY6XveLqcu8NRpnjRkCnt84pb9dHKIks/rQCeZ2e9RrtFmbHcF
46j8Tj66aTuW1U5CgwnRGmx01yEJcznqzl+qH6mb3UmQTrVXxQK+sIqIDiIY6KGO
oNSNqg6Ilj/aTCHBHrs8
=Mzda
-----END PGP SIGNATURE-----

--rVwNBkkWOGKNK3PDMHI3ts77Rp9KVSSA5--


--===============5638383918674976579==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5638383918674976579==--
