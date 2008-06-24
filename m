Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 02:30:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5O9UFaM018419
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 02:30:16 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CD5A26F3CD
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 02:31:14 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id xcoA0GE567tYTC0E for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 02:31:14 -0700 (PDT)
Received: from nb27steigerwald.qs.de (unknown [212.204.70.254])
	by mail.lichtvoll.de (Postfix) with ESMTP id A682B5ADEF
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 11:27:46 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: md raid1 passes barriers, but xfs doesn't use them?
Date: Tue, 24 Jun 2008 11:31:11 +0200
References: <48605A8E.9070903@sandeen.net> (sfid-20080624_084605_814814_B137A507)
In-Reply-To: <48605A8E.9070903@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241131.12112.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi Eric!

Am Dienstag 24 Juni 2008 schrieb Eric Sandeen:
> So md raid1 is happy to pass down any barrier writes that it sees, but
> this bit in xfs_mountfs_check_barriers() at mount time:

Interesting. Since when?

On my last test also ext3 disabled barries over device mapper / 
reiserfs[1]. well but I used it with LVM, maybe its different with RAID 
1. I thought this to be a generic device mapper issue.

Did you test with ext3 too?

[1] http://bugzilla.kernel.org/show_bug.cgi?id=9554

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
