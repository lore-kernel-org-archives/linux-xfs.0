Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 02:04:22 -0700 (PDT)
Received: from rproxy.teamix.net (team.teamix.net [194.150.191.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6J93uDW031519
	for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 02:03:58 -0700
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: stable xfs
Date: Wed, 19 Jul 2006 09:40:05 +0200
References: <1153150223.4532.24.camel@localhost.localdomain> <20060719095400.A1936041@wobbly.melbourne.sgi.com>
In-Reply-To: <20060719095400.A1936041@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607190940.05596.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Ming Zhang <mingz@ele.uri.edu>, xfs@oss.sgi.com

Am Mittwoch, 19. Juli 2006 01:54 schrieb Nathan Scott:
> On Mon, Jul 17, 2006 at 11:30:23AM -0400, Ming Zhang wrote:
> > Hi All
> >
> > We want to use XFS in all of our production servers but feel a little
> > scary about the corruption problems seen in this list. I wonder which
> > 2.6.16+ kernel we can use in order to get a stable XFS? Thanks!
>
> Use the latest 2.6.17 -stable release, or a vendor kernel (SLES is
> particularly good with XFS, as SGI works closely with SUSE).

Hello Nathan,

as far as I can see the fix for kernel bug #6757 has not yet made it in a 
stable kernel release upto 2.6.17.6 and thus should manually be applied:

http://bugzilla.kernel.org/show_bug.cgi?id=6757

It probably doesn't happen for lots of people but I would still apply that 
patch unless it is finally put into a stable point release.

Regards,
-- 
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
