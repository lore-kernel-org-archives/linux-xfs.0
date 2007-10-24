Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Oct 2007 01:32:33 -0700 (PDT)
Received: from rproxy.teamix.net (team.teamix.net [194.150.191.72])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9O8WPCg003453
	for <xfs@oss.sgi.com>; Wed, 24 Oct 2007 01:32:28 -0700
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: [RFC 0/2] Case-insensitive filename lookup for XFS
Date: Wed, 24 Oct 2007 10:32:21 +0200
References: <op.t0m36sn43jf8g2@pc-bnaujok.melbourne.sgi.com> <200710231422.21637.ms@teamix.de> <op.t0oejdbf3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t0oejdbf3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241032.22157.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Barry Naujok <bnaujok@sgi.com>

Am Mittwoch, 24. Oktober 2007 schrieb Barry Naujok:
> On Tue, 23 Oct 2007 22:22:21 +1000, Martin Steigerwald <ms@teamix.de> wrote:

> > What would happen in the following scenario?
> >
> > mount -t xfs /dev/somedevice /mnt/tmp
> > touch /mnt/tmp/testfile
> > touch /mnt/tmp/Testfile
> > touch /mnt/tmp/TESTFILE
> >
> > mount -t xfs -o remount,ci /dev/somedevice /mnt/tmp
> > rm /mnt/tmp/testfile
>
> testfile would be deleted, Testfile and TESTFILE will remain.
> Subsequent rm's should remove the rest.

Sounds indeed quite clever to me ;-)

I look forward to that feature which could be interesting for samba file 
shares cause samba would not have to map case-insensitive paths from Windows 
to the case-sensitive paths under Linux anymore.

-- 
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
