Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Mar 2007 08:49:25 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.179])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2DFnH6p029616
	for <xfs@oss.sgi.com>; Tue, 13 Mar 2007 08:49:18 -0700
Message-ID: <45F6C503.5010608@gmx.net>
Date: Tue, 13 Mar 2007 16:36:35 +0100
From: Klaus Strebel <klaus.strebel@gmx.net>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <200703131440.56678.clflush@chello.be>
In-Reply-To: <200703131440.56678.clflush@chello.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: clflush <clflush@chello.be>
Cc: xfs@oss.sgi.com

clflush schrieb:
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
> 
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
> 
> - Are there any efforts currently made to increase the data integrity of XFS?
> 
> Regards
> 
> 
Hi,

short and rude answer: 'Search the archives and FAQs'.

Simply short answer: no and no.

Longer answer: XFS only cares about meta-data integrity, if unwritten 
extends exist in memory, you'll get these empty on the disk if you reset 
your box. You should consider using the 'Magic SysRq' hotkeys to 
emergency sync your disk in cases like these before you reset your box.

Ciao
Klaus

-- 
Mit freundlichen Grüssen / best regards

Klaus Strebel, Dipl.-Inform. (FH), mailto:klaus.strebel@gmx.net

/"\
\ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
/ \
