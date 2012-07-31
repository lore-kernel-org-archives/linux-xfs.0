Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6V164tO115765 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 20:06:04 -0500
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id KFB4OIChy6g8GCxG
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 18:06:03 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: followup on benchmarks of an xfs embedded system (without rt
	section)
In-Reply-To: <20120730221105.GK2877@dastard>
References: <CAGou9Mhz-ez5nnzVAoRbp-E93NqBjT-wgGyHvrLkC7jEzJBagw@mail.gmail.com>
	<20120730221105.GK2877@dastard>
Date: Tue, 31 Jul 2012 11:06:00 +1000
Message-ID: <87r4rssps7.fsf@flamingspork.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4558333865049052492=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Jason Newton <nevion@gmail.com>
Cc: xfs@oss.sgi.com

--===============4558333865049052492==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> writes:

> On Fri, Jul 27, 2012 at 03:35:40AM -0700, Jason Newton wrote:
>> I've attached my benchmark program but I use alot of boost c++ with a
>> little internal set of libraries... so you can see what I"m doing but it
>> likely won't compile for you.  I'll also mention that boost is a very low
>> overhead (if any) over all the normal system calls one would use (verifi=
ed
>> by reading sourcecode in use).
>
> I'd suggest rewriting it so we can compile and run it. If I can
> reproduce the problem, I can at least understand where the latency
> is coming from.

The boost::chrono usage is the weirdest one that'll likely cause
issues. Should be replaced with boost::posix_time instead (it's been
around a lot longer)... otherwise it's just having to install all the
boost headers I think (boost is basically 99.9% implemented in header
files and templates)

=2D-=20
Stewart Smith

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQFy94AAoJEP08notdpDyvEZsP/izVdY7/aGFZMxTkVlE47QVr
9VCDgvf4jQviI//nXMX0Em9knLWpIRz68fZK84CIppV7N67nTL4SI3SNkSpCQGmi
503jXJ1JtcRYL8/Pq6JUuuq2EaGneM8DBiP2Qs7jT7V6OPUevL2aDVCC8yjvjtfM
tMztY3OMZOFfC8xx63QyLY8V9EcpVkcpGWYuJgcrmpYEWbDYxecfB7iAVqyaV5bH
xCgUW/+gsyQHRUECdYr3yBvFwUdm7YeLWtPrwBqjR8NcaSjPsp8FQcqaloSh08M/
A6PoOiMKlLpy8J0fugvS1n625SGOxzsBEtwQDNjQuVt+lYb7SOXePoOf/4dNARDX
zdMkoWkkRPwRQ0CJnoe2opafyubkNY+o3IPPgku/KULZ56zJE/3b209T/T+ZUE30
DN0D9AwM0yX0OtxBwRIuD+qKA2++xkcJcmjS/4meTOORcozaopm/ttyw6MHHfM1h
OQI8yzTCB5N3YCk+rcvG5gL4z1qIjNM8XCeSpWid0IMiElfVhpwGRwoenkKOKoJT
gi3NR920F6MQXdM6ROTqJpO36kL1/b2lP/E/vZtG/G8xDHYj9T/bd6MGSAkaHCDH
3eutS0yrUmJX8Ptt3t5AnwNMvNVyTpD8HajS9EcRCMq4hVRJJqO6Y8RqF3/pX+wL
/33ds7+oVvgyKuUTV7Al
=AbcR
-----END PGP SIGNATURE-----
--=-=-=--


--===============4558333865049052492==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4558333865049052492==--
