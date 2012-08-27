Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7R7MNgL012522 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 02:22:23 -0500
Received: from mail.vlasiu.net (mail.vlasiu.net [91.223.50.125]) by
	cuda.sgi.com with ESMTP id juiCdoe0wHaNIwX3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 00:23:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id E01707E07F
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 10:23:11 +0300 (EEST)
Received: from mail.vlasiu.net ([127.0.0.1])
	by localhost (mail.vlasiu.net [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id ugycVJ8ehhfl for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 10:23:07 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id C05057E081
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 10:23:07 +0300 (EEST)
Date: Mon, 27 Aug 2012 10:23:02 +0300 (EEST)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: umount doesn't seem to really unmount
In-Reply-To: <CAAxjCEynRoS3AfYer=is725XR+kZEwe_SPxt_iDTJNRMo2UxOA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1208271016440.10454@mail.vlasiu.net>
References: <CAAxjCEwdYbcDoUvcAV1n8281HCCvrCvReaG2oM5+h+WV5yDZvA@mail.gmail.com>
	<1104CDC2-47D2-40CF-8294-A17E33125D54@sandeen.net>
	<CAAxjCExx8LB3PyMUR8T215hMYps17D+Lvg4C0aOwLwD=d-NOMQ@mail.gmail.com>
	<alpine.LRH.2.02.1208270952390.8166@mail.vlasiu.net>
	<CAAxjCEynRoS3AfYer=is725XR+kZEwe_SPxt_iDTJNRMo2UxOA@mail.gmail.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Mon, 27 Aug 2012, Stefan Ring wrote:

> It seems to happen with any service that has PrivateTmp set:
Thanks. Stopping all services using PrivateTmp seems to fix the problem.
systemd again... :-(


Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 44952F15
// OpenGPG-Fingerprint: 4AC5 7C26 2FE9 02DA 4906  24B2 D32B 7ED7 4495 2F15
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQOyBWAAoJENMrftdElS8VgAoP/1q9BlGcs/th/+Ex0lG6HWmj
ApBjpnS1JCzKDCrtZjtTpzWOF0FZe84yHJ/l8/T0Fze37QWJ7k8KRizMtn0gcAXQ
HeqBBxdbiNWeaqyE89n9sBX30yTvFRNGqHzXseIEHo1VfAwven2zrhPpMzFdz++D
qPxl/7HqnsYSb6oGX03m9nDoJhlKvE1YLNHaqlJXQI8UjgJIMu9aQvgTJKIDF6i1
q2oTVOpOvXjbt4/A1n3aO0qMlS7h7sztokkGstalscHYVVqgMlNjI0r+bgy5CwSh
gkztUg+l1/ga5HcGurkqJW2TWz2CxYOE40JfGzjqx02dEnDMW1hMObmlkSPkWu/m
sLYXsUvvlT58b/uSTjTcRDHkt1SQEERNp85JlyEBTIbVwN4HQnpZnXNGzKjvllw+
L47oQwk59bBb1/LSuFyJtT8nXn6ODpKglsMK4pc82SO9Zney1gpCCGcGUQamp6/w
koRqcSVADJy4YFZ61TQVMxxafPPAFrmvCDX34QT/I96iGMLwheg5Na8LGKgWkczl
YRg9abG8jvUuO4B34mfLnUjm9p1nepEmn8xYnzE6batLg00gkxiB2T2ThyAOW9co
T+utXpBJM+5meCzsR0w+X0bTFnqganbZi95Marm91BzehaG1L3pXbNkVk52V0yTs
H8IwCc+WaFo+xEFxwR6i
=TiH/
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
