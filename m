Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F48E7CA0
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 09:18:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D63618F8040
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 07:18:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bZDC2hBa10vEYwZS for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2016 07:18:35 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E53309A
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 09:18:35 -0500 (CDT)
Subject: Re: [PATCH] xfs: Document error handlers behavior [V2]
References: <1470734124-65204-1-git-send-email-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5d4e9f1e-0c7d-6804-5d19-d38dbd8d05cf@sandeen.net>
Date: Wed, 31 Aug 2016 09:18:25 -0500
MIME-Version: 1.0
In-Reply-To: <1470734124-65204-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9025131138818663027=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============9025131138818663027==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="TgF0JhGbI7Sxmwc8A77F2W1D8SacFUDs7"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TgF0JhGbI7Sxmwc8A77F2W1D8SacFUDs7
Content-Type: multipart/mixed; boundary="59rUIDKH1Sp6wTRl3CSlI2GHJL1CDmQDg";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs@oss.sgi.com
Message-ID: <5d4e9f1e-0c7d-6804-5d19-d38dbd8d05cf@sandeen.net>
Subject: Re: [PATCH] xfs: Document error handlers behavior [V2]
References: <1470734124-65204-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1470734124-65204-1-git-send-email-cmaiolino@redhat.com>

--59rUIDKH1Sp6wTRl3CSlI2GHJL1CDmQDg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/9/16 4:15 AM, Carlos Maiolino wrote:
> Document the implementation of error handlers into sysfs.
>=20
> Changelog:
>=20
> V2:
> 	- Add a description of the precedence order of each option, focusing o=
n
> 	  the behavior of "fail_at_unmount" which was not well explained in V1=


Global: s/shutdown/shut down/g


> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  Documentation/filesystems/xfs.txt | 94 +++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 94 insertions(+)
>=20
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesyst=
ems/xfs.txt
> index 8146e9f..d483e0b 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -348,3 +348,97 @@ Removed Sysctls
>    ----				-------
>    fs.xfs.xfsbufd_centisec	v4.0
>    fs.xfs.age_buffer_centisecs	v4.0
> +
> +Error handling
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +XFS can act differently according with the type of error found

"according to"

> +during its operation. The implementation introduces the following
> +concepts to the error handler:
> +
> + -failure speed:
> +	Defines how fast XFS should shutdown in case of a specific
> +	error is found during the filesystem  operation. It can
> +	shutdown immediately, after a defined number of tries, or
> +	simply try forever, which was the old behavior and is now
> +	set as default behavior, except during unmount time, where
> +	in case of a error is found while unmounting, the filesystem
> +	will shutdown.

Defines how fast XFS should shut down when a specific error is found
during filesystem operation.  It can shut down immediately, after a
defined number of retries or after a set time period, or simply retry
forever.  The old "retry forever" behavior is still the default, except
during unmount, where any IOs retrying due to errors will be cancelled
and unmount will be allowed to proceed.

> +
> + -error classes:
> +	Specifies the subsystem/location where the error handlers
> +	configure the behavior for, such as metadata or memory allocation.

Specifies the subsystem/location for the error handlers, such as
metadata or memory allocation.  Only metadata IO errors are handled=20
at this time.
> +
> + -error handlers:
> +	Defines the behavior for a specific error.
> +
> +The filesystem behavior during an error can be set via sysfs files, wh=
ere, the

s/where,/where/

> +errors are organized with the following structure:
> +
> +  /sys/fs/xfs/<dev>/error/<class>/<error>/

where <dev> is the device name for the mounted filesystem.

> +
> +Each directory contains:
> +
> + /sys/fs/xfs/<dev>/error/
> +
> +	fail_at_unmount		(Min:  0  Default:  1  Max: 1)
> +		Defines the global error behavior during unmount time. If set to
> +		"1", XFS will shutdown in case of any error is found, otherwise,
> +		if set to "0", the filesystem will indefinitely retry to cleanly
> +		unmount the filesystem.

Defines the global error behavior at unmount time.  If set to the default=
 value of
1, XFS will cancel any pending IO retries, shut down, and unmount.  If se=
t to
0, pending IO retries may prevent the filesystem from unmounting.

> +
> +	<class> subdirectories
> +		Contains specific error handlers configuration
> +		(Ex: /sys/fs/xfs/<dev>/error/metadata).

+		(Ex: /sys/fs/xfs/<dev>/error/metadata, see below)

> +
> + /sys/fs/xfs/<dev>/error/<class>/
> +

	Directory containing configuration for a specific error <class>;
	currently only the "metadata" <class> is implemented.

> +	The contents of this directory are <class> specific, since each <clas=
s>
> +	might need to handle different types of errors.

Remove this part:

> +     All <error> directory
> +	though, contains the "default" directory, which is a global configura=
tion
> +	for errors not available for independent configuration.

because there is no "default" under the <error> - and you haven't describ=
ed
<error> yet, anyway... "default" is covered properly below.

> +
> + /sys/fs/xfs/<dev>/error/<class>/<error>

/sys/fs/xfs/<dev>/error/<class>/<error>/

to indicate that it is a directory, not a file.

> +
> +	Contains the failure speed configuration files for each specific erro=
r,
> +	including the "default" behavior, which contains the same configurati=
on
> +	options as the specific errors.
> +
> +	The available configurations for each error type are:

