Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 949357F50
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 20:05:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 242E7AC004
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 18:05:25 -0800 (PST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id jCJGGuUDgn7wzDr9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 Dec 2015 18:05:24 -0800 (PST)
Received: by mail-wm0-f51.google.com with SMTP id c201so11663516wme.0
	for <xfs@oss.sgi.com>; Wed, 09 Dec 2015 18:05:23 -0800 (PST)
Received: from minas-tirith.valinor (188.Red-88-20-209.staticIP.rima-tde.net.
	[88.20.209.188])
	by smtp.gmail.com with ESMTPSA id h7sm10561766wmf.0.2015.12.09.18.05.21
	for <xfs@oss.sgi.com>
	(version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 09 Dec 2015 18:05:22 -0800 (PST)
Received: from minas-tirith.valinor (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id DBACE1813D1
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 03:05:20 +0100 (CET)
Subject: Re: handling device or resource busy errors.
References: <CACQ+YcuwWv8g5zHk2sMfN_uRPGnW8Xb8WT6NGOLGigN2+0Toag@mail.gmail.com>
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Message-ID: <5668DDE0.7050203@opensuse.org>
Date: Thu, 10 Dec 2015 03:05:20 +0100
MIME-Version: 1.0
In-Reply-To: <CACQ+YcuwWv8g5zHk2sMfN_uRPGnW8Xb8WT6NGOLGigN2+0Toag@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2015-12-10 01:25, Ed Peschko wrote:
> All,
> 
> we are 'getting device or resource busy' errors which we *know*
> are spurious (lsof shows nothing, no multipath daemon, the
> partition that we are trying to access was just created).

I don't know if this is the case, but sometimes, when creating
filesystems under a graphical desktop (like gnome or kde) automatic
systems on those desktops would probe the new partition and try to
find its type and mount it, without action on my part. Even in the
middle of formatting!

I had to resort to using "less clever" desktops, even text mode.

Just a wild shot.


HTH. :-)

- -- 
Cheers / Saludos,

		Carlos E. R.

  (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlZo3eAACgkQja8UbcUWM1zWxAD/armZwbBoH0u5phhhuLg9ZqsO
SUMbHtK9sljugVJj4GEA/j0Hnp0hO6H1u6d2qXIJ62HDK0HOz592bwrsLNAsonnm
=RP1s
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
