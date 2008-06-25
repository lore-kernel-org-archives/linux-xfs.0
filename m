Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 07:45:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5PEjW3W004223
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 07:45:32 -0700
Received: from deliver.uni-koblenz.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE05ED49067
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 07:46:32 -0700 (PDT)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15]) by cuda.sgi.com with ESMTP id GfhbkyFBQT1DBQTO for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 07:46:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by deliver.uni-koblenz.de (Postfix) with ESMTP id 80985789A6A0
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 16:46:31 +0200 (CEST)
Received: from deliver.uni-koblenz.de ([127.0.0.1])
 by localhost (deliver.uni-koblenz.de [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30132-04 for <xfs@oss.sgi.com>;
 Wed, 25 Jun 2008 16:46:30 +0200 (CEST)
Received: from bruch.uni-koblenz.de (bruch.uni-koblenz.de [141.26.64.66])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by deliver.uni-koblenz.de (Postfix) with ESMTP id 3DBC1789A633
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 16:46:30 +0200 (CEST)
Message-ID: <48625A46.1060206@uni-koblenz.de>
Date: Wed, 25 Jun 2008 16:46:30 +0200
From: Christoph Litauer <litauer@uni-koblenz.de>
MIME-Version: 1.0
Subject: Re: Performance problems with millions of inodes
References: <4862598B.80905@uni-koblenz.de>
In-Reply-To: <4862598B.80905@uni-koblenz.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Christoph Litauer schrieb:
> Hi,
> 
> sorry if this has been asked before, I am new to this mailing list. I
> didn't find any hints in the FAQ or by googling ...
> 
> I have a backup server driving two kinds of backup software: bacula and
> backuppc. bacula saves it's backups on raid1, backuppc on raid2
> (different hardware, but both fast hardware raids).
> I have massive performance problems with backuppc which I tracked down
> to performance problems of the filesystem on raid2 (I think so). The
> main difference between the two backup systems is that backuppc uses
> millions of inodes for it's backup (in fact it duplicates the directory
> structure of the backup client).
> 
> raid1 consists of 91675 inodes, raid2 of 143646439. The filesystems were
> created without any options. raid1 is about 7 TB, raid2 about 10TB. Both
> filesystems are mounted with options 
> '(rw,noatime,nodiratime,ihashsize=65536)'.
> 
> I used bonnie++ to benchmark both filesystems. Here are the results of
> 'bonnie++ -u root -f -n 10:0:0:1000':
> 
> raid1:
> -------------------
> Sequential Output: 82505 K/sec
> Sequential Input : 102192 K/sec
> Sequential file creation: 7184/sec
> Random file creation    : 17277/sec
> 
> raid2:
> -------------------
> Sequential Output: 124802 K/sec
> Sequential Input : 109158 K/sec
> Sequential file creation: 123/sec
> Random file creation    : 138/sec
> 
> As you can see, raid2's throughput is higher than raid1's. But the file
> creation times are rather slow ...
> 
> Maybe the 143 million inodes cause this effect? Any idea how to avoid it?
> 

Just another (xfs_)info about raid2:

meta-data=/dev/backuppc/backuppc isize=256    agcount=32, 
agsize=79691776 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=2550136832, imaxpct=25
          =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

-- 
Regards
Christoph
________________________________________________________________________
Christoph Litauer                  litauer@uni-koblenz.de
Uni Koblenz, Computing Center,     http://www.uni-koblenz.de/~litauer
Postfach 201602, 56016 Koblenz     Fon: +49 261 287-1311, Fax: -100 1311
PGP-Fingerprint: F39C E314 2650 650D 8092 9514 3A56 FBD8 79E3 27B2
