Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 15:38:57 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBMNcpqw018710
	for <linux-xfs@oss.sgi.com>; Fri, 22 Dec 2006 15:38:53 -0800
Message-ID: <458C6C5A.6090504@sandeen.net>
Date: Fri, 22 Dec 2006 17:38:02 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: unexpected XFS SB magic number
References: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu> <458C6719.6080106@sandeen.net> <Pine.SOL.4.58.0612221824500.2856@titan.cfa.harvard.edu>
In-Reply-To: <Pine.SOL.4.58.0612221824500.2856@titan.cfa.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: gbakos@cfa.harvard.edu
Cc: linux-xfs@oss.sgi.com

Gaspar Bakos wrote:

> This reminds me: what paranoid safety measures can one take? E.g keep
> an external log of the filesystem as well?

it looks like you wound up with an efi bootloader splatted over the 
front of your partition.  maybe the raid got scrambled around?  Or maybe 
someone actually installed a bootloader over an otherwise-ok filesystem? 
  hard to say.  not sure what could have prevented either of those.

are you sure the raid is in the right shape, and in the right order of 
disks?

i also remember something about parted (maybe...) finding a backup gpt 
signature at the end of a disk, and "helpfully" copying it over the 
front end if so.  This was a bug.  sgi guys do you remember?

-Eric



> Thanks for the thoughts!
> 
> Gaspar
> 
