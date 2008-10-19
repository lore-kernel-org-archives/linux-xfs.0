Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 20:05:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9J353f6014411
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 20:05:04 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70E221430CAD
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 20:06:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id DcXkjaaKl5CczIgO for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 20:06:47 -0700 (PDT)
Message-ID: <48FAA445.9050800@sandeen.net>
Date: Sat, 18 Oct 2008 22:06:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption on the arm(el) architecture
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <48F89E0F.6030307@sandeen.net> <20081018085752.GS25834@deprecation.cyrius.com> <20081019014830.GI31761@disturbed>
In-Reply-To: <20081019014830.GI31761@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Michlmayr <tbm@cyrius.com>, Eric Sandeen <sandeen@sandeen.net>, Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

Dave Chinner wrote:
> On Sat, Oct 18, 2008 at 10:57:56AM +0200, Martin Michlmayr wrote:
>> * Eric Sandeen <sandeen@sandeen.net> [2008-10-17 09:15]:
>>> If you unmount & remount, does the ls work then?
>> I cannot even mount it:
>>
>> debian:~# mkfs.xfs -f /dev/sda5
>> meta-data=/dev/sda5              isize=256    agcount=4, agsize=94380 blks
>>          =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=377519, imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096
>> log      =internal log           bsize=4096   blocks=2560, version=2
>>          =                       sectsz=512   sunit=0 blks, lazy-count=0
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> debian:~# mount /dev/sda5 /mnt
>> [42949596.920000] XFS mounting filesystem sda5
>> debian:~# cp /usr/bin/* /mnt/
>> debian:~# umount /mnt
>> debian:~# mount -t xfs /dev/sda5 /mnt
>> [42949612.290000] XFS mounting filesystem sda5
>> [42949612.460000] Starting XFS recovery on filesystem: sda5 (logdev: internal)
>> [42949612.480000] XFS: xlog_recover_process_data: bad flag
>> [42949612.500000] XFS: log mount/recovery failed: error 5
>> [42949612.500000] XFS: log mount failed
>> mount: /dev/sda5: can't read superblock
>> debian:~#
> 
> That's the log replay indicating that there's a bad transaction
> header in the log. Very strange - it shoul dbe a clean log. What
> does xfs_logprint -t /dev/sda5 tell you about the transactions
> in the log?

This is probably the vmap cache aliasing problem that we paid a bit of
attention to a few months ago, no?

-Eric
