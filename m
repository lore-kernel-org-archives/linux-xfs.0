Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Mar 2008 03:40:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2IAeYdj030487
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 03:40:36 -0700
Received: from MTA009E.interbusiness.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67846FC17AB
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 03:41:03 -0700 (PDT)
Received: from MTA009E.interbusiness.it (MTA009E.interbusiness.it [88.44.62.9]) by cuda.sgi.com with ESMTP id lkOdIygP5yWRCBnk for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 03:41:03 -0700 (PDT)
Date: Tue, 18 Mar 2008 11:41:01 +0100
From: Marco Gaiarin <gaio@sv.lnf.it>
Subject: Re: XFS check script on boot?
Message-ID: <20080318104055.GA7903@sv.lnf.it>
References: <20080317134847.GJ14510@sv.lnf.it> <20080318011210.GA12727@jdc.jasonjgw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080318011210.GA12727@jdc.jasonjgw.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jason White <jason@jasonjgw.net>, xfs@oss.sgi.com

Mandi! Jason White
  In chel di` si favelave...

> The purpose of a journaling file system is to make time-consuming fsck and
> similar checks unnecessary after a reboot.

I know exactly that, and indeed, i agree.

I'm not speaking about writing a script that check everytime the
filesystem, but sometime (triggered by /forcefsck?)

The problem arise when you have on a remote site people with low
knowledge, and have to instruct them to run the kernel in
init=/bin/bash mode or in initrd 'emergency' mode, spelling all command
by phone.
[ok, a remote controlled KVM switch is on the buy list ;]

With a such boot script, if a fsck was forced, and a corruption founded,
the system ask for root password and an operator find a shell with /
mounted readonly and all other system unmounted (eg, the 'normal' way
of checking eg, for EXT3; apart that for other filesystem a 'simple'
check are ever tried, and password are asked only for serious corruption
that need 'fsck -f').

A good starting point for trying a recovery.

-- 
dott. Marco Gaiarin				    GNUPG Key ID: 240A3D66
  Associazione ``La Nostra Famiglia''                http://www.sv.lnf.it/
  Polo FVG  -  Via della Bontà, 7 - 33078  -  San Vito al Tagliamento (PN)
  marco.gaiarin(at)sv.lnf.it	  tel +39-0434-842711  fax +39-0434-842797
