Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 10:16:10 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms2.lichtvoll.de [194.150.191.235] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6OHFuDW003379
	for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 10:15:57 -0700
Received: from localhost (dslb-084-056-077-111.pools.arcor-ip.net [84.56.77.111])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id C0B45FA68A
	for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 19:15:24 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: currupted files filling with zeros after power failure
Date: Mon, 24 Jul 2006 19:15:19 +0200
References: <20060724160317.GA787@venus.synerway.com>
In-Reply-To: <20060724160317.GA787@venus.synerway.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607241915.19642.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Montag 24 Juli 2006 18:03 schrieb Pascal GREGIS:

[ files with zero at the end after switching off the computer abruptly)

> I didn't think XFS could be subject to this type of problem, however
> here isn't really the reason of my mail.

Hello Pascal,

it is. Cause it does not do data journaling and it doesn't ensure that the 
data that belongs to a metadata change (i.e. enlarge a file) makes it to 
the disk before the metadate change. Read about "Journaling options and 
write latency" in

http://www-128.ibm.com/developerworks/library/l-fs8.html

to find out more about this. XFS behaves like ext3 with "data=writeback". 

This is the fastest mode of operation. "data=ordered" => writing data 
before metadata is slightly slower and "data=journal" => data journalling 
is twice as slow. AFAIK only Reiser4 (and the commercial WAFL) can do 
fast data journaling by use of its wandering logs feature:

http://en.wikipedia.org/wiki/Wandering_log

> What I would like to know is what can I do to resolve this problem? Is
> XFS able to recover my file with its right content, at least a
> consistent content, not only \0 characters? I made some tries with
> xfs_repair and it didn't repair it, once it put me some inodes in
> lost+found but id didn't repair my corrupted file. Maybe xfs_db could
> help, I don't know.

I think you can't fix it without changing XFS to support either data 
journaling or writing data before metadata.

BTW seen from the metadata side the files are not corrupted. The 
filesystem structure is still fine. Any application that relies on the 
integrity of the file contents will have a problem tough. Its a speed 
versus data safety issue unless you use some kind of wandering logs or a 
another approach which doesn't require writing data twice.

Still with data journaling you may get a certain granularity depending on 
its implementation, maybe a 4K (page granularity) write (data + metadata) 
made it through, while some more writes where missing. Ideally either a 
write *as issued* by the application will make it through completely or 
not at all.

An additional approach is having some sort of data journaling in the 
application which should know best about the integrity of its own data. 
Many databases and servers take some precautions to ensure data integrity 
in case of a crash.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
