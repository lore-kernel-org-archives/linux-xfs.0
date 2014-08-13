Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD3367F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 19:08:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A08CAC007
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 17:08:02 -0700 (PDT)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id n3MDDVGAQyFZLuEa
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Aug 2014 17:07:55 -0700 (PDT)
Received: by mail-wg0-f44.google.com with SMTP id m15so10544151wgh.15
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 17:07:54 -0700 (PDT)
Received: from Telcontar.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id x11sm547652wjr.15.2014.08.12.17.07.53
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 12 Aug 2014 17:07:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id EC2E960682
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 02:07:51 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id lS4UXv62XUU9 for <xfs@oss.sgi.com>;
	Wed, 13 Aug 2014 02:07:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id C6CD1605B8
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 02:07:51 +0200 (CEST)
Date: Wed, 13 Aug 2014 02:07:42 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <20140812231629.GA20518@dastard>
Message-ID: <alpine.LSU.2.11.1408130202390.14631@Telcontar.valinor>
References: <alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
	<53E93530.4070902@sgi.com>
	<alpine.LSU.2.11.1408112347480.17839@minas-tirith.valinor>
	<53E93C29.1020103@sgi.com>
	<alpine.LSU.2.11.1408120013500.17839@minas-tirith.valinor>
	<alpine.LSU.2.11.1408120139060.21410@minas-tirith.valinor>
	<20140812165143.GB46654@bfoster.bfoster>
	<53EA86DE.5060508@sandeen.net>
	<20140812215943.GA39704@bfoster.bfoster>
	<53EA9386.2040207@sandeen.net> <20140812231629.GA20518@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Wednesday, 2014-08-13 at 09:16 +1000, Dave Chinner wrote:

...

> Well, the sync is necessary for hibernate - it needs to shrink the
> amount of memory that is saved to disk to as small as possible. If
> your memory is full of dirty page cache, why would you save that to
> the hibernate image, only to have to load it back off, then write it
> to the filesystem after resume? Why wouldn't you write it straight
> to disk before hibernation, then remove it from memory so you've
> then got free memory to allocate the hibernation image that gets
> written to disk?

You can see that this happens by looking at the output of "free" before 
and after hibernation. Even issuing the command after getting the desktop 
back, I can see a big difference (the ammount of buffers and cache).

- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlPqrFcACgkQtTMYHG2NR9VfIgCgj3AXArngfCdoK/bGDsHNNWWU
pgoAnRJK7GMHRbO9KCV2TKYnlSYWMolT
=MtMr
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
