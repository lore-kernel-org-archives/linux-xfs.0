Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 May 2007 22:21:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l455LZfB010386
	for <linux-xfs@oss.sgi.com>; Fri, 4 May 2007 22:21:36 -0700
Message-ID: <463C0CD8.4090402@sandeen.net>
Date: Fri, 04 May 2007 23:49:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS crash on linux raid
References: <20070503164521.16efe075@harpe.intellique.com>	<20070504073344.GL32602149@melbourne.sgi.com>	<20070504152546.614374ac@harpe.intellique.com>	<200705041758.21320.Martin@lichtvoll.de> <20070504234357.24d22883@galadriel.home>
In-Reply-To: <20070504234357.24d22883@galadriel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-xfs@oss.sgi.com

Emmanuel Florac wrote:
> Le Fri, 4 May 2007 17:58:21 +0200 vous écriviez:
> 
>> Did you test with ext3 as well? You wrote it crashes with ReiserFS 
>> (version 3) even faster. When it crashes with several filesystems its 
>> unlikely to be a filesystem issue.
> 
> Unfortunately ext3 doesn't support volumes bigger than 8TB, so that's
> useless to me. I plan to test jfs, however.
> I think it's more a dm/md issue, but I'm not sure...
> 

Most recent kernels (2.6.19 or so IIRC) & cvs e2fsprogs (or that from 
rhel5/centos5) can do up to 16T ext3 filesystems, so you should be able 
to test that if you like.

-Eric
