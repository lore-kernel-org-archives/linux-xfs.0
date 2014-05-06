Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9F49F8008
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 08:51:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5317CAC006
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 06:51:51 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id yhH4LUgEqNIQgqke for
	<xfs@oss.sgi.com>; Tue, 06 May 2014 06:51:49 -0700 (PDT)
Date: Tue, 6 May 2014 15:51:49 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS tune to adaptec ASR71605
Message-ID: <20140506155149.5cf056b5@harpe.intellique.com>
In-Reply-To: <alpine.LRH.2.02.1405061408480.24742@becks.mcs.st-and.ac.uk>
References: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>
	<20140506130008.13a1a7ee@harpe.intellique.com>
	<alpine.LRH.2.02.1405061408480.24742@becks.mcs.st-and.ac.uk>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Steve Brooks <steveb@mcs.st-and.ac.uk>
Cc: xfs@oss.sgi.com

Le Tue, 6 May 2014 14:14:35 +0100 (BST)
Steve Brooks <steveb@mcs.st-and.ac.uk> =E9crivait:

> Thanks for the reply Emmanuel, I installed and rua bonnie++ although
> I will need to research the results

Yup, they're... weird :) Write speed is abysmal, but random seeks very
high. Please try my settings so that we can compare the numbers more
directly:

bonnie++ -f -d ./ -n 50

If you translate the output from my test file with bon_csv2

Did you turn off write cache? did you tune the IO scheduler, read
ahead, and queue length? Here are the settings I'm generally using
with this type of controllers (for better sequential IO):

echo none > /sys/block/sda/queue/scheduler
echo 1024 > /sys/block/sda/queue/nr_requests
echo 65536 > /sys/block/sda/queue/read_ahead_kb

You can check the cache status in the output from =


arcconf getconfig 1 =


If you didn't install arcconf, you definitely should :) If you turned
off the write cache, be aware that this is not the expected mode of
operation for modern RAID controllers... Go buy a ZMM if necessary.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
