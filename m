Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58EVe6s007072 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 09:31:40 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B98D111AE93F
	for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 15:17:04 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id GC03UNzxeGN9PbrW for
	<xfs@oss.sgi.com>; Thu, 29 Jul 2010 15:17:04 -0700 (PDT)
Date: Fri, 30 Jul 2010 00:09:24 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100730000924.77d6767e@galadriel.home>
In-Reply-To: <D6C570D6-FEC7-4E3C-AAC2-13275721370A@ucsc.edu>
References: <20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
	<20100724005426.GN32635@dastard>
	<F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
	<20100724023922.GP32635@dastard>
	<777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>
	<20100726034545.GE655@dastard>
	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
	<20100726060604.GF7362@dastard>
	<F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>
	<20100726102036.GH7362@dastard>
	<0EC8FE5D-212C-4030-9D59-FDF38DF4E9EE@ucsc.edu>
	<D6C570D6-FEC7-4E3C-AAC2-13275721370A@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

Le Thu, 29 Jul 2010 12:22:30 -0700 vous =E9criviez:

> I tried filling up the disk with data to see if that worked Ok and it
> did, up until this point. There is something I don't understand going
> on though. 'df' says that I have 381 GB free on the disk, but I can't
> write to the disk anymore because it says it there isn't any space
> left on it. Is this some insane round off error or is there something
> going on here?

You probably ran out of inodes. Do you have many small files?

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
