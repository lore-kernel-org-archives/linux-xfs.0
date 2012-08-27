Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RNe5WR003194 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 18:40:05 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id lQhOaYCE5IEcMJpJ for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 16:40:55 -0700 (PDT)
Message-ID: <503C0582.3080009@sandeen.net>
Date: Mon, 27 Aug 2012 18:40:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: umount doesn't seem to really unmount
References: <CAAxjCEwdYbcDoUvcAV1n8281HCCvrCvReaG2oM5+h+WV5yDZvA@mail.gmail.com>
	<1104CDC2-47D2-40CF-8294-A17E33125D54@sandeen.net>
	<CAAxjCExx8LB3PyMUR8T215hMYps17D+Lvg4C0aOwLwD=d-NOMQ@mail.gmail.com>
	<alpine.LRH.2.02.1208270952390.8166@mail.vlasiu.net>
	<CAAxjCEynRoS3AfYer=is725XR+kZEwe_SPxt_iDTJNRMo2UxOA@mail.gmail.com>
	<alpine.LRH.2.02.1208271016440.10454@mail.vlasiu.net>
In-Reply-To: <alpine.LRH.2.02.1208271016440.10454@mail.vlasiu.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gabriel VLASIU <gabriel@vlasiu.net>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/27/12 2:23 AM, Gabriel VLASIU wrote:
> On Mon, 27 Aug 2012, Stefan Ring wrote:
> 
>> It seems to happen with any service that has PrivateTmp set:
> Thanks. Stopping all services using PrivateTmp seems to fix the problem.
> systemd again... :-(
> 

Gah, is umount replaced by something via systemd?  I mean.... umount is
still umount, no?

IOW is this just doing a lazy unmount behind your back?

- -Eric

> Sincerely,
> Gabriel
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQPAWCAAoJECCuFpLhPd7gUgsQALWEEVT2MBfD/EAGkZn1OayZ
NXpJZeedYYA2mhoBxx7CD0QfJgzhmeZxMq2q/mmUIb7XWibnlOPeGJ9ieq6IJ7u3
0Izxs2VOKpeE93j5AOMoaEdoY7ncTPfiIq6pNqNMTK/LbW8iN2ej5vW7mSkErcTs
KmiyOubCoj27a8JXVyc1ZY/oFp82HmCsx0WLe5nxhBYSto1ochUZY2vXZy0sdem0
VGtrCa8uLBh4YDzq9s3aDEukYdqsSFGjCYvdVOGqQfLaDj78JVn8jqLVplcGmnrF
Knqv+suxuVwt/WVnp4vzK7707YxV2g/ys9RBit3CFjrj3AWnyPMdwzL6i+kKkDPI
h7xYpeUNSDfwdNrxdjmPOD7pegUxwNKc5Id0gIei+C8vbUgtaaMIkgRbQnlSa7e8
4T8iF+LS4VAi480svOEUVD0Yh4jznCqBmjh3jjO8wrgP4Md12rdV8HKCFYtcq3Uy
EWhWy4dlG9H0w1nRG7jqrcj2hjWVhYRnY3DkAg+E9adfr6LFoEejEFjSH0HTjs3j
h8niXZt19EFUNijbHkNbmpIyAuloEyK4qwJ0E1myE2llh2xax7licRcXs9rirJvU
biD1kW0x31Dhb1QuI3yRrD35peczWtdr6xYhn6+iWcJdq8xkS8hxooObzYjc5PaO
6VHp3AtZEHXekvJFvUPq
=YlDt
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
