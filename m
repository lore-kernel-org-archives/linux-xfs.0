Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 82BDB7F3F
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 08:35:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 564FB304059
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 06:35:25 -0800 (PST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com
	[74.125.82.67]) by cuda.sgi.com with ESMTP id 5wKiqEqwQ4X2F3n7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Dec 2015 06:35:23 -0800 (PST)
Received: by mail-wm0-f67.google.com with SMTP id r67so3810135wmg.3
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 06:35:23 -0800 (PST)
Received: from Telcontar.valinor (188.Red-88-20-209.staticIP.rima-tde.net.
	[88.20.209.188]) by smtp.gmail.com with ESMTPSA id
	i84sm2598365wmc.20.2015.12.17.06.35.20 for <xfs@oss.sgi.com>
	(version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 17 Dec 2015 06:35:20 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id ABDC4611C7
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 15:35:19 +0100 (CET)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id iG_FvMtAaySA for <xfs@oss.sgi.com>;
	Thu, 17 Dec 2015 15:35:19 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 583E660E99
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 15:35:18 +0100 (CET)
Subject: Re: Ideas on unified real-ro mount option across all filesystems
References: <567212DA.8050808@cn.fujitsu.com> <567228EF.80007@redhat.com>
	<20151217032652.GD10582@birch.djwong.org>
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Message-ID: <5672C826.2010901@opensuse.org>
Date: Thu, 17 Dec 2015 15:35:18 +0100
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
To: xfs@oss.sgi.com

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

That's my understanding, too, but after some point in time. It was
explained to me some years ago after I found out that a disk image
mounted read only was modified. The trick was to make the image '-w'.

I have the vague feeling that once I found a problem when a mount
failed or crashed when the image was ro.


Just a user view on this :-)

- -- 
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlZyyBsACgkQtTMYHG2NR9VDYACfRd6Zzd60JzX6LoW1F2K4fSai
OJAAoJXgLlcrlFZy1U2MzCBaQ4cz0EmP
=s8oq
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
