Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 15:34:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBMNXtqw017664
	for <linux-xfs@oss.sgi.com>; Fri, 22 Dec 2006 15:33:56 -0800
Message-ID: <458C6B32.5090004@sandeen.net>
Date: Fri, 22 Dec 2006 17:33:06 -0600
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
> Hi, Eric,
> 
> RE:
>>> xfs_check: unexpected XFS SB magic number 0x45464920
>> That spells "EFI"
> 
> Does this have any special meaning? E.g. I could figure out who
> labelled the disk (array)?

EFI is a bootloader....

>> looks like somebody came along & labeled your disk for you.  Dangers of
>> being on a san I suppose (if you are....)
> 
> Humm. This is an FC5 with SMP opteron. The RAID-5 (12 disks) is ran by
> an ARECA 1130-ML card.
> 
>> repair might fix it....
> 
> I worry that what repair will leave behind is pure numbers (and many of those), like
> 11212/
> 12133/
> 121212/
> ...
> and to reconstruct ~3Tb from that is not trivial...
> 
> This reminds me: what paranoid safety measures can one take? E.g keep
> an external log of the filesystem as well?
> 
> Thanks for the thoughts!
> 
> Gaspar
> 
