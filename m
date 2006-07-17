Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 06:21:03 -0700 (PDT)
Received: from rproxy.teamix.net (team.teamix.net [194.150.191.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6HDKmDW011776
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 06:20:48 -0700
Received: from mango.of.teamix.net (unknown [172.21.123.1])
	(using TLSv1 with cipher EXP1024-RC4-SHA (56/128 bits))
	(No client certificate requested)
	by rproxy.teamix.net (Postfix) with ESMTP id E0A7C47E0B
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 13:20:27 +0000 (UTC)
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: Unfixable XFS defect - fatal error -- can't read block 16777216
Date: Mon, 17 Jul 2006 15:20:24 +0200
References: <200607171105.46445.ms@teamix.de>
In-Reply-To: <200607171105.46445.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607171520.25067.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Montag, 17. Juli 2006 11:05 schrieben Sie:

> I darkly recall having read about this problem here before, but I do not
> find the relevant mail anymore. Can anyone give me a pointer on where to
> look?

Hello,

I found it:
http://oss.sgi.com/bugzilla/show_bug.cgi?id=631

Mailing list thread:
XFS crashed twice, once in 2.6.16.20, next in 2.6.17, reproducable

I read that using xfs_repair 2.7.18  might help. I didnt found this in the ftp 
area thus I compiled xfsprogs 2.8.4 under Knoppix 5 and tried with that. 
Unfortunately it isn't able to fix the defect. It shows the same error 
message as the older xfs_repair in Knoppix 5.

The partition in question is 20 gigs. I can create a backup of it, but only 
with partimage which can compress, as I have no 20gig in one place free on 
that harddisk. Tell me when you are interested.

I like to know how I can fix this in place however - the manual way of fixing 
it which is described in the mailing list thread I mentioned above did not 
work according to what I read there.

If nothing else helps I will replay a backup.

Regards,
-- 
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
