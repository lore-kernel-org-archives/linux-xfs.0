Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 00:28:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q7SBBA000898
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:28:11 -0700
Received: from deliver.uni-koblenz.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FB99D56E74
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:29:10 -0700 (PDT)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15]) by cuda.sgi.com with ESMTP id McU0E6UNOoA6IAFd for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:29:10 -0700 (PDT)
Message-ID: <48634544.3020107@uni-koblenz.de>
Date: Thu, 26 Jun 2008 09:29:08 +0200
From: Christoph Litauer <litauer@uni-koblenz.de>
MIME-Version: 1.0
Subject: Re: Performance problems with millions of inodes
References: <4862598B.80905@uni-koblenz.de> <20080625231210.GF11558@disturbed>
In-Reply-To: <20080625231210.GF11558@disturbed>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner schrieb:
> On Wed, Jun 25, 2008 at 04:43:23PM +0200, Christoph Litauer wrote:
>> Hi,
>>
>> sorry if this has been asked before, I am new to this mailing list. I
>> didn't find any hints in the FAQ or by googling ...
>>
>> I have a backup server driving two kinds of backup software: bacula and
>> backuppc. bacula saves it's backups on raid1, backuppc on raid2
>> (different hardware, but both fast hardware raids).
>> I have massive performance problems with backuppc which I tracked down
>> to performance problems of the filesystem on raid2 (I think so). The
>> main difference between the two backup systems is that backuppc uses
>> millions of inodes for it's backup (in fact it duplicates the directory
>> structure of the backup client).
>>
>> raid1 consists of 91675 inodes, raid2 of 143646439. The filesystems were
>> created without any options. raid1 is about 7 TB, raid2 about 10TB. Both
>> filesystems are mounted with options  
>> '(rw,noatime,nodiratime,ihashsize=65536)'.
>>
>> I used bonnie++ to benchmark both filesystems. Here are the results of
>> 'bonnie++ -u root -f -n 10:0:0:1000':
>>
>> raid1:
>> -------------------
>> Sequential Output: 82505 K/sec
>> Sequential Input : 102192 K/sec
>> Sequential file creation: 7184/sec
>> Random file creation    : 17277/sec
>>
>> raid2:
>> -------------------
>> Sequential Output: 124802 K/sec
>> Sequential Input : 109158 K/sec
>> Sequential file creation: 123/sec
>> Random file creation    : 138/sec
>>
>> As you can see, raid2's throughput is higher than raid1's. But the file
>> creation times are rather slow ...
>>
>> Maybe the 143 million inodes cause this effect?
> 
> Certain will be. You've got about 3 AGs that are holding inodes, so
> that's probably 35M+ inodes per AG. With the way allocation works,
> it's probably doing a dual-traversal of the AGI btree to find a free
> inode "near" to the parent and that is consuming lots and lots of
> CPU time.

So, would more AGs improve performance? As backuppc is still in testing 
state (for me) it would be no problem to create a new xfs filesystem 
with a "better" configuration. I am afraid that the number of inodes 
will increase very much if I backup more clients and filesystems. So, 
what configuration would you recommend?

> 
>> Any idea how to avoid it?
> 
> I had a protoype patch back when I was at SGI than stopped this
> search when the search reached a radius that was no longer "near".
> This greatly reduced CPU time for allocation on large inode count
> AGs and hence create rates increased significantly.
> 
> [Mark - IIRC that patch was in the miscellaneous patch tarball I
> left behind...]
> 
> The only other way of dealing with this is to use inode64 so that
> inodes get spread across the entire filesystem instead of just a
> few AGs at the start of the filesystem. It's too late to change the
> existing inodes, but new inodes would get spread around....

Unfortunatly my backup server is a 32 bit system ...

-- 
Regards
Christoph
________________________________________________________________________
Christoph Litauer                  litauer@uni-koblenz.de
Uni Koblenz, Computing Center,     http://www.uni-koblenz.de/~litauer
Postfach 201602, 56016 Koblenz     Fon: +49 261 287-1311, Fax: -100 1311
PGP-Fingerprint: F39C E314 2650 650D 8092 9514 3A56 FBD8 79E3 27B2
