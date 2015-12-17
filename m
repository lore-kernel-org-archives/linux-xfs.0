Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38D147F3F
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 08:58:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA79FAC001
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 06:58:29 -0800 (PST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com
	[74.125.82.66]) by cuda.sgi.com with ESMTP id LZyLkEZWJE8LEDpQ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Dec 2015 06:58:28 -0800 (PST)
Received: by mail-wm0-f66.google.com with SMTP id r67so3954983wmg.3
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 06:58:28 -0800 (PST)
Received: from Telcontar.valinor (188.Red-88-20-209.staticIP.rima-tde.net.
	[88.20.209.188]) by smtp.gmail.com with ESMTPSA id
	e136sm2669180wma.23.2015.12.17.06.58.25 for <xfs@oss.sgi.com>
	(version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 17 Dec 2015 06:58:26 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 2A9C8611C7
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 15:58:25 +0100 (CET)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 21sc0i2i_Quv for <xfs@oss.sgi.com>;
	Thu, 17 Dec 2015 15:58:25 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id D8F0C60E99
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 15:58:24 +0100 (CET)
Subject: Re: Ideas on unified real-ro mount option across all filesystems
References: <567212DA.8050808@cn.fujitsu.com> <567228EF.80007@redhat.com>
	<20151217032652.GD10582@birch.djwong.org>
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Message-ID: <5672CD90.7020805@opensuse.org>
Date: Thu, 17 Dec 2015 15:58:24 +0100
MIME-Version: 1.0
In-Reply-To: <20151217032652.GD10582@birch.djwong.org>
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
To: XFS mail list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2015-12-17 04:26, Darrick J. Wong wrote:
> On Wed, Dec 16, 2015 at 09:15:59PM -0600, Eric Sandeen wrote:

>> I have always interpreted it as simply "no user changes to the
>> filesystem," and that is clearly what the vfs does with the
>> flag...
> 
> That ("-o ro means no user changes") has always been my
> understanding too.  You /want/ the FS to replay the journal on an
> RO mount so that regular FS operation picks up the committed
> transactions.
> 
> --D

That's my understanding, too, but after some point in time, not
initially. It was explained to me some years ago after I found out
that a disk image mounted read only was modified. The trick was to
make the image '-w'.

I also have the vague feeling that once (years ago) I found a problem
when a mount failed or crashed when the image was ro.


Just a user view on this :-)

- -- 
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlZyzYkACgkQtTMYHG2NR9VDNwCfehM5NHMAgZuuzLf99kKulLKI
AkAAnjt4mZngHZdH5v60T+P6tnnFzUiO
=Pw+f
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
