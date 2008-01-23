Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 03:01:01 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0NB0sbT008865
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 03:00:57 -0800
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59700CD2E62
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 03:01:13 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by cuda.sgi.com with ESMTP id Hjw3vHRp0O1m0Zlo for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 03:01:13 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by enyo.dsw2k3.info (Postfix) with ESMTP id 07E202BDEB
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 12:00:37 +0100 (CET)
Received: from enyo.dsw2k3.info ([127.0.0.1])
	by localhost (enyo.dsw2k3.info [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id iNXs4ePmjeGD for <xfs@oss.sgi.com>;
	Wed, 23 Jan 2008 12:00:31 +0100 (CET)
Received: from citd.de (p4FC4CF12.dip.t-dialin.net [79.196.207.18])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by enyo.dsw2k3.info (Postfix) with ESMTP id 9C1B52BD69
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 12:00:30 +0100 (CET)
Date: Wed, 23 Jan 2008 12:00:27 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: XFS doesn't correctly account for IO-Wait for directory reading
Message-ID: <20080123110027.GA10366@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi


Some days ago Mr. Chinner(?, don't have the e-mail anymore) said that 
XFS fakes ( :-) ) it's way around IO-wait accounting for file-deletion 
by deferring it to the log.

Today i thought again about the initial 'rm -rf'-isn't-accounted-properly
"problem", and the bigger part of "rm -rf" is the 
directory-traversal(IOW read) and not the actual "unlink"-part.

So what better test than a simple 'find'.

Situation: Cache is cold:
find /<wherever> >/dev/null
While running (which takes some time) it shows exactly 0.0%wa in top on 
an otherwise completely idle system, where there should be a near 50%wa 
(Dual-Core system) or 100% on a UP system.

For plain old file-reading the IO-Wait appears to show correctly (AFAICT).
In a short test:
cat <somelargefiles> > /dev/null
peaked at 48%wa (said Dual-Core) with an average around 45%wa.

SO how das XFS fake around IO-wait accounting this time?

Unfortunatly i don't have any sufficiently large non-XFS-filesystems to 
do a good(tm) comparison, but a test on a small ext3-fs appeared to 
correctly(tm) account IO-Wait in directory traversal.

Tested Kernels: 2.6.23 & 2.6.24rc6







Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.
