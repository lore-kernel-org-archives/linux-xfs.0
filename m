Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 21:47:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m634l1s4004597
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 21:47:01 -0700
Received: from opera.rednote.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98BD4D94A82
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2008 21:48:04 -0700 (PDT)
Received: from opera.rednote.net (opera.rednote.net [75.125.70.226]) by cuda.sgi.com with ESMTP id bOqkML1GLIWk3nEb for <xfs@oss.sgi.com>; Wed, 02 Jul 2008 21:48:04 -0700 (PDT)
Received: from jdc.jasonjgw.net (localhost6.localdomain6 [IPv6:::1])
	by opera.rednote.net (8.14.2/8.14.2) with ESMTP id m634m0MH003787
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 04:48:02 GMT
Received: from jdc.jasonjgw.net (ip6-localhost [IPv6:::1])
	by jdc.jasonjgw.net (8.14.3/8.14.3/Debian-4) with ESMTP id m634ltwF020723
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 14:47:55 +1000
Received: (from jason@localhost)
	by jdc.jasonjgw.net (8.14.3/8.14.3/Submit) id m634ltlq020722
	for xfs@oss.sgi.com; Thu, 3 Jul 2008 14:47:55 +1000
Date: Thu, 3 Jul 2008 14:47:55 +1000
From: Jason White <jason@jasonjgw.net>
Subject: Re: grub fails boot after update
Message-ID: <20080703044755.GA13630@jdc.jasonjgw.net>
References: <alpine.LNX.1.10.0807011712470.20393@fbirervta.pbzchgretzou.qr> <20080701155522.GA29722@infradead.org> <486C4D7E.8060608@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486C4D7E.8060608@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Jul 02, 2008 at 10:54:38PM -0500, Eric Sandeen wrote:
 
> This really is grub that is busted, but I'd still just suggest using
> ext3 to (mostly) work around the breakage for the foreseeable future.
> 
> The other option is to teach grub to always do its io via the filesystem
> not the block device while the fs is mounted (IIRC there are various &
> sundry non-intuitive commands which actually nudge grub towards or away
> from this desired behavior... --with-stage2=/path is one I think,
> skipping the "verification" phase (i.e. trying to read the block dev
> while mounted) is another)

Does grub 2 (still in development when last I checked) improve on this
situation?

I managed to get Grub 1 installed on machines with XFS root file systems by
running the install from within the grub "shell" environment rather than using
grub-install. Maybe this skips the checks that attempt to read the block
device directly. I also recall that grub-install failed.
