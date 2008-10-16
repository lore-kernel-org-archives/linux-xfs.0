Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 06:32:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9GDWPgs006940
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 06:32:25 -0700
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02F25A9CACC
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 06:34:07 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by cuda.sgi.com with ESMTP id SKvEiFcsqfVql4lH for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 06:34:07 -0700 (PDT)
Received: from [192.168.236.156] (helo=isper.nabble.com)
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1KqSzP-0005Tg-11
	for xfs@oss.sgi.com; Thu, 16 Oct 2008 06:34:07 -0700
Message-ID: <20013835.post@talk.nabble.com>
Date: Thu, 16 Oct 2008 06:33:17 -0700 (PDT)
From: ibulescu <tibi_1980@yahoo.com>
Subject: Re: How can I recover data?
In-Reply-To: <op.ui3qn3lk3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <19996090.post@talk.nabble.com> <op.ui3ckqw83jf8g2@pc-bnaujok.melbourne.sgi.com> <20007191.post@talk.nabble.com> <op.ui3qn3lk3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Tried that too... but no luck.

The only thing I've modified was
"write core.mode 040755" and after some time of "printing inodes" I've
runned xfs_repair in modify mode but nothing good happened. Almost all
inodes have "next_unlinked" set to null and the time in 1 Jan 1970. The All
folder has the time in 2008 but even after xfs_repair moved the folder in
lost+found it's still empty and named 186.

The conclusion is: all data lost? If so what is the best way to reformat the
volume to not have the same problems again? The "no space left on the
device" and "lose all data" problems? 
I have an UPS on that server, so the bad shutdown corruption will not
happen.

I know all the files and folders are still there because no write
opperations occured but I don't have a way to read them because the
filesystem can't find the "connections"...



