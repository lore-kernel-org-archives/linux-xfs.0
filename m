Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 54C677F37
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 07:13:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF7C6AC00A
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 05:13:42 -0700 (PDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	yzEPwpuGDefdgEB9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 05:13:40 -0700 (PDT)
Received: by wiclk2 with SMTP id lk2so25748523wic.0
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 05:13:39 -0700 (PDT)
Received: from minas-tirith.valinor (3.Red-83-42-78.dynamicIP.rima-tde.net.
	[83.42.78.3]) by smtp.gmail.com with ESMTPSA id
	l17sm20798305wjr.18.2015.09.15.05.13.38 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 15 Sep 2015 05:13:38 -0700 (PDT)
Received: from minas-tirith.valinor (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 1EE87183EC1
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 14:13:37 +0200 (CEST)
Subject: Re: xfsrestore and multi-tape backups
References: <20150908144806.GA22811@teal.hq.k1024.org>
	<20150915093653.GA31370@teal.hq.k1024.org>
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Message-ID: <55F80B70.4090103@opensuse.org>
Date: Tue, 15 Sep 2015 14:13:36 +0200
MIME-Version: 1.0
In-Reply-To: <20150915093653.GA31370@teal.hq.k1024.org>
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

On 2015-09-15 11:36, Iustin Pop wrote:
> So what's the correct way to restore a multi-tape dump? (Man page
> says to start with tape 1, but that doesn't seem to be working).

I don't know about your case, so I maybe totally wrong. But it is
possible that the catalog or index is stored on the last tape only,
which might explain why starting with the second tape works (if I read
correctly your post).

- -- 
Cheers / Saludos,

		Carlos E. R.

  (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlX4C3AACgkQja8UbcUWM1zclgD7BDYcqlZDq7CGDP2wMaOe/f8Z
LRcM/QZVK7LBw92ptBAA/iI9mB8Y/hP7fxcESBe9FIrKxguAcsVq8tr9FJDq+hiM
=Cf72
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
