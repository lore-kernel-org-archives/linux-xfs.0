Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 07:48:33 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m63EmUBW032112
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 07:48:30 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2AC31869440
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2008 07:49:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 6vnMJCyQeHkO7ZG3 for <xfs@oss.sgi.com>; Thu, 03 Jul 2008 07:49:29 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 60AC7AC626C
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2008 09:49:29 -0500 (CDT)
Message-ID: <486CE6F9.7000003@sandeen.net>
Date: Thu, 03 Jul 2008 09:49:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: grub fails boot after update
References: <alpine.LNX.1.10.0807011712470.20393@fbirervta.pbzchgretzou.qr> <20080701155522.GA29722@infradead.org> <486C4D7E.8060608@sandeen.net> <20080703044755.GA13630@jdc.jasonjgw.net>
In-Reply-To: <20080703044755.GA13630@jdc.jasonjgw.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Jason White wrote:
> On Wed, Jul 02, 2008 at 10:54:38PM -0500, Eric Sandeen wrote:
>  
>> This really is grub that is busted, but I'd still just suggest using
>> ext3 to (mostly) work around the breakage for the foreseeable future.
>>
>> The other option is to teach grub to always do its io via the filesystem
>> not the block device while the fs is mounted (IIRC there are various &
>> sundry non-intuitive commands which actually nudge grub towards or away
>> from this desired behavior... --with-stage2=/path is one I think,
>> skipping the "verification" phase (i.e. trying to read the block dev
>> while mounted) is another)
> 
> Does grub 2 (still in development when last I checked) improve on this
> situation?

No idea.  Does anyone  use grub2?  My impression is that each distro is
currently just maintaining a fork of grub(1).  If grub2 is using more
than "sync and hope" I'd be pleasantly surprised.  :)

> I managed to get Grub 1 installed on machines with XFS root file systems by
> running the install from within the grub "shell" environment rather than using
> grub-install. Maybe this skips the checks that attempt to read the block
> device directly. I also recall that grub-install failed.

Yep, this might be some of the "magic" I talked about w.r.t. behavior of
different grub incantations.

-Eric
