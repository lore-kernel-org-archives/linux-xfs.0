Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 700E67FAB
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 10:41:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB96AAC001
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 08:41:25 -0700 (PDT)
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.120]) by cuda.sgi.com with ESMTP id
	iGVZ85ljtGyGWlsY for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 08:41:20 -0700 (PDT)
Message-ID: <515C4D9D.10103@ubuntu.com>
Date: Wed, 03 Apr 2013 11:41:17 -0400
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
	xfstests case #78]
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
	<247719576.438259.1364882929749.JavaMail.root@redhat.com>
	<20130402070537.GP6369@dastard> <20130402071937.GC3670@kernel.dk>
	<20130402073035.GD3670@kernel.dk>
	<14055702.547701.1364891947331.JavaMail.root@redhat.com>
	<20130402090047.GF3670@kernel.dk>
	<985125161.581860.1364895066584.JavaMail.root@redhat.com>
	<20130402094834.GA4667@kernel.dk> <20130403114142.GP4667@kernel.dk>
In-Reply-To: <20130403114142.GP4667@kernel.dk>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 4/3/2013 7:41 AM, Jens Axboe wrote:
>> Thanks for testing! I don't particularly like this stuff in
>> loop, though. It's quite nasty and depends on other behaviour. It
>> would be prettier if we just had rescan_partitions() do the right
>> thing, and only drop partitions and not rescan if NO_PART_SCAN is
>> set.
>> 
>> Ala the below, dropping the loop change and implementing that
>> change in the core code. Phillip, can you check whether this does
>> the right thing for your bug too?
> 
> Phillip? I'm going to revert the loop change asap, so if you want
> this fixed for 3.10, it's about that time to test it out.

I have not tested it yet, but I am pretty sure it won't work.  It
looks like the patch changes the BLKRRPART path to go ahead and remove
existing partitions when GENHD_FL_NO_PARTSCAN is set.  loop doesn't
issue the BLKRRPART ioctl when !LO_FLAGS_PARTSCAN so this won't help.
 I think loop needs to set GENHD_FL_NO_PARTSCAN and then issue the
ioctl regardless of the LO_FLAGS_PARTSCAN flag to get the partitions
to be removed.  I will try to test tonight.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRXE2dAAoJEJrBOlT6nu75PM0IAIxVmuHdxLPtdtUNPqkU2a1r
QanHb6F43qSbd7l37XlwYgzUlybVlntf1yvKGzh29g3QM0603sFqV1o+mbXd5LI3
b+I5QrQJh90Vou9oVSAxz1Ps/AlZvxVIDv8bRwNhpXcMmaj0EN5R+6pU5L7KU2BU
GFsvajssedFh3XnNskgkR3XlqevI7U7A8VqLRsswl7FJVu7R1s45xP/sQgBWgiUS
P5viykwhje4OTKmu0D7bFKrOVx6O3gK7IHzdOwwT9aWRxuxL+Y9yfBF9nx/xZXkc
I2G09w852KgYDVYUHgW3IfuRo4F+4Y7Mw0Klu4XX5OmEXhselIqhwwTmEKMvEns=
=OLri
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
