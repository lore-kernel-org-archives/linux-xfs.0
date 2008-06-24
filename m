Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 06:33:45 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5ODXdpD011162
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 06:33:41 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74DDB1811135
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 06:34:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id rhajC7I21ms9QHxD for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 06:34:30 -0700 (PDT)
Message-ID: <4860F7E4.2080106@sandeen.net>
Date: Tue, 24 Jun 2008 08:34:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: md raid1 passes barriers, but xfs doesn't use them?
References: <48605A8E.9070903@sandeen.net> (sfid-20080624_084605_814814_B137A507) <200806241131.12112.Martin@lichtvoll.de>
In-Reply-To: <200806241131.12112.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Martin Steigerwald wrote:
> Hi Eric!
> 
> Am Dienstag 24 Juni 2008 schrieb Eric Sandeen:
>> So md raid1 is happy to pass down any barrier writes that it sees, but
>> this bit in xfs_mountfs_check_barriers() at mount time:
> 
> Interesting. Since when?

Which part?  :)  XFS has done the flag check for a very long time...

> On my last test also ext3 disabled barries over device mapper / 
> reiserfs[1]. well but I used it with LVM, maybe its different with RAID 
> 1. I thought this to be a generic device mapper issue.
> 
> Did you test with ext3 too?

This is xfs-specific; ext3 does not look for the queue ordered flag so
won't have this problem on md raid1.

> [1] http://bugzilla.kernel.org/show_bug.cgi?id=9554

but that's for device-mapper, which has never supported barriers ....
I'm talking about md raid1 here (not dm).

-Eric

> Ciao,
