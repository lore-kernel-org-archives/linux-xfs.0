Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 26AAE7F37
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 16:45:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B64F0AC009
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 14:45:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	c0riDHdypvvb5Z9U for <xfs@oss.sgi.com>;
	Fri, 24 Oct 2014 14:45:29 -0700 (PDT)
Date: Sat, 25 Oct 2014 08:45:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem about very high Average Read/Write Request Time
Message-ID: <20141024214525.GA4317@dastard>
References: <CALSoAzD4ccHXBuD6mT3ggqMf1j_kDEK-RNMOeRLq+N+NiWVQXg@mail.gmail.com>
	<20141018143848.3baf3266@galadriel.home>
	<21571.36364.518119.806191@tree.ty.sabi.co.uk>
	<5444C122.4080104@fastmail.fm>
	<21574.42382.795064.152229@tree.ty.sabi.co.uk>
	<54492AD5.3040704@fastmail.fm>
	<21577.24715.712978.617220@tree.ty.sabi.co.uk>
MIME-Version: 1.0
In-Reply-To: <21577.24715.712978.617220@tree.ty.sabi.co.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4710254655230706684=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg@xfs.list.sabi.co.UK>
Cc: Linux fs XFS <xfs@OSS.SGI.com>


--===============4710254655230706684==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 09:09:47PM +0100, Peter Grandi wrote:
> >>> Where do you get the assumption from that FhGFS/BeeGFS is
> >>> going to do random reads/writes or the application of top of
> >>> it is going to do that?
>=20
> >> In this specific case it is not an assumption, thanks to the
> >> prominent fact that the original poster was testing (locally I
> >> guess) and complaining about concurrent read/writes, which
> >> result in random like arm movement even if each of the read and
> >> write streams are entirely sequential.
>=20
> [ ... ]
>=20
> > Low speed and high latencies are not sufficient information to
> > speculate about the cause.
>=20
> It is pleasing that you seem to know at least that by themselves
> =ABLow speed and high latencies=BB are indeed not sufficient.
>=20
> But in =ABthe specific case=BB what is sufficient to make a good guess
> is what I wrote, which you seem to have been unable to notice or
> understand.

Peter, I really don't care if you are right or wrong, your response
is entirely inappropriate for this forum. Wheaton's Law:

	"Don't Be a Dick."

Bernd is entitled to point out how tenuous your thread of logic is -
if he didn't I was going to say exactly the same thing - it is based
entirely on a house of assumptions you haven't actually verified.

An appropriate response would be to ask the OP to describe their
workload and storage in more detail so you can verify which of your
asumptions were correct and which weren't, and take the discussion
=66rom there. But instead of taking the evidence-based verification
path, you've resorted to personal attacks to defend your tenuous
logic.

That is out of line and not acceptible behaviour.

Knowledge is not a cudgel to beat people down with. Nobody really
cares how much you know, nor do they need you to try to prove you
know more than they do. If you succeed in proving how much of an
Expert(tm) you are, then the only thing that people will remember
about you is "what a dick that guy is".

Unfortunately, Peter, you've made a habit of this behaviour. Every
discussion thread you enter ends up with you abusing someone because
they dared to either question your assertions or didn't understand
what you said precisely.  Indeed, I've come to assosicate your name
with such behaviour over the past couple of years, to the point
where I see your name in a thread and I wonder what will trigger you
to abuse someone before I've even read the email.

With this email, you've finally reached my Intolerable Dickhead On
The Internet Threshold. Given that this is on the XFS mailing list,
and I'm the XFS Maintainer it falls to me to draw a line in the
sand: such behaviour is not acceptible in this forum.

In future, Peter, please do not post to the list if you can't be
nice or stay on topic. We don't need you to "help" by abusing
people; we get along and solve problems just fine without you. Hence
if you can't play nicely with others then please go away and don't
come back.

-Dave.
--=20
Dave Chinner
david@fromorbit.com

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUSsh0AAoJEK3oKUf0dfodJVIP/3AtghnSkekVnecW1ohKMQJb
Ts/SrT1mv7FlrOdPMRctk88zgn8f47i+7b7nyjLXOZNJ/aQfT2V70OKB3C4o1p5q
AdSDSBU4h1EY3E3QpL+Jy0Yal1whL5UucLkXsrnoFR490KtZZPpjfJ2qigKB7P7X
tXKEo4GLvWbPzZcOngiO7X2T7dvSft/8p+2sdbNBPkgKSI8QxaZmNco0aRpRwPJ8
RbrKO3enlJ9lQK+V8MYgOvk+TWoW6w6xONEa9LSN15yYUID+GX4koo9HRoG3UiX1
yxNDfvUKBLKwGpnjHSI8h2+wjKZW4JZvEcn2rcbAevpS0d06ZYL+irZoSFqazs48
9OtmV0S1mknEyD1r+ga/NtxJZrsjajlvq4Rn1G4jblbMtmtV+oVlg4La4IDfKBIG
rXTeYcehp1Pj2e8uj0VV+dgxwXCIwKeEeh8QZ36zb9BkWZZlJpc3TTP4/3iAVF1h
hcn+k+FHnM5tawzU3LVxRmbKS+8oyB7F2S1X6wLYt1/1lb/t/MIt7SAAwuGRITlZ
H0OM0+sTWzDFfPMwluoBSu6iiEJJae+12klfSfPgvMzamD4mvVvr/cWqHtOWlxT4
X2JsfoCNIklUCMHpd7lvyWpRTTj/ErjFNJH52Hxx7RTjRPTkKWa/8BGyACsBDwFK
MAUdgT5xA1cOxh/zcgQs
=a4+W
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--


--===============4710254655230706684==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4710254655230706684==--
