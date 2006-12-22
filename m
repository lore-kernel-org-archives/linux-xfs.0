Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 15:37:26 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBMNbKqw018357
	for <linux-xfs@oss.sgi.com>; Fri, 22 Dec 2006 15:37:21 -0800
Message-ID: <458C6719.6080106@sandeen.net>
Date: Fri, 22 Dec 2006 17:15:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: unexpected XFS SB magic number
References: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu>
In-Reply-To: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: gbakos@cfa.harvard.edu
Cc: linux-xfs@oss.sgi.com

Gaspar Bakos wrote:
> Dear all,
> 
> I have a 12 x 500Gb RAID-5 hardware RAID array on an ARECA 1130-ML
> controller. There is one single partition on it, exported as /dev/sdc1.
> This configuration used to work fine for 4 months.
> Then the computer crashed a couple of times, and led to a situation where
> 
> xfs_check /dev/sdc1 output is:
> 
> xfs_check: unexpected XFS SB magic number 0x45464920

That spells "EFI"

looks like somebody came along & labeled your disk for you.  Dangers of 
being on a san I suppose (if you are....)

repair might fix it....

-Eric
