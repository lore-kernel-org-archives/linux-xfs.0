Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3CGFrcP181552 for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 11:15:53 -0500
Received: from x.digitalelves.com (x.digitalelves.com [209.98.77.55]) by
	cuda.sgi.com with ESMTP id Hjj04FulGZG3bJ1u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Apr 2012 09:15:52 -0700 (PDT)
Message-ID: <4F86FFAC.6030904@thebarn.com>
Date: Thu, 12 Apr 2012 11:15:40 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [PATCH] disable tags in post-receive hook
References: <20120411162627.GJ1802@sgi.com>
	<4F86971A.1030507@hardwarefreak.com>
In-Reply-To: <4F86971A.1030507@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4909586223236815277=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: stan@hardwarefreak.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============4909586223236815277==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA7C549A80456B53DBDF5025C"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA7C549A80456B53DBDF5025C
Content-Type: multipart/mixed;
 boundary="------------060205060302020408050003"

This is a multi-part message in MIME format.
--------------060205060302020408050003
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 4/12/12 3:49 AM, Stan Hoeppner wrote:
> On 4/11/2012 11:26 AM, Ben Myers wrote:
>> Hey Folks,
>>
>>     Yesterday I pushed tags to the oss.sgi.com xfs git repository and =
forgot to
>>     disable the post-receive hook which generates email to the list at=
 commit
>>     time.  You probably saw the resulting mailbomb.  I'm sorry about t=
hat.  In
>>     order to make sure it doesn't happen again next time, I have appli=
ed the
>>     following patch to our post-receive hook:
>=20
> I curse you for the error Ben and praise you for this correction.
> Mailman unsubbed me sometime yesterday according to a subject line.
> There was no body, no reason give.  But, I know the cause.
>=20
> I was limiting concurrent SMTP connections to 1 to fight runaway bots.
> Was working great until this bombing run.  The OSS list server runs
> Sendmail, which is dumb and opens a new connection for every message
> delivery.  This behavior can potentially bring an MX to its knees due t=
o
> smtpd process starvation.
Hmm yes and no.
There was some config issues with with queues on oss that hopefully I
have significantly improved. Sendmail does do connection caching and
will deliver as much mail as possible on the same connection as
possible. The problem was that the queue runnners was set to 400 runners
which was essentially was causing oss to grind itself into the ground
and causing enough delays that most connection caches where probably
timing out.

Also the queue sorting has been changed from the default "priority" sort
which basically will be a time sort in this case to "host" sort which
will try to optimize envelope address delivery. For a mail list server
this should be a significant win since it should be able to better take
advantage of the connection cache. (especially when "tag" bombs happen).

The queue run time has been changed from the default of 30m to 1m which
should cut the mail list delays down significantly.

Changed the drive queue scheduler from cfq to deadline

I've been watching the headers since the change and the turn around
times for mail leaving the originating host to landing in my mail server
is about 1 - 2 min. Occasionally there is a delay on sgi's barracuda box
but that is whole other box of worms.

Please send me any observations  + or - so I know if the tuning is
headed in the right direction.

-Russell

>=20
> Postfix on the other hand will open one connection and keep sending
> until all mail queued for the destination MX has been sent, or until
> there is more than a 2 second delay between deliveries.
>=20
> I understand Brent Bice of SGI is building an 'evidence file' to justif=
y
> a rebuild of OSS to use Postfix and the latest Mailman.  Maybe you coul=
d
> lend your support or blessing.
Heh another can of worms :-)

>=20
> The current OSS list server has other problems as well, including large=

> delays between receiving posts and sending them back out.  I'm assuming=

> I'm not the only one to notice this.
>=20
> Thanks.
>=20


--------------060205060302020408050003
Content-Type: text/x-vcard; charset=utf-8;
 name="cattelan.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="cattelan.vcf"

begin:vcard
fn:Russell Cattelan
n:Cattelan;Russell
org:Digital Elves Inc
adr:;;2824 Lakeview Ave;Roseville;MN;55113;usa
email;internet:cattelan@digitalelves.com
tel;work:612 293 6009
tel;cell:612 805 3144
x-mozilla-html:FALSE
url:http://digitalelves.com
version:2.1
end:vcard


--------------060205060302020408050003--

--------------enigA7C549A80456B53DBDF5025C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+G/68ACgkQNRmM+OaGhBiQWwCdGRHDqfVcfSfpL9II9rHV3xND
7kMAnjwlHsLVxtTzMdx7RbPXg5zTIX+m
=hcQW
-----END PGP SIGNATURE-----

--------------enigA7C549A80456B53DBDF5025C--


--===============4909586223236815277==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4909586223236815277==--
