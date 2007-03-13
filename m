Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Mar 2007 08:13:32 -0700 (PDT)
Received: from amsfep18-int.chello.nl (amsfep17-int.chello.nl [213.46.243.15] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2DFDN6p017617
	for <xfs@oss.sgi.com>; Tue, 13 Mar 2007 08:13:26 -0700
Received: from cable-213-132-129-14.upc.chello.be ([213.132.129.14])
          by amsfep11-int.chello.nl
          (InterMail vM.6.01.04.04 201-2131-118-104-20050224) with ESMTP
          id <20070313134057.RBZM2958.amsfep11-int.chello.nl@cable-213-132-129-14.upc.chello.be>
          for <xfs@oss.sgi.com>; Tue, 13 Mar 2007 14:40:57 +0100
From: clflush <clflush@chello.be>
Subject: Questions about XFS
Date: Tue, 13 Mar 2007 14:40:56 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703131440.56678.clflush@chello.be>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I have a few simple questions regarding the XFS file system. I built a new 
small server here (commodity hardware, x86-64) and I've installed 32-bit 
openSUSE 10.2 on it. After the system was installed, configured and up and 
running, it hung while I was browsing with Firefox. The only thing I could do 
was to press the reset button on the computer. After the reboot, when I 
opened Firefox again, I noticed that all my bookmarks were gone. Those 
bookmarks were imported from my desktop machine a few days after I configured 
the new server.

All file systems on this new server are XFS because I heard good things about 
it and it generally performs better in database operations compared to other 
file systems available for Linux. However, I was pretty surprised that when I 
had to reset the machine because it hung for some reason, all the bookmarks 
in Firefox were gone, so now I have my doubts about the reliability and data 
integrity of XFS. My older server, which also runs openSUSE 10.2 (32-bit) but 
uses Ext3 as file system never had such issues and I had to reset it many 
times because it was hanging for some reason.

Am I right to assume that XFS compared to Ext3 does not do a very good job 
regarding data integrity? I know a little bit about file systems and I know 
that most file systems depend on the application to do the right job 
regarding the way it opens/locks/saves files, but in reality not all 
applications are written in a safe way to guarantee this.

Basically, my two question that I have are:

- Why did I lost bookmarks on a machine running XFS while on another one which 
runs the same OS version but uses Ext3 as file system, it never happened, no 
matter how many times I had to reset it.

- Are there any efforts currently made to increase the data integrity of XFS?

Regards
