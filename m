Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Mar 2007 08:55:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2DFtV6p031134
	for <xfs@oss.sgi.com>; Tue, 13 Mar 2007 08:55:32 -0700
Message-ID: <45F6C972.1080508@sandeen.net>
Date: Tue, 13 Mar 2007 10:55:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <200703131440.56678.clflush@chello.be>
In-Reply-To: <200703131440.56678.clflush@chello.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: clflush <clflush@chello.be>
Cc: xfs@oss.sgi.com

clflush wrote:
> Hi,
> 
> I have a few simple questions regarding the XFS file system. I built a new 
> small server here (commodity hardware, x86-64) and I've installed 32-bit 
> openSUSE 10.2 on it. After the system was installed, configured and up and 
> running, it hung while I was browsing with Firefox. The only thing I could do 
> was to press the reset button on the computer. After the reboot, when I 
> opened Firefox again, I noticed that all my bookmarks were gone. Those 
> bookmarks were imported from my desktop machine a few days after I configured 
> the new server.
> 
> All file systems on this new server are XFS because I heard good things about 
> it and it generally performs better in database operations compared to other 
> file systems available for Linux. However, I was pretty surprised that when I 
> had to reset the machine because it hung for some reason, all the bookmarks 
> in Firefox were gone, so now I have my doubts about the reliability and data 
> integrity of XFS. My older server, which also runs openSUSE 10.2 (32-bit) but 
> uses Ext3 as file system never had such issues and I had to reset it many 
> times because it was hanging for some reason.

sounds like you have several reliability problems ;-)

> Am I right to assume that XFS compared to Ext3 does not do a very good job 
> regarding data integrity? I know a little bit about file systems and I know 
> that most file systems depend on the application to do the right job 
> regarding the way it opens/locks/saves files, but in reality not all 
> applications are written in a safe way to guarantee this.
> 
> Basically, my two question that I have are:
> 
> - Why did I lost bookmarks on a machine running XFS while on another one which 
> runs the same OS version but uses Ext3 as file system, it never happened, no 
> matter how many times I had to reset it.

see also http://oss.sgi.com/projects/xfs/faq.html#nulls

> - Are there any efforts currently made to increase the data integrity of XFS?

this is essentially a loss of buffered data in the VM, outside the realm 
of what xfs can realistically protect.  With ext3, you probably were 
losing your "latest" bookmarks as well, but were luckily(?) getting back 
whatever used to be on-disk.

On the other hand, there were some changes made to xfs to explicitly 
sync files on close, if they have been truncated, which should help this 
sort of problem.  Depending on what's in OpenSuSE 10.2, that change may 
or may not be in your code...

-Eric