Contains the failure speed configuration files for specific errors in thi=
s
<class>, as well as a "default" behavior.  Each <error> directory contain=
s
the following configuration files; the first condition met for a specific=

configuration will cause the filesystem to shut down:

> +
> +	max_retries			(Min: -1  Default: -1  Max: INTMAX)
> +		Define how many tries the filesystem is allowed to retry its
> +		operations during the specific error, before shutdown the
> +		filesystem. Setting this file to "-1", will set XFS to retry
> +		forever in the specific error, setting it to "0", will make
> +		XFS to fail immediately after the specific error is found,
> +		while setting it to a "N" value, where N is greater than 0,
> +		will make XFS retry "N" times before shutdown.

Defines the allowed number of retries of a specific error before the file=
system
will shut down.  The default value of "-1" will cause XFS to retry foreve=
r
for this specific error.  Setting it to "0" will cause XFS to fail immedi=
ately
when the specific error is found, and setting it to "N," where N is great=
er
than 0, will make XFS retry "N" times before shutting down.

> +
> +	retry_timeout_seconds		(Min:  0  Default:  0  Max: INTMAX)
> +		Define the amount of time (in seconds) that the filesystem is
> +		allowed to retry its operations when the specific error is
> +		found. "0" means no wait time.

does "no wait time" mean shut down immediately, or ignore the wait time
altogether?  I think it is the latter, so:

Define the amount of time (in seconds) that the filesystem is allowed to
retry its operations when this specific error is found.  The default
value of "0" will cause XFS to retry forever.

Right?

As an aside, I'm not sure why we don't have the consistency of "-1"
meaning "ignore this setting" as we do for max_retries.  Dave, think it's=

too late to change that?

> +
> +
> +
> + Order of precedence:
> +		"max_retries" takes precedence over "retry_timeout_seconds",
> +		where, "retry_timeout_seconds" will only be tested if
> +		"max_retries" limit was not reached yet or is set to retry
> +		forever ("-1"). If "max_retries" limit is reached, the
> +		filesystem will shutdown, wether or not "retry_timeout_seconds"
> +		has been reached.

This doesn't seem quite right.  Isn't it simply the *first* threshold to =
be
reached, whether it is max_retries or retry_timeout_seconds?  So that's n=
ot
really an order of precedence.  I think:

I think that all of this can be simply moved up to the descriptions above=
=2E


> +		"fail_at_unmount" on the other hand, works independently of the
> +		remainder options. It will only be tested during unmount time,
> +		but, it will shutdown the filesystem independent of the limits
> +		set into "max_retries" or "retry_timeout_seconds".
> +		It has been added because sysfs configuration can't be changed
> +		after an unmount is triggered, once the sysfs directory from
> +		the filesystem being unmounted will be detached from the sysfs
> +		tree, so, even if the sysadmin wants to make XFS retry forever
> +		for any error during the filesystem operation, the filesystem
> +		can still be properly unmounted if any error was detected and
> +		"fail_at_unmount" is set. Otherwise, the umount process get
> +		stuck forever.
>=20

I'd leave this all out.


--59rUIDKH1Sp6wTRl3CSlI2GHJL1CDmQDg--

--TgF0JhGbI7Sxmwc8A77F2W1D8SacFUDs7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXxuc7AAoJECCuFpLhPd7gGeoP/jmWHAolrQOXuz33tRRLFHjZ
aqqGJalJi0I80f9QevUcnqa62tCjtameL4sUCsEzuyK6Z0gHkX97pnxY8elqL3gd
1p6zFdWj6JSFCRRHGJuVasq8CZguyx8TCOvZUJ+3aQgK8dtQgjOHKT2OkyaZQflO
qh6bdxIxl4W/Vhie4lso+l4OQixoTOFTDP+Lx4El1qxiijan8bzhnXCRaOTC3EWX
Aiy8xzVDYwslkL+dql+3KFYkrrIH3Nec81TjHU8bVqJtYUCS2qWxpPuYeIKitsHB
dYdT04H3+FBFnOmqmZwUVHzt8HxE4oJ1DjEWqCd8DWQPz1T7Y6GDQHkLGbyMUEdP
iwJA6YtbjLVHl71pMLJ9cA49gZC7BmPsKXuBqitr/+wFofIzafs6vf7hX2plTfBQ
UW74YrYV9TdhMQXZ1+n8wMq4COPXamfHgqElgOABXA92igp/pnhVptSljK0SI1Q+
SmHrYEJsP3Jj4dj9vg9Iat+fzh8jdsPZSFT5Tqc7GMrHWUWlSAPzCbmWg8JXjcSx
fwLGRdOFSkbT7uf9jBXPgVQ8Ys7BTLebIHHs58erUKtkndZf+6I9wmQrTH28p+Kt
y5qMekQ4HgQsxMNqYtxdVLca0JSWKfEF7cWNYygkZY5zEyIIrildZgNlu3ehgsM0
Wuz2P8DFSzbFQFx3fekG
=uNzY
-----END PGP SIGNATURE-----

--TgF0JhGbI7Sxmwc8A77F2W1D8SacFUDs7--


--===============9025131138818663027==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9025131138818663027==--
