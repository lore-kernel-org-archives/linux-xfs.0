Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9BAF97F54
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 21:54:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35E76AC001
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 19:54:51 -0700 (PDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	h1Qie1APXpG4gyDw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Jul 2014 19:54:46 -0700 (PDT)
Received: by mail-wi0-f178.google.com with SMTP id n15so1443606wiw.5
	for <xfs@oss.sgi.com>; Wed, 02 Jul 2014 19:54:45 -0700 (PDT)
Received: from Telcontar.valinor (90.Red-79-150-228.dynamicIP.rima-tde.net.
	[79.150.228.90])
	by mx.google.com with ESMTPSA id o2sm61839674wia.16.2014.07.02.19.54.43
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 02 Jul 2014 19:54:44 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 67AF06072A
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 04:54:41 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 1R_jLpbDTBop for <xfs@oss.sgi.com>;
	Thu,  3 Jul 2014 04:54:38 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id E207D604A0
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 04:54:36 +0200 (CEST)
Date: Thu, 3 Jul 2014 04:54:26 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
In-Reply-To: <53B40427.6060302@sgi.com>
Message-ID: <alpine.LSU.2.11.1407030447450.9881@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster> <53B40427.6060302@sgi.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Wednesday, 2014-07-02 at 08:07 -0500, Mark Tinguely wrote:
> On 07/02/14 07:04, Brian Foster wrote:

>>> The worst issue for me is that "xfs_repair" fails to repair it.
>
> what version of xfs_repair?

xfs_repair version 3.1.11


which what comes with openSUSE 13.1

> Did you try to mount to replay the log before 
> repair?

Sure.

This last time, I first tried "umount" the partition, which initially 
failed, because despite being read only, some applications thought they 
had opened files on it (I was already in runlevel 1). I found them with 
lsof, killed them, umounted, mounted, system crash. Had to hit reset 
button on machine.

Reboot machine, and partition is automatically mounted, so the log 
replayed here. umount, repair (finds nothing, as far as I can see), 
backup, format, restore.



> Besides Brian's good advice, is kdump configured to dump vmcore?

I'm not sure I understand the question :-?


If you want me to run the system for a month, waiting for this to happen 
again, in some special kernel debug mode... I don't know if that will be 
feasible :-}


- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlO0xewACgkQtTMYHG2NR9WYsQCfTWjvcHB8IJfyXN4jVzHTnh5Q
lOEAn0TPwL03enbn8zrXbIQ9yMfknPi2
=39NE
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
