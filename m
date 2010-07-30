Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58IBRBu017649 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 13:11:28 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3A1511B1906
	for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 18:56:52 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id rM45fdy4EeBBluqY for
	<xfs@oss.sgi.com>; Thu, 29 Jul 2010 18:56:52 -0700 (PDT)
Subject: Re: filesystem shrinks after using xfs_repair
Mime-Version: 1.0 (Apple Message framework v1081)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <201007300239.59574@zmi.at>
Date: Thu, 29 Jul 2010 18:49:04 -0700
Message-Id: <562BA312-FBBA-492C-882F-2E0A93DA888F@ucsc.edu>
References: <F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
	<20100729230147.GN655@dastard>
	<04349CE2-CF8B-463C-8B06-5E4E59E869B2@ucsc.edu>
	<201007300239.59574@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com


On Jul 29, 2010, at 5:39 PM, Michael Monnerie wrote:

> On Freitag, 30. Juli 2010 Eli Morris wrote:
>> Is that something I could do now, or only when the filesystem is
>> created? If I mount it with '-o inode64', can I mount it without
>> that later, or once I write to the filesystem like that, can I not
>> go back to mounting it in 32 bit mode? =

> =

> Once you mount with inode64, you can't go back.
> =

> I'm not sure which applications are "broken", but I use inode64 for a =

> backup server where lots of Linux boxes connect to over NFS, and a Samba =

> for Windows PCs which has inode64, and at least didn't see any problem =

> over the years. That doesn't mean there isn't a problem, of course ;-)
> =

> -- =

> mit freundlichen Gr=FCssen,
> Michael Monnerie, Ing. BSc
> =

> it-management Internet Services
> http://proteger.at [gesprochen: Prot-e-schee]
> Tel: 0660 / 415 65 31
> =

> ****** Aktuelles Radiointerview! ******
> http://www.it-podcast.at/aktuelle-sendung.html
> =

> // Wir haben im Moment zwei H=E4user zu verkaufen:
> // http://zmi.at/langegg/
> // http://zmi.at/haus2009/

Thanks guys,

That makes sense.

cheers,
Eli

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
