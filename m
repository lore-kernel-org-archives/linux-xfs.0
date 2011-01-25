Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0PCn6nR006971 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 06:49:07 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90D521A1CFCF
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 04:51:27 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 3LRn4qh9KIx93EEC for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 04:51:27 -0800 (PST)
Date: Tue, 25 Jan 2011 13:51:23 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Optimize RAID0 for max IOPS?
Message-ID: <20110125135123.0342f116@harpe.intellique.com>
In-Reply-To: <20110125124509.D76D6BB0B9@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
	<alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
	<20110124215713.82D75B187@gemini.denx.de>
	<20110124230314.GA11040@dastard>
	<20110125083900.4dd65bf2@galadriel2.home>
	<20110125083643.GE28803@dastard>
	<20110125124509.D76D6BB0B9@gemini.denx.de>
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
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Justin@oss.sgi.com, Piszcz <jpiszcz@lucidpixels.com>

Le Tue, 25 Jan 2011 13:45:09 +0100
Wolfgang Denk <wd@denx.de> =E9crivait:

> > This is smelling like a case of barrier IOs on software raid on
> > cheap storage....  =

> =

> Right. [Any way to avoid these, btw?] =


Easy enough, use the "nobarrier" mount option. =


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
