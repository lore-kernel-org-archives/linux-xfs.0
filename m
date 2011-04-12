Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3CBY0Ab149395 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 06:34:00 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 738A214BD5D0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 04:37:19 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id wAIiD66snH5fHCPx for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2011 04:37:19 -0700 (PDT)
Date: Tue, 12 Apr 2011 13:37:18 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: fs corruption
Message-ID: <20110412133718.6028abee@harpe.intellique.com>
In-Reply-To: <20110412110532.GB31057@dastard>
References: <31377534.post@talk.nabble.com> <20110412094917.GY31057@dastard>
	<38287.10078.qm@web112901.mail.gq1.yahoo.com>
	<20110412110532.GB31057@dastard>
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
Cc: xfs@oss.sgi.com, Leo Davis <leo1783@yahoo.com>

Le Tue, 12 Apr 2011 21:05:32 +1000
Dave Chinner <david@fromorbit.com> =E9crivait:

> it's possible that it took a couple of months to trip over a random
> metadata corruption. I've seen that before in directory trees and
> inode clusters where corruption is not detected until next time they
> are read from disk....
> =


That's why background scrubbing of RAID arrays is generally a good
habit to contract :)

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
