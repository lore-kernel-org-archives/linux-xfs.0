Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 01:50:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3A8ogYI002484
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 01:50:44 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 563FD773538
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 01:51:20 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id c852ZzmV1sX56lkp for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 01:51:20 -0700 (PDT)
Date: Thu, 10 Apr 2008 10:51:20 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Lost+found
Message-ID: <20080410105120.153ea739@harpe.intellique.com>
In-Reply-To: <47FCC071.40201@sandeen.net>
References: <1207632033.11530.10.camel@localhost.localdomain>
	<op.t9bm23aa3jf8g2@pc-bnaujok.melbourne.sgi.com>
	<alpine.DEB.1.10.0804090628080.322@p34.internal.lan>
	<47FCC071.40201@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Barry Naujok <bnaujok@sgi.com>, Jeffrey Sandel <webmaster@javainbaja.com>, xfs@oss.sgi.com

Le Wed, 09 Apr 2008 08:11:13 -0500
Eric Sandeen <sandeen@sandeen.net> écrivait:

> Crosses my mind that one could probably write a generic tool which
> could work with a package manager db to check file md5sums
> in /lost+found, if the files happen to be system files installed via
> a package....

Yup, I've done something similar when I used a PC with a bugged via
chipset which regularly broke apart filesystems under heavy load... I
used a tool named afick to index the whole disks (it stores md5 of
everything in a small db) and with some tinkering I was able to restore
everything from lost+found each time some filesystem went belly up
(once a month...)

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
