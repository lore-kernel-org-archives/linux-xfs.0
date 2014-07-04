Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F2DED7F3F
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 08:37:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F3F578F8049
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 06:37:02 -0700 (PDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
	[209.85.212.175]) by cuda.sgi.com with ESMTP id
	OcXPEkAfPuHIsobJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Jul 2014 06:37:00 -0700 (PDT)
Received: by mail-wi0-f175.google.com with SMTP id r20so12950086wiv.14
	for <xfs@oss.sgi.com>; Fri, 04 Jul 2014 06:36:55 -0700 (PDT)
Received: from minas-tirith.valinor (90.Red-79-150-228.dynamicIP.rima-tde.net.
	[79.150.228.90]) by mx.google.com with ESMTPSA id
	cz4sm79307385wib.23.2014.07.04.06.36.53 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 04 Jul 2014 06:36:54 -0700 (PDT)
Received: from minas-tirith.valinor (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 90B6D18245B
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 15:36:47 +0200 (CEST)
Message-ID: <53B6ADEF.2000409@opensuse.org>
Date: Fri, 04 Jul 2014 15:36:47 +0200
From: "Carlos E. R." <carlos.e.r@opensuse.org>
MIME-Version: 1.0
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>	<20140702120441.GA51757@bfoster.bfoster>	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>	<20140703094347.GU4453@dastard>	<alpine.LSU.2.11.1407040113340.9881@Telcontar.valinor>	<20140704000426.GX4453@dastard>	<alpine.LSU.2.11.1407040317120.9881@Telcontar.valinor>	<20140704014008.GI9508@dastard>
	<20140704124049.GB12151@bfoster.bfoster>
In-Reply-To: <20140704124049.GB12151@bfoster.bfoster>
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

On 2014-07-04 14:40, Brian Foster wrote:


Thanks.



Yes, that's right.



Yes, certainly. I can do more hibernation cycles to try trigger it
again. Thunderbird is an application that I use a lot, it is always
open. I have several remote imap accounts, and one local imap account,
using a local dovecot daemon on another partition (which has not been
affected so far). It also pulls nntp from a local daemon (leafnode),
which uses a different partition, on reiserfs.

It is a complex setup, you see :-)



I'll investigate if it is possible.

Meanwhile, I have upgraded the xfsprogs package to version 3.2.0, and
the kernel has got an update to 3.11.10 (openSUSE policy is to
backport security patches, while maintaining the same kernel version
through the lifetime of a release, so that this kernel has in fact
additions and patches from more advanced versions).

Having upgraded xfsprogs, I'm right now in the process of
backup-format-restore this home partition again, to take advantage of
any modification this new xfsprogs package may have. I think I will
use this time rsync instead of xfsrestore, although it is much slower
- - unless you ask me to use xfsrestore.

- -- 
Cheers / Saludos,

		Carlos E. R.

  (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlO2re8ACgkQja8UbcUWM1yi7QD/b0V+gASfApDWNqIaf6nceWvr
IAGUb+jFwqGeZppqdEUA/1hqknkWDC7St4kpR4SiYfdt9gzuKMX4abQ3nU2SlVlA
=mgSa
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
