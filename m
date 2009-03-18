Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2I2D89u197144 for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 21:13:29 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADC751C4DF91
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 19:12:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id gVsuCNUdq7EJx2y1 for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2009 19:12:26 -0700 (PDT)
Message-ID: <49C05887.10207@sandeen.net>
Date: Tue, 17 Mar 2009 21:12:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Lost files + indentical Foldernames on XFS Partition
References: <49BFDC6E.6050607@liga01.de> <49BFDDC5.9060500@sandeen.net>
	<49C029AF.5070205@liga01.de>
In-Reply-To: <49C029AF.5070205@liga01.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Steffen.Knauf@liga01.de
Cc: xfs@oss.sgi.com

Steffen Knauf wrote:
>> Steffen Knauf wrote:
>>   
>>> Hello,
>>>
>>> today i have a strange behavior. I have a a directory which contains 
>>> lots of indentical Folders with the same Name and Inode.
>>>     
>> What kernel? 
> 
> Linux version 2.6.16.60-0.21-smp (geeko@buildhost) (gcc version 4.1.2 
> 20070115 (SUSE Linux))

Would probably be good to try an upstream kernel to see if it persists,
if you can; otherwise for an older distro kernel like this, a report to
SuSE would be in order.

>> Can you cut and paste what you see? 
> 
> Really strange is that if execute only a 'ls' command the files are 
> shown twice:
> 
> combine_sbn.0051.tga
> combine_sbn.0051.tga
> 
> But if i execute 'ls -il' the output looks like this:
> 
> combine_sbn.0051.tga: Datei oder Verzeichnis nicht gefunden
> combine_sbn.0057.tga: Datei oder Verzeichnis nicht gefunden
> combine_sbn.0058.tga: Datei oder Verzeichnis nicht gefunden

so the filename is in the directory but doesn't point to a valid file I
guess.

> Here a directory example:
> 
> 2147642598 drwxrwxrwx 2 500 500 4096 2009-03-17 12:33 
> S14-01_Fische_beauty_Main
> 2147642598 drwxrwxrwx 2 500 500 4096 2009-03-17 12:33 
> S14-01_Fische_beauty_Main
> 
>>> I don't create Hardlinks or something else. On the other side some files 
>>> are suddenly vanished. A "ls -al" result in the following error: 
>>> "Access  to bla not possible: File or Directory not found."
>>> I don't find some Errormessages in the logfile. I don't know whether a 
>>> xfs_check make sense.
>>>     
>> xfs_repair -n will check the filesystem without actually modifying anything.
>>   
> I'll try it....

You could also create an xfs_metadump to save for later investigation.

-Eric

>> -Eric
>>   
> Steffen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
