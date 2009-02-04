Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14FGiJC158823 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 09:16:45 -0600
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1807718C24D0
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 07:16:04 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id Pmbpbl7Rl6cdHYss for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 07:16:04 -0800 (PST)
Date: Wed, 4 Feb 2009 16:15:59 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_force_shutdown after Raid crash
Message-ID: <20090204161559.347679f7@harpe.intellique.com>
In-Reply-To: <20090204140113.GP11617@kyra>
References: <498376CF.8020806@renderforce.de> <200902031140.08576@zmi.at>
	<20090203154907.GA21278@infradead.org> <200902040952.45440@zmi.at>
	<20090204122241.GL24173@disturbed>
	<20090204134538.24c2b4ac@harpe.intellique.com>
	<20090204140113.GP11617@kyra>
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
To: KELEMEN Peter <Peter.Kelemen@cern.ch>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

Le Wed, 4 Feb 2009 15:01:13 +0100
KELEMEN Peter <Peter.Kelemen@cern.ch> =E9crivait:

> > - 3ware : no information  =

> =

> 	/cX/uX set cache=3Doff

Yes but it set cache for the array globally, I don't find anything about
the individual disks write cache specifically. Same thing for Xyratex.

BTW I checked LSI MegaRAID  and it allows setting individual disks
cache too :

MegaCli -AdpCacheFlush -aN|-a0,1,2|-aALL -EnDskCache|DisDskCache =


So for now we have the following :

disk cache settings control

3Ware : no
Xyratex : no
Adaptec : yes
LSI : yes
Areca : possibly...

-- =

----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