Barry Naujok-3 wrote:
> 
> On Thu, 16 Oct 2008 16:06:23 +1100, ibulescu <tibi_1980@yahoo.com> wrote:
> 
>> There is a 186 directory in lost+found but it's empty and there are only  
>> 6Mb
>> of space occupied on the volume. In total there are 2 empty folders, 186  
>> and
>> 191 and 4 zero size files, 187 to 190.
>>
>> I have recovered almost all of my data using reiserfs in the same  
>> scenario
>> but I can't find a solution using xfs.
> 
> 
> Ah, misread the trace:
> 
>>>         - agno = 0
>>> entry "All" in shortform directory 186 references free inode 136
>>> junking entry "All" in directory inode 186
> 
> Inode 136 is the "All" directory - for some reason, it's marked as
> deleted.
> 
> Since you don't really have much to lose, you can try the following:
> 
> # xfs_db -x <dev>
> xfs_db> inode 136
> xfs_db> print
> 
> If it appears to be inode data (and not all zeros):
> 
> xfs_db> write mode 040755
> xfs_db> quit
> 
> # xfs_repair -n <dev>
> 
> and see what it reports.
> 
> The "write mode 040755" command mark the inodes as a directory and not  
> deleted.
> 
> You may try that with the following items too:
> 
>>> entry "All.info.xml" in shortform directory 186 references free inode  
>>> 137
>>> junking entry "All.info.xml" in directory inode 186
>>> bad attribute format 1 in inode 191, resetting value
>>> entry "rhi-rp11.iso" in shortform directory 191 references free inode  
>>> 134
>>> junking entry "rhi-rp11.iso" in directory inode 191
>>> entry "rhi.nfo" in shortform directory 191 references free inode 135
>>> junking entry "rhi.nfo" in directory inode 191
>>>         - agno = 1
> 
>> Barry Naujok-3 wrote:
>>>
>>> On Thu, 16 Oct 2008 02:35:40 +1100, ibulescu <tibi_1980@yahoo.com>  
>>> wrote:
>>>
>>>> Hello,
>>>> how can I recover the data?
>>>>
>>>> Here is my story:
>>>>
>>>> I have openfiler installed with LVM and a single xfs partition over 7
>>>> sata
>>>> hdd's. Yesterday I discovered that I can't write any files to the xfs
>>>> partition, even if there was 1,2Tb free space. I've googled alot and
>>>> modified the label of all partitions to GPT (that seemed to be the
>>>> problem
>>>> with xfs, or so I've imagined and I've used parted - mklabel). After  
>>>> that
>>>> I've rebooted and all data was gone. The parted program changed the
>>>> partitions UUID's. I've manualy set original partitions UUID from lvm
>>>> backup's and restored the volume group. The partition from the volume
>>>> group
>>>> was there but XFS can't mount the filesystem. After running xfs_repair
>>>> this
>>>> is the result:
>>>> - all the data was contained in a single folder named "All" which was
>>>> deleted by the repair
>>>
>>> All was inode 186:
>>>
>>>> entry "All" in shortform directory 186 references free inode 136
>>>> junking entry "All" in directory inode 186
>>>
>>> which is now in lost+found:
>>>
>>>> disconnected dir inode 186, moving to lost+found
>>>
>>> So, you should find the contents of the All directory in
>>> /lost+found/186/
>>>
>>>
>>>> ----Begin copy----
>>>> bad magic number 0x0 on inode 183, resetting magic number
>>>> bad version number 0x0 on inode 183, resetting version number
>>>> bad magic number 0x0 on inode 184, resetting magic number
>>>> bad version number 0x0 on inode 184, resetting version number
>>>> bad magic number 0x0 on inode 185, resetting magic number
>>>> bad version number 0x0 on inode 185, resetting version number
>>>> imap claims in-use inode 186 is free, correcting imap
>>>> imap claims in-use inode 187 is free, correcting imap
>>>> imap claims in-use inode 188 is free, correcting imap
>>>> imap claims in-use inode 189 is free, correcting imap
>>>> imap claims in-use inode 190 is free, correcting imap
>>>> bad attribute leaf magic # 0 for dir ino 191
>>>> problem with attribute contents in inode 191
>>>> clearing inode 191 attributes
>>>> correcting nblocks for inode 191, was 1 - counted 0
>>>> imap claims in-use inode 191 is free, correcting imap
>>>>         - agno = 1
>>>>         - agno = 2
>>>>         - agno = 3
>>>>         - agno = 4
>>>>         - agno = 5
>>>>         - agno = 6
>>>>         - agno = 7
>>>>         - agno = 8
>>>>         - agno = 9
>>>>         - agno = 10
>>>>         - agno = 11
>>>>         - agno = 12
>>>>         - agno = 13
>>>>         - agno = 14
>>>>         - agno = 15
>>>>         - agno = 16
>>>>         - agno = 17
>>>>         - agno = 18
>>>>         - agno = 19
>>>>         - agno = 20
>>>>         - agno = 21
>>>>         - agno = 22
>>>>         - agno = 23
>>>>         - agno = 24
>>>>         - agno = 25
>>>>         - agno = 26
>>>>         - agno = 27
>>>>         - agno = 28
>>>>         - agno = 29
>>>>         - agno = 30
>>>>         - agno = 31
>>>>         - agno = 32
>>>>         - agno = 33
>>>>         - agno = 34
>>>>         - agno = 35
>>>>         - agno = 36
>>>>         - agno = 37
>>>>         - agno = 38
>>>>         - agno = 39
>>>>         - agno = 40
>>>>         - agno = 41
>>>>         - agno = 42
>>>>         - agno = 43
>>>>         - agno = 44
>>>>         - agno = 45
>>>>         - agno = 46
>>>>         - agno = 47
>>>>         - agno = 48
>>>>         - agno = 49
>>>>         - agno = 50
>>>>         - agno = 51
>>>>         - agno = 52
>>>>         - agno = 53
>>>>         - agno = 54
>>>>         - agno = 55
>>>>         - agno = 56
>>>>         - agno = 57
>>>>         - agno = 58
>>>>         - agno = 59
>>>>         - agno = 60
>>>>         - agno = 61
>>>>         - agno = 62
>>>>         - agno = 63
>>>>         - agno = 64
>>>>         - agno = 65
>>>>         - agno = 66
>>>>         - agno = 67
>>>>         - agno = 68
>>>>         - agno = 69
>>>>         - agno = 70
>>>>         - agno = 71
>>>>         - agno = 72
>>>>         - agno = 73
>>>>         - agno = 74
>>>>         - process newly discovered inodes...
>>>> Phase 4 - check for duplicate blocks...
>>>>         - setting up duplicate extent list...
>>>> root inode lost
>>>>         - clear lost+found (if it exists) ...
>>>>         - check for inodes claiming duplicate blocks...
>>>>         - agno = 0
>>>> entry "All" in shortform directory 186 references free inode 136
>>>> junking entry "All" in directory inode 186
>>>> entry "All.info.xml" in shortform directory 186 references free inode  
>>>> 137
>>>> junking entry "All.info.xml" in directory inode 186
>>>> bad attribute format 1 in inode 191, resetting value
>>>> entry "rhi-rp11.iso" in shortform directory 191 references free inode  
>>>> 134
>>>> junking entry "rhi-rp11.iso" in directory inode 191
>>>> entry "rhi.nfo" in shortform directory 191 references free inode 135
>>>> junking entry "rhi.nfo" in directory inode 191
>>>>         - agno = 1
>>>>         - agno = 2
>>>>         - agno = 3
>>>>         - agno = 4
>>>>         - agno = 5
>>>>         - agno = 6
>>>>         - agno = 7
>>>>         - agno = 8
>>>>         - agno = 9
>>>>         - agno = 10
>>>>         - agno = 11
>>>>         - agno = 12
>>>>         - agno = 13
>>>>         - agno = 14
>>>>         - agno = 15
>>>>         - agno = 16
>>>>         - agno = 17
>>>>         - agno = 18
>>>>         - agno = 19
>>>>         - agno = 20
>>>>         - agno = 21
>>>>         - agno = 22
>>>>         - agno = 23
>>>>         - agno = 24
>>>>         - agno = 25
>>>>         - agno = 26
>>>>         - agno = 27
>>>>         - agno = 28
>>>>         - agno = 29
>>>>         - agno = 30
>>>>         - agno = 31
>>>>         - agno = 32
>>>>         - agno = 33
>>>>         - agno = 34
>>>>         - agno = 35
>>>>         - agno = 36
>>>>         - agno = 37
>>>>         - agno = 38
>>>>         - agno = 39
>>>>         - agno = 40
>>>>         - agno = 41
>>>>         - agno = 42
>>>>         - agno = 43
>>>>         - agno = 44
>>>>         - agno = 45
>>>>         - agno = 46
>>>>         - agno = 47
>>>>         - agno = 48
>>>>         - agno = 49
>>>>         - agno = 50
>>>>         - agno = 51
>>>>         - agno = 52
>>>>         - agno = 53
>>>>         - agno = 54
>>>>         - agno = 55
>>>>         - agno = 56
>>>>         - agno = 57
>>>>         - agno = 58
>>>>         - agno = 59
>>>>         - agno = 60
>>>>         - agno = 61
>>>>         - agno = 62
>>>>         - agno = 63
>>>>         - agno = 64
>>>>         - agno = 65
>>>>         - agno = 66
>>>>         - agno = 67
>>>>         - agno = 68
>>>>         - agno = 69
>>>>         - agno = 70
>>>>         - agno = 71
>>>>         - agno = 72
>>>>         - agno = 73
>>>>         - agno = 74
>>>> Phase 5 - rebuild AG headers and trees...
>>>>         - reset superblock...
>>>> Phase 6 - check inode connectivity...
>>>> reinitializing root directory
>>>> reinitializing realtime bitmap inode
>>>> reinitializing realtime summary inode
>>>>         - resetting contents of realtime bitmap and summary inodes
>>>>         - ensuring existence of lost+found directory
>>>>         - traversing filesystem starting at / ...
>>>>         - traversal finished ...
>>>>         - traversing all unattached subtrees ...
>>>>         - traversals finished ...
>>>>         - moving disconnected inodes to lost+found ...
>>>> disconnected dir inode 186, moving to lost+found
>>>> disconnected inode 187, moving to lost+found
>>>> disconnected inode 188, moving to lost+found
>>>> disconnected inode 189, moving to lost+found
>>>> disconnected inode 190, moving to lost+found
>>>> disconnected dir inode 191, moving to lost+found
>>>> Phase 7 - verify and correct link counts...
>>>> resetting inode 128 nlinks from 2 to 3
>>>> resetting inode 186 nlinks from 3 to 2
>>>> Warning:  quota inodes were cleared.  Quotas disabled.
>>>> Note - stripe unit (0) and width (0) fields have been reset.
>>>> Please set with mount -o sunit=<value>,swidth=<value>
>>>> done
>>>> [root@nas01 /]#
>>>> ----End copy----
>>>
>>>
>>>
>>>
>>>
>>
> 
> 
> 
> 
> 

-- 
View this message in context: http://www.nabble.com/How-can-I-recover-data--tp19996090p20013835.html
Sent from the Xfs - General mailing list archive at Nabble.com.
