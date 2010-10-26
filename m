Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9QBNoxh067634 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 06:23:51 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5696151FD9F
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 04:40:38 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 9W5nlpCKjRot6kfE for
	<xfs@oss.sgi.com>; Tue, 26 Oct 2010 04:40:38 -0700 (PDT)
Date: Tue, 26 Oct 2010 13:25:05 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <20101026132505.6af29d5d@harpe.intellique.com>
In-Reply-To: <4CC6B56B.7020007@profihost.ag>
References: <4CC67450.9020602@profihost.ag>
	<20101026092205.086c0d89@galadriel.home>
	<4CC68249.7050409@profihost.ag>
	<20101026094111.48670eb7@galadriel.home>
	<4CC688FE.7010206@profihost.ag>
	<20101026130103.7cc43aec@harpe.intellique.com>
	<4CC6B56B.7020007@profihost.ag>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: xfs@oss.sgi.com

Le Tue, 26 Oct 2010 13:03:07 +0200
Stefan Priebe - Profihost AG <s.priebe@profihost.ag> =E9crivait:

> it is a 9650SE-8LPML with Firmware: FE9X 3.06.00.003.

Augh, this firmware is antique :) The latest is 4.10.xx.xx. Anyway,
don't use firmware before 3.08.xx.xx, there were some nasty bugs.

> So you mean i should upgrade to 4.x Firmware? =


Definitely. It will much improve performances, too. Simply download the
firmware file, extract it, and flash the controller with tw_cli :

tw_cli /cXX update fw=3Dprom0006.img =


(the firmware is always in the prom00xx.img file).

> Do i then have to do a =

> filesystem repair? Or just wait if the error accours again?

No, the filesystem will be fine. However you should start a RAID scrub
with =


tw_cli /cXX/uXX start verify

This will rebuild the parity with the new 4.X format (faster writes)
and help detect any hardware fault.

My other advices : generally don't use cfq scheduler with a RAID
controller, it will defeat the whole purpose of RAID cache and command
reordering abilities. Use noop, generally, and deepen the queue :

echo "noop" > /sys/block/sdc/queue/scheduler
echo 512 > /sys/block/sdc/queue/nr_requests

Don't hesitate to enlarge tremendously the read-ahead cache, too. I
generally use about 512 to 1024 sectors  per drive as a rule of the
thumb, so a 4 drives array will use 2048 to 4096 :

blockdev --setra 4096 /dev/sdc

You should see a 100% write/read speed improvement with these
parameters.

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
