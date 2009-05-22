Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4MHaGHC226479 for <xfs@oss.sgi.com>; Fri, 22 May 2009 12:36:16 -0500
Received: from mail-pz0-f190.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 627862A4338
	for <xfs@oss.sgi.com>; Fri, 22 May 2009 10:36:28 -0700 (PDT)
Received: from mail-pz0-f190.google.com (mail-pz0-f190.google.com
	[209.85.222.190]) by cuda.sgi.com with ESMTP id
	HaA1gTYk7x31ZX9r for <xfs@oss.sgi.com>;
	Fri, 22 May 2009 10:36:28 -0700 (PDT)
Received: by pzk28 with SMTP id 28so1608945pzk.20
	for <xfs@oss.sgi.com>; Fri, 22 May 2009 10:36:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A16C97A.2020909@sandeen.net>
References: <7fe205990905220716v7d06b9bch40fe6136af17e345@mail.gmail.com>
	<4A16C97A.2020909@sandeen.net>
Date: Sat, 23 May 2009 01:36:26 +0800
Message-ID: <7fe205990905221036h71823b2bwf88123a38a406324@mail.gmail.com>
Subject: Re: about XFS_IOC_RESVSP
From: Joe Hsu <nagual.hsu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Well, I have multiple processes running concurrently, and each writes
on its own files( the sort of files I mentioned), while at the same
time, I have other programs doing normal but light I/O to other files
on the same xfs partition.

Once I thought maybe I can pre-allocate these special files within a
directory, which has fixed allocation groups(I guess that means fixed
sets of blocks), and then I can try to make 'truncate to 0 and
pre-allocate' requests sequential for the running processes. But, XFS
seems to have this feature, I cannot find how to do that.

2009/5/22 Eric Sandeen <sandeen@sandeen.net>:
> Joe Hsu wrote:
> Do you really need the exact same blocks? =A0What if you just truncate to
> 0 & re-allocate?
>
> -Eric
>



-- =

The sun is shinny but the ice is slippery.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
