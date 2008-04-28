Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 02:42:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3S9fsB9030104
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 02:41:56 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDBB11214AED
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 02:42:36 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id UBzyfBS4VqjAk2Bh for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 02:42:36 -0700 (PDT)
Date: Mon, 28 Apr 2008 11:42:38 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: disk I/O error
Message-ID: <20080428114238.67b5a633@harpe.intellique.com>
In-Reply-To: <1d3e8bf0804220842r26411f51vc714da371255aa90@mail.gmail.com>
References: <1d3e8bf0804220842r26411f51vc714da371255aa90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dovydas Sankauskas <laisve@gmail.com>, xfs@oss.sgi.com

Le Tue, 22 Apr 2008 15:42:45 +0000
"Dovydas Sankauskas" <laisve@gmail.com> écrivait:

> Any insight on what has happened and what are my chances to restore
> data? Here are my logs.

The disk physically died while in use. You may try to cycle power a
couple of times on it, it may revive it for a while. 

If this is not enough, maybe the USB interface is broken. You can
remove the drive from the enclosure and use a direct ATA or SATA
connection to your PC and see if it works any better.

If the disk isn't detected when using a direct ATA or SATA connection,
it's dead once and for all, and your only hope would be Ontrack or
another data recovery service. If the disk is detected but partially
readable (I/O errors), you may repair it using disk tools like SpinRite.
Last, if the disk is detected but completely unreadable, _sometimes_
putting it to the freezer for 15 minutes in a very closely sealed
plastic bag /may/ revive it for a while, as a very last resort.

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
