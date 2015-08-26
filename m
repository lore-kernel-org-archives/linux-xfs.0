Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD0F77F50
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:39:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9217E304051
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:39:19 -0700 (PDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
	[209.85.212.177]) by cuda.sgi.com with ESMTP id
	0dASSxU4qGXAtdaJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:39:17 -0700 (PDT)
Received: by widdq5 with SMTP id dq5so31004460wid.1
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:39:16 -0700 (PDT)
Received: from minas-tirith.valinor (17.Red-83-42-75.dynamicIP.rima-tde.net.
	[83.42.75.17])
	by smtp.gmail.com with ESMTPSA id go5sm5001687wib.5.2015.08.25.17.39.13
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 25 Aug 2015 17:39:15 -0700 (PDT)
Received: from minas-tirith.valinor (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 70E36181DA4
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 02:39:12 +0200 (CEST)
Subject: Re: Performance impact of mkfs.xfs vs mkfs.xfs -f
References: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>
	<55DCE1CF.5030708@sandeen.net>
	<CABppvi6W5_1GBrb8x1wOAq3X6yraTtt1UYEFE+dBzcXj3yTzrg@mail.gmail.com>
	<20150825234300.GN714@dastard>
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Message-ID: <55DD0AAF.9090401@opensuse.org>
Date: Wed, 26 Aug 2015 02:39:11 +0200
MIME-Version: 1.0
In-Reply-To: <20150825234300.GN714@dastard>
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

On 2015-08-26 01:43, Dave Chinner wrote:
> On Tue, Aug 25, 2015 at 04:09:33PM -0700, Shrinand Javadekar 
> wrote:

>> Formatted the new disks with mkfs.xfs. Ran the workload. 
>> Reformatted the disks with mkfs.xfs -f. Ran the workload.


> Anyway, please post the output so we can see the differences for 
> ourselves. What we need is mkfs output in both cases, and xfs_info
>  output in both cases after mount.

Suggestion (for the OP):

To reformat a third time without "-f", you can reformat as ext4, then
format a second time as xfs. But to imitate a new disk, you have to
zero it with dd.

Then you can replay the test and obtain the requested data :-)

- -- 
Cheers / Saludos,

		Carlos E. R.

  (from 13.1 x86_64 "Bottle" (Minas Tirith))

- -- 
Cheers / Saludos,

		Carlos E. R.

  (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlXdCq8ACgkQja8UbcUWM1zCBgEAoMjVMIAlp0fKEO3CZKtZ/HNY
Ek7joAO+gCVO++IJ2boBAIuVMiLnOug7fG46s1vkFEUhWsvUYQbPoqbhCNyYki/u
=LcBk
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
