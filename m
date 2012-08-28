Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7S7Hrln059005 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 02:17:53 -0500
Received: from mail.vlasiu.net (mail.vlasiu.net [91.223.50.125]) by
	cuda.sgi.com with ESMTP id ZpnQ8rgWV1Vg9kKK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Aug 2012 00:18:41 -0700 (PDT)
Date: Tue, 28 Aug 2012 10:18:31 +0300 (EEST)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: umount doesn't seem to really unmount
In-Reply-To: <503C0582.3080009@sandeen.net>
Message-ID: <alpine.LRH.2.02.1208280958060.29519@mail.vlasiu.net>
References: <CAAxjCEwdYbcDoUvcAV1n8281HCCvrCvReaG2oM5+h+WV5yDZvA@mail.gmail.com>
	<1104CDC2-47D2-40CF-8294-A17E33125D54@sandeen.net>
	<CAAxjCExx8LB3PyMUR8T215hMYps17D+Lvg4C0aOwLwD=d-NOMQ@mail.gmail.com>
	<alpine.LRH.2.02.1208270952390.8166@mail.vlasiu.net>
	<CAAxjCEynRoS3AfYer=is725XR+kZEwe_SPxt_iDTJNRMo2UxOA@mail.gmail.com>
	<alpine.LRH.2.02.1208271016440.10454@mail.vlasiu.net>
	<503C0582.3080009@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Mon, 27 Aug 2012, Eric Sandeen wrote:

> Gah, is umount replaced by something via systemd?  I mean.... umount is
> still umount, no?
It's still umount. For how long... I don't know.
Seeing the latest and "greatest" achievements of this Poettering guy I 
just hope that Fedora 28 will not have just only one rpm package 
systemd-everything.

> IOW is this just doing a lazy unmount behind your back?
Yes. And it's driving me crazy. I mount a lot of file-systems via loop. 
And after a while, most of the time, I can umount the file-system but I 
cannot detach the loop device anymore. So a reboot is required. I did not 
have time to check if stopping all services with PrivateTmp fix this but 
I'm pretty sure it will.


Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 44952F15
// OpenGPG-Fingerprint: 4AC5 7C26 2FE9 02DA 4906  24B2 D32B 7ED7 4495 2F15
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQPHDHAAoJENMrftdElS8VUugP/1VRGg9L77VxYrQeG+o35x96
zMh5LxFqIL7h8gloNHI2xkHb8LlQbHqyOJn7jrpRoSDnxymDVefuCzE2dZDP0mx4
kEVyIYn12ElMqMmzdXMBJJI/4av17DTgohbYYHXM3FGyN0uow+6GihV2PcIOXsP6
dkFZ48O55Lc4hhJ4vNyrNl9K+MHDfcxPtQTx/aZ5JuNeMLK4ywROcRycsML6LPl4
5gfHzlg3dMWSKg9gCWZCETC82u4MCvaQ7L8mhTwsDCM/Kn4mFiEaYUpCDL/poDqI
OhUMpG+zt0qgoJ7rUjjQFHRO0ianiubAeV7ajnw4n4Nd+6+r9iohR65lAEclfgID
wskVEI3sAD3ZOdK2hL0SUaR4ZHQfx8ku/4BdmTG0PHA6+eO0Q+THXzWgP4dE5eQX
qK+ghTHFyiDd29b2fbKS5qLmz84hQQAHT4I/IszSJ85v2siuCxqhJ/xOfVRsvu0c
dNQc9h8KYTORvc1QVLs4l1cAIUuHqnk4LumLjvEFIly7+aXHg2rRZreqNkdRlkRf
MnXvlfKwxI6oSYqp09bDPy/nn8fnYcechALQeDPglSpADHLjGrNNjLchoA2y8Thi
hV6ytXpsEMp1vrcoKSLmVbE6bYThGNjKykMwKAXw3OnWWs3hpMCZYivgHi+G2TGa
A0FK89doR0ysDJtGxIdZ
=No5Y
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
