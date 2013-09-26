Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C40F27F50
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 09:59:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 918CC8F8073
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 07:59:44 -0700 (PDT)
Received: from mail-ve0-f178.google.com (mail-ve0-f178.google.com
	[209.85.128.178]) by cuda.sgi.com with ESMTP id
	FuuFoRFHC9UGbFx2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 07:59:42 -0700 (PDT)
Received: by mail-ve0-f178.google.com with SMTP id jw12so1020364veb.9
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 07:59:41 -0700 (PDT)
Message-ID: <52444BDD.9060100@gmail.com>
Date: Thu, 26 Sep 2013 10:59:41 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: Issues and new to the group
References: <0e4201cebaae$24873680$6d95a380$@host2max.com>	<5244234D.1010603@hardwarefreak.com>
	<100f01cebaba$0ae84280$20b8c780$@host2max.com>
In-Reply-To: <100f01cebaba$0ae84280$20b8c780$@host2max.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 09/26/2013 09:12 AM, Ronnie Tartar wrote:
> Stan,
>
> Thanks for the reply.
>
> My fragmentation is:
>
> [root@AP-FS1 ~]# xfs_db -c frag -r /dev/xvdb1
> actual 10470159, ideal 10409782, fragmentation factor 0.58%

This was never likely the cause ...

[...]

> This is running virtualized, definitely not a rust bucket.  It's x5570 cpus

... well, this is likely the cause (virtualized)

> with MD3200 Array with light I/O.
>
> Seems like i/o wait is not problem, system% is problem.  Is this the OS
> trying to find spot for these files?

 From your previous description

> takes.  The folders are image folders that have anywhere between 5 to
> 10 million images in each folder.

The combination of very large folders, and virtualization is working 
against you.  Couple that with an old (ancient by Linux standards) xfs 
in the virtual CentOS 5.9 system, and you aren't going to have much joy 
with this without changing a few things.

First and foremost:

Can you change from one single large folder to a heirarchical set of 
folders?  The single large folder means any metadata operation (ls, 
stat, open, close) has a huge set of lists to traverse.  It will work, 
albiet slowly.  As a rule of thumb, we try to make sure our users don't 
go much beyond 10k files/folder.  If they need to, building a heirarchy 
of folders slightly increases management complexity, but keeps the lists 
that are needed to be traversed much smaller.

A strategy for doing this:  If your files are named "aaaa0001" 
"aaaa0002" ... "zzzz9999" or similar, then you can chop off the first 
letter, and make a directory of it, and then put all files starting with 
that letter in that directory.  Then within each of those directories, 
do the same thing with the second letter.  This gets you 676 directories 
and about 15k files per directory.  Much faster directory operations. 
Much smaller lists to traverse.

If you can't change the layout, this is a much harder problem to solve, 
though you could do it by using one very large file, maintaining your 
own start/end and file metadata in other files, and writing your files 
at specific offsets (start and end above).  This isn't a good solution 
unless you know how to write file systems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
