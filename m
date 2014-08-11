Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C20B67F3F
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 09:59:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CE448F8040
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 07:59:01 -0700 (PDT)
Received: from mail-we0-f171.google.com (mail-we0-f171.google.com
	[74.125.82.171]) by cuda.sgi.com with ESMTP id yPCEYs8fA5OSaBfm
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Aug 2014 07:58:59 -0700 (PDT)
Received: by mail-we0-f171.google.com with SMTP id p10so8791280wes.16
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 07:58:58 -0700 (PDT)
Received: from minas-tirith.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id z5sm2139126wje.49.2014.08.11.07.58.57
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 11 Aug 2014 07:58:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 9830F18245D
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 16:58:55 +0200 (CEST)
Date: Mon, 11 Aug 2014 16:58:47 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <20140811144359.GA10217@laptop.bfoster>
Message-ID: <alpine.LSU.2.11.1408111657160.7326@minas-tirith.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<20140811144359.GA10217@laptop.bfoster>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463779071-1121377066-1407769065=:7326"
Content-ID: <alpine.LSU.2.11.1408111658020.7326@minas-tirith.valinor>
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

---1463779071-1121377066-1407769065=:7326
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LSU.2.11.1408111658021.7326@minas-tirith.valinor>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Content-ID: <alpine.LSU.2.11.1408111658020.7326@minas-tirith.valinor>


El 2014-08-11 a las 10:44 -0400, Brian Foster escribió:

>> I post this in case you have some suggestion before I nuke the partition
>> (rsync, reformat, etc). It shold take some hours.
>>
>
> Assuming you already have a pre-repair metadump, I'd suggest to
> xfs_repair, capture and post the repair output to the list and leave it
> at that (for now at least). I think you mentioned previously that the
> problem hits more frequently at this point, so I wonder if you could try
> to reproduce and get a better idea of what might contribute to the
> failure.
>
> For example, can you actively reproduce at this point? Perhaps get some
> work going on all of the applications you typically have running and run
> some hibernation cycles..? While a reformat might spare you from the
> issue for a bit, it's going to make it that much harder to get more
> information on what's going on.

Ok, will do.

I will create a backup of my partition, with xfsdump, after attempting
repair of the partition, and reboot, and see (without the reformat cycle).

At this instant I'm doing a full dd of the partition, just in case it
becomes useful.

- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlPo2i8ACgkQja8UbcUWM1wj3AD/T1eMkxiQUYSa6OBHvmTNj64g
cF6Gi5Gjv/dsF4aIcL0A/0vHz3bFmvhzh7D/2ugvb84tj8NtHC1QWPrY6Lbw4FmW
=8+lJ
-----END PGP SIGNATURE-----
---1463779071-1121377066-1407769065=:7326
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463779071-1121377066-1407769065=:7326--
