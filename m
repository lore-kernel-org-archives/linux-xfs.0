Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 290B17F53
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 16:50:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB63F304053
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 14:50:35 -0700 (PDT)
Received: from mail-we0-f182.google.com (mail-we0-f182.google.com
	[74.125.82.182]) by cuda.sgi.com with ESMTP id ztK7qYRjsy3iutFV
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Aug 2014 14:50:34 -0700 (PDT)
Received: by mail-we0-f182.google.com with SMTP id k48so9153443wev.41
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 14:50:32 -0700 (PDT)
Received: from minas-tirith.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id u7sm48403569wif.3.2014.08.11.14.50.31
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 11 Aug 2014 14:50:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id E6BAB183EEA
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 23:50:29 +0200 (CEST)
Date: Mon, 11 Aug 2014 23:50:20 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <53E93530.4070902@sgi.com>
Message-ID: <alpine.LSU.2.11.1408112347480.17839@minas-tirith.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<53E8D9F6.7080704@sgi.com>
	<alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
	<53E93530.4070902@sgi.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463779071-481454962-1407793829=:17839"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463779071-481454962-1407793829=:17839
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



El 2014-08-11 a las 16:27 -0500, Mark Tinguely escribió:
> On 08/11/14 10:34, Carlos E. R. wrote:

>
> so XFS gave a forced shutdown after the machine came back from hibernation. 
> After replaying the log, there were no errors in xfs_repair.
>
> We should have quiesced the metadata/log before freezing xfs. Was there a lot 
> of items in the log?

Sorry, what log? The /var/log/messages file? I posted it in full, from 
before the hibernation to powerdown.

- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlPpOqUACgkQja8UbcUWM1xpewD/XaCmyL60x0lqs8PuoA9xfSTn
8CNxtpVX78L3O/1RsdYA/3U9CIA0uOCI9Lk4t0KO5xiLLjCZi/+AlvUtAbCfCQCB
=VEcc
-----END PGP SIGNATURE-----
---1463779071-481454962-1407793829=:17839
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463779071-481454962-1407793829=:17839--
