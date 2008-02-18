Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 13:49:40 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1ILnV64028846
	for <linux-xfs@oss.sgi.com>; Mon, 18 Feb 2008 13:49:35 -0800
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A5B1E55284
	for <linux-xfs@oss.sgi.com>; Mon, 18 Feb 2008 13:49:56 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id vyM500y7MOrmmLb3 for <linux-xfs@oss.sgi.com>; Mon, 18 Feb 2008 13:49:56 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Data safety horror stories?
Date: Mon, 18 Feb 2008 22:49:22 +0100
References: <1202748389.28320.1236240801@webmail.messagingengine.com> <200802182228.50631.Martin@lichtvoll.de> <1203370911.2394.1237549879@webmail.messagingengine.com> (sfid-20080218_224409_788796_CE8843B8)
In-Reply-To: <1203370911.2394.1237549879@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200802182249.22577.Martin@lichtvoll.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: "Felix E. Klee" <felix.klee@inka.de>, Iustin Pop <iusty@k1024.org>

Am Montag 18 Februar 2008 schrieb Felix E. Klee:
> On Mon, 18 Feb 2008 22:28:45 +0100, "Martin Steigerwald"
>
> <Martin@lichtvoll.de> said:
> > I recommend to read my article about write barriers and journalling
> > filesystems for some basic understanding.
> >
> > http://www.linux-magazin.de/heft_abo/sonderheft/2006/04/beschraenktes
> >_schreiben?category=0
> >
> > its in german tough.
>
> Dankeschön - Deutsch ist doch kein Problem. :-)

One thing to add: We have XFS also running on a web cluster for a customer 
with softraid 1 over two RAID arrays. We made sure that write caching is 
disabled as those RAID arrays are not equipped with NVRAM (could be added 
tough, but the customer did not yet). Runs marvelously. Its also running 
on some individual servers in that cluster as well.

Well and although the cluster is spread across two locations about 1 
kilometer from each other and it was said that power supply could not 
fail... well it failed once for both data centers and the cluster 
survived that just fine ;-).

BZW I didn't broke that GPG signature. It seems the mailinglist software 
being used for the xfs mailinglist mangles mails.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
