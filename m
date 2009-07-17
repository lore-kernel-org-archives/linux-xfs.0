Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6HBA94A083133 for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 06:10:10 -0500
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBDF8A863E9
	for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 04:18:33 -0700 (PDT)
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2]) by
	cuda.sgi.com with ESMTP id 8palkHF7ZF8llU4n for
	<xfs@oss.sgi.com>; Fri, 17 Jul 2009 04:18:33 -0700 (PDT)
Date: Fri, 17 Jul 2009 13:10:43 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Multi threaded random IO
Message-ID: <20090717131043.19b8e7de@harpe.intellique.com>
In-Reply-To: <4A60442E.7010206@gslab.com>
References: <4A60442E.7010206@gslab.com>
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
To: Milind Dumbare <milind@gslab.com>
Cc: linux-fsdevel@vger.kernel.org, xfs mailing list <xfs@oss.sgi.com>

Le Fri, 17 Jul 2009 02:28:14 -0700
Milind Dumbare <milind@gslab.com> =E9crivait:

> I see multi threaded random Write faster than multi threaded random =

> Read. Which is contradictory to standard "Reads faster that Writes"
> law.
> =

> My test setup is.
> 10MB record size, 2TB filesize, 8 threads.iozone
> =

> Any comments?

Well it very much depends upon your underlying hardware. For instance
3Ware RAID cards with default settings read very poorly, they even get
much slower in sequential read than sequential write.

So basically you have to provide much more detailed hardware setup :
storage hardware, attachment, number and type of drives, RAID level...

-- =

----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
