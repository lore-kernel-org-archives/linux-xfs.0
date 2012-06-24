Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5OF3qpB040003 for <xfs@oss.sgi.com>; Sun, 24 Jun 2012 10:03:53 -0500
Received: from vserv.windfluechter.net (vserv.windfluechter.net
	[178.63.83.104]) by cuda.sgi.com with ESMTP id WZpgacjopujv9Y46
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 24 Jun 2012 08:03:49 -0700 (PDT)
Received: from [172.16.10.1] (helo=hro.bluespice.org)
	by vserv.windfluechter.net with esmtps
	(TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16) (Exim 4.72)
	(envelope-from <ij@2012.bluespice.org>) id 1SioLs-0008Bx-8r
	for xfs@oss.sgi.com; Sun, 24 Jun 2012 17:03:48 +0200
MIME-Version: 1.0
Date: Sun, 24 Jun 2012 17:03:47 +0200
From: =?UTF-8?Q?Ingo_J=C3=BCrgensmann?= <ij@2012.bluespice.org>
Subject: Re: mkfs.xfs states log stripe unit is too large
In-Reply-To: <4FE710B7.5010704@hardwarefreak.com>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
Message-ID: <d71834a062ffd666ab53a4695eb643e9@muaddib.hro.localnet>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 2012-06-24 15:05, Stan Hoeppner wrote:

> The the log stripe unit mismatch error is a direct result of Ingo
> manually choosing a rather large chunk size for his two stripe 
> spindle
> md array, yielding a 1MB stripe, and using an internal log with it.
> Maybe there is a good reason for this, but I'm going to challenge it.

To cite man mdadm:

        -c, --chunk=
               Specify chunk size of kibibytes.  The  default  when
               creating an array is 512KB.  To ensure compatibility
               with earlier versions, the default when Building and
               array  with no persistent metadata is 64KB.  This is
               only meaningful for RAID0, RAID4, RAID5, RAID6,  and
               RAID10.

So, actually there's a mismatch with the default of mdadm an mkfs.xfs. 
Maybe it's worthwhile to think of raising the log stripe maximum size to 
at least 512 kiB? I don't know what implications this could have, 
though...

-- 
Ciao...          //    Fon: 0381-2744150
.     Ingo     \X/     http://blog.windfluechter.net

gpg pubkey: http://www.juergensmann.de/ij_public_key.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
