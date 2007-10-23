Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Oct 2007 05:55:30 -0700 (PDT)
Received: from rproxy.teamix.net (team.teamix.net [194.150.191.72])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9NCtN7u010118
	for <xfs@oss.sgi.com>; Tue, 23 Oct 2007 05:55:26 -0700
Received: from mango.of.teamix.net (unknown [172.21.123.1])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by rproxy.teamix.net (Postfix) with ESMTP id C8C6947E6A
	for <xfs@oss.sgi.com>; Tue, 23 Oct 2007 12:22:20 +0000 (UTC)
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: [RFC 0/2] Case-insensitive filename lookup for XFS
Date: Tue, 23 Oct 2007 14:22:21 +0200
References: <op.t0m36sn43jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t0m36sn43jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710231422.21637.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Am Dienstag, 23. Oktober 2007 schrieb Barry Naujok:

Hi Barry,

> To allow case-insensitivity to be a mount option rather than
> a mkfs option, the hashes stored on disk are always case-folded.
> This is indicated by the new "unicode" bit in the superblock.
> This bit also associated with the presence of the case-folding
> table on disk.

What would happen in the following scenario?

mount -t xfs /dev/somedevice /mnt/tmp
touch /mnt/tmp/testfile
touch /mnt/tmp/Testfile
touch /mnt/tmp/TESTFILE

mount -t xfs -o remount,ci /dev/somedevice /mnt/tmp
rm /mnt/tmp/testfile

(I think I do not understand enough of XFS to read that myself out of your 
patch.)

Ciao,
-- 
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
