Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC49F7CBF
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 09:51:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37796AC005
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 07:51:08 -0700 (PDT)
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.120]) by cuda.sgi.com with ESMTP id
	mgGwTGAvTkHO8qbF for <xfs@oss.sgi.com>;
	Tue, 28 May 2013 07:51:03 -0700 (PDT)
Message-ID: <51A4C456.6000708@ubuntu.com>
Date: Tue, 28 May 2013 10:51:02 -0400
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
	<20130402094834.GA4667@kernel.dk>
	<20130403114142.GP4667@kernel.dk> <515C4D9D.10103@ubuntu.com>
	<515DE2FE.1080201@ubuntu.com>
In-Reply-To: <515DE2FE.1080201@ubuntu.com>
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

Hi Jens, did this get lost in the shuffle, or just miss the window for
3.10 and will go in 3.11?

On 4/4/2013 4:30 PM, Phillip Susi wrote:
>> I have not tested it yet, but I am pretty sure it won't work.
>> It looks like the patch changes the BLKRRPART path to go ahead
>> and remove existing partitions when GENHD_FL_NO_PARTSCAN is set.
>> loop doesn't issue the BLKRRPART ioctl when !LO_FLAGS_PARTSCAN so
>> this won't help. I think loop needs to set GENHD_FL_NO_PARTSCAN
>> and then issue the ioctl regardless of the LO_FLAGS_PARTSCAN flag
>> to get the partitions to be removed.  I will try to test
>> tonight.
> 
> After testing, my initial thoughts appeared to have been correct.
> I had to modify the patch as follows.  To test, simply do:
> 
> truncate -s 10m img losetup /dev/loop0 img parted /dev/loop0 
> mklabel msdos mkpart primary ext2 1m 2m quit ls /dev/loop0*
> 
> Note the /dev/loop0p1 node.  Run losetup -d /dev/loop0 and see if
> it is still there.
> 
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRpMRWAAoJEJrBOlT6nu75yUYH/1PSNmTOBYgvEqQclWPBTd8n
Fm95yILcIlJWdUr3gUvQmjBax1NzKnG3NZ2U4hucpCcJH4FkHSTTFl5uZ3wU1B/Q
nvuQoSqYXVP+V9PVSTsUsxOI4Mvw5YP5sFwSdwRKpkCldXOuHrRZsuccFtkQducU
AIij42jvI1un+/qc6NLW+/S+rcLGUj21boPmX3g80km1De9QMrYrbGAAEbFO3rrq
fzsvGuVvOroGppLGpze4iMDn060Lxrw6//KDGtiUBIeD8kZCFGkBh1KupHqLLzXm
gmfdlHIqAR5uWB29m9TOlRbHPzdeQutwt8zL2LOYlCft5OiBIOW8dT8EFkl2Buw=
=7BGq
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
