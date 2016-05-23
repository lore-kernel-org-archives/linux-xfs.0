Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 01A337CA4
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 17:24:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85FFAAC003
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 15:24:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id boPDdLsGNb9IibJO for <xfs@oss.sgi.com>;
	Mon, 23 May 2016 15:24:34 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0F62BB55
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 17:24:34 -0500 (CDT)
Subject: Re: centos7 xfs able to mount, but unable to write, unable to perform
	repair
References: <CAHV_CwYrTg8H9BZ60shH4PFYW4FMY7nc6dx49+7N6O15PfvuFw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b2f3ab03-a156-37f9-a41a-75bc5ee5c539@sandeen.net>
Date: Mon, 23 May 2016 17:24:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAHV_CwYrTg8H9BZ60shH4PFYW4FMY7nc6dx49+7N6O15PfvuFw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 5/23/16 1:46 PM, Morgan Yang wrote:
> I am running CentOS 7.1. I have a 1TB drive that is formatted as XFS.
> =

> After a year of continuous use, I can no longer write to it
> =

> sudo touch /capture/a.a
> =

> touch: cannot touch =91/capture/a.a=92: No space left on device

You've probably run out of room for new inode allocations,
which require a certain amount of contiguous free space.

> =

> However, there's plenty of room on the drive

Don't leave us guessing; how much?

And what does xfs_info /mount/point say.

...

> I see the following on dmesg

Oh, hum.

> [336198.224298] XFS (sdb): metadata I/O error: block 0x3a3836e2 ("xfs_tra=
ns_read_buf_map") error 117 numblks 1
> [336198.224479] XFS (sdb): Metadata corruption detected at xfs_agi_read_v=
erify+0x5e/0x110 [xfs], block 0x57545252
> [336198.224483] XFS (sdb): Unmount and run xfs_repair
> [336198.224486] XFS (sdb): First 64 bytes of corrupted metadata buffer:
> [336198.224489] ffff880404f30400: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
> [336198.224491] ffff880404f30410: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
> [336198.224494] ffff880404f30420: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
> [336198.224496] ffff880404f30430: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
> [336198.224554] XFS (sdb): metadata I/O error: block 0x57545252 ("xfs_tra=
ns_read_buf_map") error 117 numblks 1
> [337680.482764] xfs_db[25323]: segfault at 7ffe0aeceff8 ip 00000000004240=
85 sp 00007ffe0aecf000 error 6 in xfs_db[400000+81000]

Totally zeroed.

what kind of disk is this?

> When I try to run "xfs_repair", it can't seem to find secondary superblock
> =

> sudo xfs_repair -v /dev/sdb
> Phase 1 - find and verify superblock...
> couldn't verify primary superblock - not enough secondary superblocks wit=
h matching geometry !!!
> =

> attempting to find secondary superblock...
> .........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
..................................Sorry,
> could not find valid secondary superblock
> Exiting now.

what does file -s /dev/sdb say?

-Eric
 =

> =

> Does anyone have any recommendations on how I can recover this? =

> =

> =

> Much Thanks
> =

> Morgan Yang
> =

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
