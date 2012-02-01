Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q110p8PT146532 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 18:51:08 -0600
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id pxXz1Gj7ldTUG2zX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 Jan 2012 16:51:05 -0800 (PST)
Received: by dady25 with SMTP id y25so483824dad.26
	for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 16:51:05 -0800 (PST)
Date: Wed, 1 Feb 2012 06:20:57 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120201005057.GA44385@Xye>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org>
	<20120131215210.GB47420@soundmouse.com>
MIME-Version: 1.0
In-Reply-To: <20120131215210.GB47420@soundmouse.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6013598893346923655=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Candler <brian@soundmouse.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


--===============6013598893346923655==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


* On Tue, Jan 31, 2012 at 09:52:10PM +0000, Brian Candler <brian@soundmouse=
=2Ecom> wrote:
>On Tue, Jan 31, 2012 at 09:52:05AM -0500, Christoph Hellwig wrote:
>> You don't just read a single file at a time but multiple ones, don't
>> you?
>
>It's sequential at the moment, although I'll do further tests with the -c
>(concurrency) option to bonnie++
>
>> Try playing with the following tweaks to get larger I/O to the disk:
>>
>>  a) make sure you use the noop or deadline elevators
>>  b) increase /sys/block/sdX/queue/max_sectors_kb from its low default
>>  c) dramatically increase /sys/devices/virtual/bdi/<major>:<minor>/read_=
ahead_kb
>
>Thank you very much: I will do further tests with these.
>
>Is the read_ahead_kb knob aware of file boundaries? That is, is there any
>risk that if I set it too large it would read useless blocks past the end =
of
>the file?

     The read_ahead_kb knob is used the by memory subsystem=20
     readahead code to set the initial readahead to scale from (it=20
     uses a dynamic scaling window). It is set by default based on=20
     device readahead value (probably obtained in a way similar to=20
     hdparm -I).=20
    =20
     Setting it higher will be beneficial for sequential workloads=20
     and the risk you mentioned is not there since it file=20
     boundary aware -- check=20
     http://lxr.linux.no/linux+*/mm/readahead.c#L151 for more=20
     details.
>
>Regards,
>
>Brian.
>
>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs


Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPKIxxAAoJEKYW3KHXK+l3kygH/RjCzgDrUKKkxIthJt8NgPlq
GOq6OpCLdYg7aCDFd5CkUAQgTLnb/dD5yM0qlEBkka144BFu2CQqEKBWDZyawM90
eNjNVycYS3E8z62n1FRSMmoja0ehqzJU7BEJaXvf8i1b4vW82UvQ0kcQ2q/uxxIT
0aLrV8Yy3vvNnyThXE1pQNIxYwz1+UR8vMvJuXGopyd72tr4VOmv2dnHhOeCRuum
EB//6glR+gyMZjvgLFbveYeW8aAaGGSDnrapBTVqQxSfXpbZjuX1xTEGVxTUhb0B
xv1UKI8dxnEJhkEXXZwxpbtxHFuQi7x/nAlsv7Defeg1Ct5kve8y1mZ4OhRL5O8=
=9TqE
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--


--===============6013598893346923655==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6013598893346923655==--
