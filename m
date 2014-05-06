Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 788157FB9
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 09:59:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 631568F8033
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 07:59:36 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id ACc6GcnrdY14Eo1R for
	<xfs@oss.sgi.com>; Tue, 06 May 2014 07:59:34 -0700 (PDT)
Date: Tue, 6 May 2014 16:59:33 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS tune to adaptec ASR71605
Message-ID: <20140506165933.65fc95e9@harpe.intellique.com>
In-Reply-To: <alpine.LRH.2.02.1405061520020.24742@becks.mcs.st-and.ac.uk>
References: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>
	<20140506130008.13a1a7ee@harpe.intellique.com>
	<alpine.LRH.2.02.1405061408480.24742@becks.mcs.st-and.ac.uk>
	<20140506155149.5cf056b5@harpe.intellique.com>
	<alpine.LRH.2.02.1405061520020.24742@becks.mcs.st-and.ac.uk>
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

Le Tue, 6 May 2014 15:40:37 +0100 (BST)
Steve Brooks <steveb@mcs.st-and.ac.uk> =E9crivait:

> Yes the write speed is very poor.. I am running "bonnie++" again with
> your params but no sure how long it will take.
> =

> >  bonnie++ -f -d ./ -n 50  =

> =

> Will thisno be different for our two machines as it seems to generate =

> other params depending on the size of the RAM. All ours have 64G RAM.
> =


You MUST test with a dataset bigger than RAM, else you're mostly testing
your RAM speed :) If you've got 64 GB, by default bonnie will test with
128 GB of data. The small size probably explains the very fast seek
speed... You're seeking in the RAM cache :)

> =

> I disabled write cache on the controller as there is no ZMM flash
> backup module and it seems to be advised that way. I could enable it
> and try another test to see if that is a contribution to the poor
> write performance. I do have "arcconf" on all our adaptec raid
> machines.

Modern RAIDs need write cache or perform abysmally. Do yourself a
service and buy a ZMM. Without write cache it'll be so slow it will be
nearly unusable, really. Did you see the numbers? your RAID is more
than 12x slower than mine... actually slower than a single disk! You'll
simply fail at filling it up at these speeds.

> I have not tuned the IO scheduler, read ahead, and queue length?  I
> guess I can try this.
> =

> > echo none > /sys/block/sda/queue/scheduler
> > echo 1024 > /sys/block/sda/queue/nr_requests
> > echo 65536 > /sys/block/sda/queue/read_ahead_kb  =

> =

> Will this need to be done after every reboot? I guess it could go in =

> "/etc/rc.local" ?
> =


Yep. You can tweak the settings and try various configurations.
However these work fine for me in most cases (particularly the noop
scheduler). Of course replace sda with the RAID array device or you may
end up tuning your boot drive instead :)

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
