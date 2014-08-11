Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B2477F3F
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 12:09:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E90828F8052
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 10:09:07 -0700 (PDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	13SuzWmPPoePdbM6 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Aug 2014 10:09:05 -0700 (PDT)
Received: by mail-wi0-f172.google.com with SMTP id n3so4596605wiv.17
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 10:09:04 -0700 (PDT)
Received: from minas-tirith.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id u7sm45992739wif.3.2014.08.11.10.09.03
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 11 Aug 2014 10:09:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id E2D02185A7D
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 19:09:01 +0200 (CEST)
Date: Mon, 11 Aug 2014 19:08:53 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <20140811161445.GA7696@bfoster.bfoster>
Message-ID: <alpine.LSU.2.11.1408111905360.7326@minas-tirith.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<53E8D9F6.7080704@sgi.com>
	<alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
	<20140811161445.GA7696@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463779071-1568027554-1407776878=:7326"
Content-ID: <alpine.LSU.2.11.1408111908330.7326@minas-tirith.valinor>
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

---1463779071-1568027554-1407776878=:7326
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LSU.2.11.1408111908331.7326@minas-tirith.valinor>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Content-ID: <alpine.LSU.2.11.1408111908330.7326@minas-tirith.valinor>


El 2014-08-11 a las 12:14 -0400, Brian Foster escribió:
> On Mon, Aug 11, 2014 at 05:34:46PM +0200, Carlos E. R. wrote:


> This reminds me that it might be interesting to tune the eofblocks
> scanner to be more aggressive and see if that helps reproduce. This
> thread that's running here normally runs every 5 minutes by default, but
> it can be tuned to run at a user-defined interval via the following
> /proc file:
>
> # cat /proc/sys/fs/xfs/speculative_prealloc_lifetime
> 300
>
> I wonder if setting it to 30s or so ('echo 30 > /proc/...') and running
> some hibernation cycles would help...

Ok, I can try that.

- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlPo+K0ACgkQja8UbcUWM1zxVgD+LFcJ3OBRJhn9LVrwFxf98H1u
n7ubtexF8XXKWcUdjv0A/Ail1kzWxIgQkevunUQ/3UnbthtWqnyniHP4qKVUWv8m
=AauB
-----END PGP SIGNATURE-----
---1463779071-1568027554-1407776878=:7326
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463779071-1568027554-1407776878=:7326--
