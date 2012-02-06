Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q160p7IF090279 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 18:51:08 -0600
Received: from nm3-vm0.bt.bullet.mail.ukl.yahoo.com
	(nm3-vm0.bt.bullet.mail.ukl.yahoo.com [217.146.182.230]) by
	cuda.sgi.com with SMTP id ICwILzUHJBzvqkET for
	<xfs@oss.sgi.com>; Sun, 05 Feb 2012 16:51:04 -0800 (PST)
Message-ID: <4F2F23F3.9000402@rhul.ac.uk>
Date: Mon, 06 Feb 2012 00:50:59 +0000
From: Tom Crane <T.Crane@rhul.ac.uk>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults with ag_stride option
References: <4F293FCC.7010101@rhul.ac.uk>
	<20120202124248.GA12107@infradead.org>
In-Reply-To: <20120202124248.GA12107@infradead.org>
Content-Type: multipart/mixed; boundary="------------090804090703060000090300"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Crane T <T.Crane@rhul.ac.uk>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090804090703060000090300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christoph,
    Many thanks for the quick response and the patch.  It was a big 
help.  I was able to repair our 60TB FS in about 30 hours. I have a 
couple of questions;

(1) The steps in the progress report seem a little strange.  See the 
attachment. Is this expected?

(2) This may be a little out of band but I have heard second hand 
reports from another sysadmin that the xfs tools which come with SLC5 
(our current Linux distro) should not be relied upon and that SLC6 
should be used.  Our 60TB FS is significantly fragmented (~40%) and I 
would very much like to run xfs_fsr on it.  Given that I have built the 
latest xfsprogs, is there any reason I should be afraid of running 
xfs_fsr, on the FS which comes with SLC5?  Unfortunately I don't have 
~60TB spare storage space elsewhere to backup the FS before defragging.  
What would you advise?

Many thanks
Tom.

Christoph Hellwig wrote:
> Hi Tom,
>
> On Wed, Feb 01, 2012 at 01:36:12PM +0000, Tom Crane wrote:
>   
>> Dear XFS Support,
>>    I am attempting to use xfs_repair to fix a damaged FS but always
>> get a segfault if and only if -o ag_stride is specified. I have
>> tried ag_stride=2,8,16 & 32.  The FS is approx 60T. I can't find
>> reports of this particular problem on the mailing list archive.
>> Further details are;
>>
>> xfs_repair version 3.1.7, recently downloaded via git repository.
>> uname -a
>> Linux store3 2.6.18-274.17.1.el5 #1 SMP Wed Jan 11 11:10:32 CET 2012
>> x86_64 x86_64 x86_64 GNU/Linux
>>     
>
> Thanks for the detailed bug report.
>
> Can you please try the attached patch?
>
>   

--------------090804090703060000090300
Content-Type: text/plain;
 name="xfs_repair4.tmp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_repair4.tmp"

Thu Feb  2 16:46:23 GMT 2012: Starting xfs_repair job with patched xfs_repair
./xfs_repair -V
xfs_repair version 3.1.7
./xfs_repair -m 9000 -o ag_stride=32 /dev/mapper/vg0-lvol0
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 16:46:41: scanning filesystem freespace - 59 of 59 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 16:46:41: scanning agi unlinked lists - 59 of 59 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
        - agno = 48
        - agno = 49
        - agno = 50
        - agno = 51
        - agno = 52
        - agno = 53
        - agno = 54
        - agno = 55
        - agno = 56
        - agno = 57
        - agno = 58
        - 17:01:24: process known inodes and inode discovery - 2048512 of 19546240 inodes done
	- 17:01:24: Phase 3: elapsed time 14 minutes, 43 seconds - processed 139196 inodes per minute
	- 17:01:24: Phase 3: 10% done - estimated remaining time 2 hours, 5 minutes, 42 seconds
        - 17:16:24: process known inodes and inode discovery - 2060224 of 19546240 inodes done
	- 17:16:24: Phase 3: elapsed time 29 minutes, 43 seconds - processed 69328 inodes per minute
	- 17:16:24: Phase 3: 10% done - estimated remaining time 4 hours, 12 minutes, 13 seconds
        - 17:31:24: process known inodes and inode discovery - 2060224 of 19546240 inodes done
	- 17:31:24: Phase 3: elapsed time 44 minutes, 43 seconds - processed 46072 inodes per minute
	- 17:31:24: Phase 3: 10% done - estimated remaining time 6 hours, 19 minutes, 31 seconds
        - 17:46:24: process known inodes and inode discovery - 2074112 of 19546240 inodes done
	- 17:46:24: Phase 3: elapsed time 59 minutes, 43 seconds - processed 34732 inodes per minute
	- 17:46:24: Phase 3: 10% done - estimated remaining time 8 hours, 23 minutes, 2 seconds
        - 18:01:24: process known inodes and inode discovery - 2074368 of 19546240 inodes done
	- 18:01:24: Phase 3: elapsed time 1 hour, 14 minutes, 43 seconds - processed 27763 inodes per minute
	- 18:01:24: Phase 3: 10% done - estimated remaining time 10 hours, 29 minutes, 19 seconds
        - 18:16:24: process known inodes and inode discovery - 2295360 of 19546240 inodes done
	- 18:16:24: Phase 3: elapsed time 1 hour, 29 minutes, 43 seconds - processed 25584 inodes per minute
	- 18:16:24: Phase 3: 11% done - estimated remaining time 11 hours, 14 minutes, 16 seconds
        - 18:31:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 18:31:24: Phase 3: elapsed time 1 hour, 44 minutes, 43 seconds - processed 41082 inodes per minute
	- 18:31:24: Phase 3: 22% done - estimated remaining time 6 hours, 11 minutes, 3 seconds
        - 18:46:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 18:46:24: Phase 3: elapsed time 1 hour, 59 minutes, 43 seconds - processed 35934 inodes per minute
	- 18:46:24: Phase 3: 22% done - estimated remaining time 7 hours, 4 minutes, 13 seconds
        - 19:01:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 19:01:24: Phase 3: elapsed time 2 hours, 14 minutes, 43 seconds - processed 31933 inodes per minute
	- 19:01:24: Phase 3: 22% done - estimated remaining time 7 hours, 57 minutes, 22 seconds
        - 19:16:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 19:16:24: Phase 3: elapsed time 2 hours, 29 minutes, 43 seconds - processed 28734 inodes per minute
	- 19:16:24: Phase 3: 22% done - estimated remaining time 8 hours, 50 minutes, 31 seconds
        - 19:31:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 19:31:24: Phase 3: elapsed time 2 hours, 44 minutes, 43 seconds - processed 26117 inodes per minute
	- 19:31:24: Phase 3: 22% done - estimated remaining time 9 hours, 43 minutes, 40 seconds
        - 19:46:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 19:46:24: Phase 3: elapsed time 2 hours, 59 minutes, 43 seconds - processed 23937 inodes per minute
	- 19:46:24: Phase 3: 22% done - estimated remaining time 10 hours, 36 minutes, 49 seconds
        - 20:01:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 20:01:24: Phase 3: elapsed time 3 hours, 14 minutes, 43 seconds - processed 22093 inodes per minute
	- 20:01:24: Phase 3: 22% done - estimated remaining time 11 hours, 29 minutes, 58 seconds
        - 20:16:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 20:16:24: Phase 3: elapsed time 3 hours, 29 minutes, 43 seconds - processed 20513 inodes per minute
	- 20:16:24: Phase 3: 22% done - estimated remaining time 12 hours, 23 minutes, 7 seconds
        - 20:31:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 20:31:24: Phase 3: elapsed time 3 hours, 44 minutes, 43 seconds - processed 19144 inodes per minute
	- 20:31:24: Phase 3: 22% done - estimated remaining time 13 hours, 16 minutes, 17 seconds
        - 20:46:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 20:46:24: Phase 3: elapsed time 3 hours, 59 minutes, 43 seconds - processed 17946 inodes per minute
	- 20:46:24: Phase 3: 22% done - estimated remaining time 14 hours, 9 minutes, 26 seconds
        - 21:01:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 21:01:24: Phase 3: elapsed time 4 hours, 14 minutes, 43 seconds - processed 16889 inodes per minute
	- 21:01:24: Phase 3: 22% done - estimated remaining time 15 hours, 2 minutes, 35 seconds
        - 21:16:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 21:16:24: Phase 3: elapsed time 4 hours, 29 minutes, 43 seconds - processed 15950 inodes per minute
	- 21:16:24: Phase 3: 22% done - estimated remaining time 15 hours, 55 minutes, 44 seconds
        - 21:31:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 21:31:24: Phase 3: elapsed time 4 hours, 44 minutes, 43 seconds - processed 15109 inodes per minute
	- 21:31:24: Phase 3: 22% done - estimated remaining time 16 hours, 48 minutes, 53 seconds
        - 21:46:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 21:46:24: Phase 3: elapsed time 4 hours, 59 minutes, 43 seconds - processed 14353 inodes per minute
	- 21:46:24: Phase 3: 22% done - estimated remaining time 17 hours, 42 minutes, 2 seconds
        - 22:01:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 22:01:24: Phase 3: elapsed time 5 hours, 14 minutes, 43 seconds - processed 13669 inodes per minute
	- 22:01:24: Phase 3: 22% done - estimated remaining time 18 hours, 35 minutes, 12 seconds
        - 22:16:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 22:16:24: Phase 3: elapsed time 5 hours, 29 minutes, 43 seconds - processed 13047 inodes per minute
	- 22:16:24: Phase 3: 22% done - estimated remaining time 19 hours, 28 minutes, 21 seconds
        - 22:31:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 22:31:24: Phase 3: elapsed time 5 hours, 44 minutes, 43 seconds - processed 12479 inodes per minute
	- 22:31:24: Phase 3: 22% done - estimated remaining time 20 hours, 21 minutes, 30 seconds
        - 22:46:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 22:46:24: Phase 3: elapsed time 5 hours, 59 minutes, 43 seconds - processed 11959 inodes per minute
	- 22:46:24: Phase 3: 22% done - estimated remaining time 21 hours, 14 minutes, 39 seconds
        - 23:01:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 23:01:24: Phase 3: elapsed time 6 hours, 14 minutes, 43 seconds - processed 11480 inodes per minute
	- 23:01:24: Phase 3: 22% done - estimated remaining time 22 hours, 7 minutes, 48 seconds
        - 23:16:24: process known inodes and inode discovery - 4302016 of 19546240 inodes done
	- 23:16:24: Phase 3: elapsed time 6 hours, 29 minutes, 43 seconds - processed 11038 inodes per minute
	- 23:16:24: Phase 3: 22% done - estimated remaining time 23 hours, 57 seconds
        - 23:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 23:31:24: Phase 3: elapsed time 6 hours, 44 minutes, 43 seconds - processed 46135 inodes per minute
	- 23:31:24: Phase 3: 95% done - estimated remaining time 18 minutes, 57 seconds
        - 23:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 23:46:24: Phase 3: elapsed time 6 hours, 59 minutes, 43 seconds - processed 44486 inodes per minute
	- 23:46:24: Phase 3: 95% done - estimated remaining time 19 minutes, 39 seconds
        - 00:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 00:01:24: Phase 3: elapsed time 7 hours, 14 minutes, 43 seconds - processed 42951 inodes per minute
	- 00:01:24: Phase 3: 95% done - estimated remaining time 20 minutes, 21 seconds
        - 00:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 00:16:24: Phase 3: elapsed time 7 hours, 29 minutes, 43 seconds - processed 41518 inodes per minute
	- 00:16:24: Phase 3: 95% done - estimated remaining time 21 minutes, 3 seconds
        - 00:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 00:31:24: Phase 3: elapsed time 7 hours, 44 minutes, 43 seconds - processed 40178 inodes per minute
	- 00:31:24: Phase 3: 95% done - estimated remaining time 21 minutes, 45 seconds
        - 00:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 00:46:24: Phase 3: elapsed time 7 hours, 59 minutes, 43 seconds - processed 38922 inodes per minute
	- 00:46:24: Phase 3: 95% done - estimated remaining time 22 minutes, 28 seconds
        - 01:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 01:01:24: Phase 3: elapsed time 8 hours, 14 minutes, 43 seconds - processed 37742 inodes per minute
	- 01:01:24: Phase 3: 95% done - estimated remaining time 23 minutes, 10 seconds
        - 01:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 01:16:24: Phase 3: elapsed time 8 hours, 29 minutes, 43 seconds - processed 36631 inodes per minute
	- 01:16:24: Phase 3: 95% done - estimated remaining time 23 minutes, 52 seconds
        - 01:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 01:31:24: Phase 3: elapsed time 8 hours, 44 minutes, 43 seconds - processed 35584 inodes per minute
	- 01:31:24: Phase 3: 95% done - estimated remaining time 24 minutes, 34 seconds
        - 01:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 01:46:24: Phase 3: elapsed time 8 hours, 59 minutes, 43 seconds - processed 34595 inodes per minute
	- 01:46:24: Phase 3: 95% done - estimated remaining time 25 minutes, 16 seconds
        - 02:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 02:01:24: Phase 3: elapsed time 9 hours, 14 minutes, 43 seconds - processed 33659 inodes per minute
	- 02:01:24: Phase 3: 95% done - estimated remaining time 25 minutes, 58 seconds
        - 02:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 02:16:24: Phase 3: elapsed time 9 hours, 29 minutes, 43 seconds - processed 32773 inodes per minute
	- 02:16:24: Phase 3: 95% done - estimated remaining time 26 minutes, 40 seconds
        - 02:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 02:31:24: Phase 3: elapsed time 9 hours, 44 minutes, 43 seconds - processed 31932 inodes per minute
	- 02:31:24: Phase 3: 95% done - estimated remaining time 27 minutes, 23 seconds
        - 02:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 02:46:24: Phase 3: elapsed time 9 hours, 59 minutes, 43 seconds - processed 31134 inodes per minute
	- 02:46:24: Phase 3: 95% done - estimated remaining time 28 minutes, 5 seconds
        - 03:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 03:01:24: Phase 3: elapsed time 10 hours, 14 minutes, 43 seconds - processed 30374 inodes per minute
	- 03:01:24: Phase 3: 95% done - estimated remaining time 28 minutes, 47 seconds
        - 03:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 03:16:24: Phase 3: elapsed time 10 hours, 29 minutes, 43 seconds - processed 29651 inodes per minute
	- 03:16:24: Phase 3: 95% done - estimated remaining time 29 minutes, 29 seconds
        - 03:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 03:31:24: Phase 3: elapsed time 10 hours, 44 minutes, 43 seconds - processed 28961 inodes per minute
	- 03:31:24: Phase 3: 95% done - estimated remaining time 30 minutes, 11 seconds
        - 03:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 03:46:24: Phase 3: elapsed time 10 hours, 59 minutes, 43 seconds - processed 28302 inodes per minute
	- 03:46:24: Phase 3: 95% done - estimated remaining time 30 minutes, 53 seconds
        - 04:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 04:01:24: Phase 3: elapsed time 11 hours, 14 minutes, 43 seconds - processed 27673 inodes per minute
	- 04:01:24: Phase 3: 95% done - estimated remaining time 31 minutes, 36 seconds
        - 04:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 04:16:24: Phase 3: elapsed time 11 hours, 29 minutes, 43 seconds - processed 27071 inodes per minute
	- 04:16:24: Phase 3: 95% done - estimated remaining time 32 minutes, 18 seconds
        - 04:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 04:31:24: Phase 3: elapsed time 11 hours, 44 minutes, 43 seconds - processed 26495 inodes per minute
	- 04:31:24: Phase 3: 95% done - estimated remaining time 33 minutes
        - 04:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 04:46:24: Phase 3: elapsed time 11 hours, 59 minutes, 43 seconds - processed 25943 inodes per minute
	- 04:46:24: Phase 3: 95% done - estimated remaining time 33 minutes, 42 seconds
        - 05:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 05:01:24: Phase 3: elapsed time 12 hours, 14 minutes, 43 seconds - processed 25413 inodes per minute
	- 05:01:24: Phase 3: 95% done - estimated remaining time 34 minutes, 24 seconds
        - 05:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 05:16:24: Phase 3: elapsed time 12 hours, 29 minutes, 43 seconds - processed 24905 inodes per minute
	- 05:16:24: Phase 3: 95% done - estimated remaining time 35 minutes, 6 seconds
        - 05:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 05:31:24: Phase 3: elapsed time 12 hours, 44 minutes, 43 seconds - processed 24416 inodes per minute
	- 05:31:24: Phase 3: 95% done - estimated remaining time 35 minutes, 48 seconds
        - 05:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 05:46:24: Phase 3: elapsed time 12 hours, 59 minutes, 43 seconds - processed 23946 inodes per minute
	- 05:46:24: Phase 3: 95% done - estimated remaining time 36 minutes, 31 seconds
        - 06:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 06:01:24: Phase 3: elapsed time 13 hours, 14 minutes, 43 seconds - processed 23494 inodes per minute
	- 06:01:24: Phase 3: 95% done - estimated remaining time 37 minutes, 13 seconds
        - 06:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 06:16:24: Phase 3: elapsed time 13 hours, 29 minutes, 43 seconds - processed 23059 inodes per minute
	- 06:16:24: Phase 3: 95% done - estimated remaining time 37 minutes, 55 seconds
        - 06:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 06:31:24: Phase 3: elapsed time 13 hours, 44 minutes, 43 seconds - processed 22640 inodes per minute
	- 06:31:24: Phase 3: 95% done - estimated remaining time 38 minutes, 37 seconds
        - 06:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 06:46:24: Phase 3: elapsed time 13 hours, 59 minutes, 43 seconds - processed 22235 inodes per minute
	- 06:46:24: Phase 3: 95% done - estimated remaining time 39 minutes, 19 seconds
        - 07:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 07:01:24: Phase 3: elapsed time 14 hours, 14 minutes, 43 seconds - processed 21845 inodes per minute
	- 07:01:24: Phase 3: 95% done - estimated remaining time 40 minutes, 1 second
        - 07:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 07:16:24: Phase 3: elapsed time 14 hours, 29 minutes, 43 seconds - processed 21468 inodes per minute
	- 07:16:24: Phase 3: 95% done - estimated remaining time 40 minutes, 44 seconds
        - 07:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 07:31:24: Phase 3: elapsed time 14 hours, 44 minutes, 43 seconds - processed 21104 inodes per minute
	- 07:31:24: Phase 3: 95% done - estimated remaining time 41 minutes, 26 seconds
        - 07:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 07:46:24: Phase 3: elapsed time 14 hours, 59 minutes, 43 seconds - processed 20752 inodes per minute
	- 07:46:24: Phase 3: 95% done - estimated remaining time 42 minutes, 8 seconds
        - 08:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 08:01:24: Phase 3: elapsed time 15 hours, 14 minutes, 43 seconds - processed 20412 inodes per minute
	- 08:01:24: Phase 3: 95% done - estimated remaining time 42 minutes, 50 seconds
        - 08:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 08:16:24: Phase 3: elapsed time 15 hours, 29 minutes, 43 seconds - processed 20083 inodes per minute
	- 08:16:24: Phase 3: 95% done - estimated remaining time 43 minutes, 32 seconds
        - 08:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 08:31:24: Phase 3: elapsed time 15 hours, 44 minutes, 43 seconds - processed 19764 inodes per minute
	- 08:31:24: Phase 3: 95% done - estimated remaining time 44 minutes, 14 seconds
        - 08:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 08:46:24: Phase 3: elapsed time 15 hours, 59 minutes, 43 seconds - processed 19455 inodes per minute
	- 08:46:24: Phase 3: 95% done - estimated remaining time 44 minutes, 56 seconds
        - 09:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 09:01:24: Phase 3: elapsed time 16 hours, 14 minutes, 43 seconds - processed 19156 inodes per minute
	- 09:01:24: Phase 3: 95% done - estimated remaining time 45 minutes, 39 seconds
        - 09:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 09:16:24: Phase 3: elapsed time 16 hours, 29 minutes, 43 seconds - processed 18865 inodes per minute
	- 09:16:24: Phase 3: 95% done - estimated remaining time 46 minutes, 21 seconds
        - 09:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 09:31:24: Phase 3: elapsed time 16 hours, 44 minutes, 43 seconds - processed 18584 inodes per minute
	- 09:31:24: Phase 3: 95% done - estimated remaining time 47 minutes, 3 seconds
        - 09:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 09:46:24: Phase 3: elapsed time 16 hours, 59 minutes, 43 seconds - processed 18310 inodes per minute
	- 09:46:24: Phase 3: 95% done - estimated remaining time 47 minutes, 45 seconds
        - 10:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 10:01:24: Phase 3: elapsed time 17 hours, 14 minutes, 43 seconds - processed 18045 inodes per minute
	- 10:01:24: Phase 3: 95% done - estimated remaining time 48 minutes, 27 seconds
        - 10:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 10:16:24: Phase 3: elapsed time 17 hours, 29 minutes, 43 seconds - processed 17787 inodes per minute
	- 10:16:24: Phase 3: 95% done - estimated remaining time 49 minutes, 9 seconds
        - 10:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 10:31:24: Phase 3: elapsed time 17 hours, 44 minutes, 43 seconds - processed 17536 inodes per minute
	- 10:31:24: Phase 3: 95% done - estimated remaining time 49 minutes, 51 seconds
        - 10:46:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 10:46:24: Phase 3: elapsed time 17 hours, 59 minutes, 43 seconds - processed 17293 inodes per minute
	- 10:46:24: Phase 3: 95% done - estimated remaining time 50 minutes, 34 seconds
        - 11:01:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 11:01:24: Phase 3: elapsed time 18 hours, 14 minutes, 43 seconds - processed 17056 inodes per minute
	- 11:01:24: Phase 3: 95% done - estimated remaining time 51 minutes, 16 seconds
        - 11:16:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 11:16:24: Phase 3: elapsed time 18 hours, 29 minutes, 43 seconds - processed 16825 inodes per minute
	- 11:16:24: Phase 3: 95% done - estimated remaining time 51 minutes, 58 seconds
        - 11:31:24: process known inodes and inode discovery - 18671744 of 19546240 inodes done
	- 11:31:24: Phase 3: elapsed time 18 hours, 44 minutes, 43 seconds - processed 16601 inodes per minute
	- 11:31:24: Phase 3: 95% done - estimated remaining time 52 minutes, 40 seconds
        - 11:46:24: process known inodes and inode discovery - 19513152 of 19546240 inodes done
	- 11:46:24: Phase 3: elapsed time 18 hours, 59 minutes, 43 seconds - processed 17121 inodes per minute
	- 11:46:24: Phase 3: 99% done - estimated remaining time 1 minute, 55 seconds
        - 12:01:24: process known inodes and inode discovery - 19513152 of 19546240 inodes done
	- 12:01:24: Phase 3: elapsed time 19 hours, 14 minutes, 43 seconds - processed 16898 inodes per minute
	- 12:01:24: Phase 3: 99% done - estimated remaining time 1 minute, 57 seconds
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - 12:03:04: process known inodes and inode discovery - 19546240 of 19546240 inodes done
        - process newly discovered inodes...
        - 12:03:04: process newly discovered inodes - 59 of 59 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 12:03:04: setting up duplicate extent list - 59 of 59 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
        - agno = 48
        - agno = 49
        - agno = 50
        - agno = 51
        - agno = 52
        - agno = 53
        - agno = 54
        - agno = 55
        - agno = 56
        - agno = 57
        - agno = 58
        - 12:16:24: check for inodes claiming duplicate blocks - 2060224 of 19546240 inodes done
	- 12:16:24: Phase 4: elapsed time 13 minutes, 20 seconds - processed 154516 inodes per minute
	- 12:16:24: Phase 4: 10% done - estimated remaining time 1 hour, 53 minutes, 9 seconds
        - 12:31:24: check for inodes claiming duplicate blocks - 2074112 of 19546240 inodes done
	- 12:31:24: Phase 4: elapsed time 28 minutes, 20 seconds - processed 73203 inodes per minute
	- 12:31:24: Phase 4: 10% done - estimated remaining time 3 hours, 58 minutes, 40 seconds
        - 12:46:24: check for inodes claiming duplicate blocks - 2074304 of 19546240 inodes done
	- 12:46:24: Phase 4: elapsed time 43 minutes, 20 seconds - processed 47868 inodes per minute
	- 12:46:24: Phase 4: 10% done - estimated remaining time 6 hours, 4 minutes, 59 seconds
        - 13:01:24: check for inodes claiming duplicate blocks - 2295680 of 19546240 inodes done
	- 13:01:24: Phase 4: elapsed time 58 minutes, 20 seconds - processed 39354 inodes per minute
	- 13:01:24: Phase 4: 11% done - estimated remaining time 7 hours, 18 minutes, 20 seconds
        - 13:16:24: check for inodes claiming duplicate blocks - 4302016 of 19546240 inodes done
	- 13:16:24: Phase 4: elapsed time 1 hour, 13 minutes, 20 seconds - processed 58663 inodes per minute
	- 13:16:24: Phase 4: 22% done - estimated remaining time 4 hours, 19 minutes, 51 seconds
        - 13:31:24: check for inodes claiming duplicate blocks - 4302016 of 19546240 inodes done
	- 13:31:24: Phase 4: elapsed time 1 hour, 28 minutes, 20 seconds - processed 48702 inodes per minute
	- 13:31:24: Phase 4: 22% done - estimated remaining time 5 hours, 13 minutes
        - 13:46:24: check for inodes claiming duplicate blocks - 4302016 of 19546240 inodes done
	- 13:46:24: Phase 4: elapsed time 1 hour, 43 minutes, 20 seconds - processed 41632 inodes per minute
	- 13:46:24: Phase 4: 22% done - estimated remaining time 6 hours, 6 minutes, 9 seconds
        - 14:01:24: check for inodes claiming duplicate blocks - 4302016 of 19546240 inodes done
	- 14:01:24: Phase 4: elapsed time 1 hour, 58 minutes, 20 seconds - processed 36355 inodes per minute
	- 14:01:24: Phase 4: 22% done - estimated remaining time 6 hours, 59 minutes, 18 seconds
        - 14:16:24: check for inodes claiming duplicate blocks - 4302016 of 19546240 inodes done
	- 14:16:24: Phase 4: elapsed time 2 hours, 13 minutes, 20 seconds - processed 32265 inodes per minute
	- 14:16:24: Phase 4: 22% done - estimated remaining time 7 hours, 52 minutes, 28 seconds
        - 14:31:24: check for inodes claiming duplicate blocks - 4302016 of 19546240 inodes done
	- 14:31:24: Phase 4: elapsed time 2 hours, 28 minutes, 20 seconds - processed 29002 inodes per minute
	- 14:31:24: Phase 4: 22% done - estimated remaining time 8 hours, 45 minutes, 37 seconds
        - 14:46:24: check for inodes claiming duplicate blocks - 4302016 of 19546240 inodes done
	- 14:46:24: Phase 4: elapsed time 2 hours, 43 minutes, 20 seconds - processed 26338 inodes per minute
	- 14:46:24: Phase 4: 22% done - estimated remaining time 9 hours, 38 minutes, 46 seconds
        - 15:01:24: check for inodes claiming duplicate blocks - 4302016 of 19546240 inodes done
	- 15:01:24: Phase 4: elapsed time 2 hours, 58 minutes, 20 seconds - processed 24123 inodes per minute
	- 15:01:24: Phase 4: 22% done - estimated remaining time 10 hours, 31 minutes, 55 seconds
        - 15:16:24: check for inodes claiming duplicate blocks - 4302016 of 19546240 inodes done
	- 15:16:24: Phase 4: elapsed time 3 hours, 13 minutes, 20 seconds - processed 22251 inodes per minute
	- 15:16:24: Phase 4: 22% done - estimated remaining time 11 hours, 25 minutes, 4 seconds
        - 15:31:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 15:31:24: Phase 4: elapsed time 3 hours, 28 minutes, 20 seconds - processed 89624 inodes per minute
	- 15:31:24: Phase 4: 95% done - estimated remaining time 9 minutes, 45 seconds
        - 15:46:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 15:46:24: Phase 4: elapsed time 3 hours, 43 minutes, 20 seconds - processed 83604 inodes per minute
	- 15:46:24: Phase 4: 95% done - estimated remaining time 10 minutes, 27 seconds
        - 16:01:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 16:01:24: Phase 4: elapsed time 3 hours, 58 minutes, 20 seconds - processed 78342 inodes per minute
	- 16:01:24: Phase 4: 95% done - estimated remaining time 11 minutes, 9 seconds
        - 16:16:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 16:16:24: Phase 4: elapsed time 4 hours, 13 minutes, 20 seconds - processed 73704 inodes per minute
	- 16:16:24: Phase 4: 95% done - estimated remaining time 11 minutes, 51 seconds
        - 16:31:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 16:31:24: Phase 4: elapsed time 4 hours, 28 minutes, 20 seconds - processed 69584 inodes per minute
	- 16:31:24: Phase 4: 95% done - estimated remaining time 12 minutes, 34 seconds
        - 16:46:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 16:46:24: Phase 4: elapsed time 4 hours, 43 minutes, 20 seconds - processed 65900 inodes per minute
	- 16:46:24: Phase 4: 95% done - estimated remaining time 13 minutes, 16 seconds
        - 17:01:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 17:01:24: Phase 4: elapsed time 4 hours, 58 minutes, 20 seconds - processed 62586 inodes per minute
	- 17:01:24: Phase 4: 95% done - estimated remaining time 13 minutes, 58 seconds
        - 17:16:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 17:16:24: Phase 4: elapsed time 5 hours, 13 minutes, 20 seconds - processed 59590 inodes per minute
	- 17:16:24: Phase 4: 95% done - estimated remaining time 14 minutes, 40 seconds
        - 17:31:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 17:31:24: Phase 4: elapsed time 5 hours, 28 minutes, 20 seconds - processed 56868 inodes per minute
	- 17:31:24: Phase 4: 95% done - estimated remaining time 15 minutes, 22 seconds
        - 17:46:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 17:46:24: Phase 4: elapsed time 5 hours, 43 minutes, 20 seconds - processed 54383 inodes per minute
	- 17:46:24: Phase 4: 95% done - estimated remaining time 16 minutes, 4 seconds
        - 18:01:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 18:01:24: Phase 4: elapsed time 5 hours, 58 minutes, 20 seconds - processed 52107 inodes per minute
	- 18:01:24: Phase 4: 95% done - estimated remaining time 16 minutes, 46 seconds
        - 18:16:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 18:16:24: Phase 4: elapsed time 6 hours, 13 minutes, 20 seconds - processed 50013 inodes per minute
	- 18:16:24: Phase 4: 95% done - estimated remaining time 17 minutes, 29 seconds
        - 18:31:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 18:31:24: Phase 4: elapsed time 6 hours, 28 minutes, 20 seconds - processed 48081 inodes per minute
	- 18:31:24: Phase 4: 95% done - estimated remaining time 18 minutes, 11 seconds
        - 18:46:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 18:46:24: Phase 4: elapsed time 6 hours, 43 minutes, 20 seconds - processed 46293 inodes per minute
	- 18:46:24: Phase 4: 95% done - estimated remaining time 18 minutes, 53 seconds
        - 19:01:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 19:01:24: Phase 4: elapsed time 6 hours, 58 minutes, 20 seconds - processed 44633 inodes per minute
	- 19:01:24: Phase 4: 95% done - estimated remaining time 19 minutes, 35 seconds
        - 19:16:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 19:16:24: Phase 4: elapsed time 7 hours, 13 minutes, 20 seconds - processed 43088 inodes per minute
	- 19:16:24: Phase 4: 95% done - estimated remaining time 20 minutes, 17 seconds
        - 19:31:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 19:31:24: Phase 4: elapsed time 7 hours, 28 minutes, 20 seconds - processed 41647 inodes per minute
	- 19:31:24: Phase 4: 95% done - estimated remaining time 20 minutes, 59 seconds
        - 19:46:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 19:46:24: Phase 4: elapsed time 7 hours, 43 minutes, 20 seconds - processed 40298 inodes per minute
	- 19:46:24: Phase 4: 95% done - estimated remaining time 21 minutes, 42 seconds
        - 20:01:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 20:01:24: Phase 4: elapsed time 7 hours, 58 minutes, 20 seconds - processed 39035 inodes per minute
	- 20:01:24: Phase 4: 95% done - estimated remaining time 22 minutes, 24 seconds
        - 20:16:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 20:16:24: Phase 4: elapsed time 8 hours, 13 minutes, 20 seconds - processed 37848 inodes per minute
	- 20:16:24: Phase 4: 95% done - estimated remaining time 23 minutes, 6 seconds
        - 20:31:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 20:31:24: Phase 4: elapsed time 8 hours, 28 minutes, 20 seconds - processed 36731 inodes per minute
	- 20:31:24: Phase 4: 95% done - estimated remaining time 23 minutes, 48 seconds
        - 20:46:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 20:46:24: Phase 4: elapsed time 8 hours, 43 minutes, 20 seconds - processed 35678 inodes per minute
	- 20:46:24: Phase 4: 95% done - estimated remaining time 24 minutes, 30 seconds
        - 21:01:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 21:01:24: Phase 4: elapsed time 8 hours, 58 minutes, 20 seconds - processed 34684 inodes per minute
	- 21:01:24: Phase 4: 95% done - estimated remaining time 25 minutes, 12 seconds
        - 21:16:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 21:16:24: Phase 4: elapsed time 9 hours, 13 minutes, 20 seconds - processed 33744 inodes per minute
	- 21:16:24: Phase 4: 95% done - estimated remaining time 25 minutes, 54 seconds
        - 21:31:24: check for inodes claiming duplicate blocks - 18671744 of 19546240 inodes done
	- 21:31:24: Phase 4: elapsed time 9 hours, 28 minutes, 20 seconds - processed 32853 inodes per minute
	- 21:31:24: Phase 4: 95% done - estimated remaining time 26 minutes, 37 seconds
        - 21:46:24: check for inodes claiming duplicate blocks - 19427904 of 19546240 inodes done
	- 21:46:24: Phase 4: elapsed time 9 hours, 43 minutes, 20 seconds - processed 33304 inodes per minute
	- 21:46:24: Phase 4: 99% done - estimated remaining time 3 minutes, 33 seconds
        - 22:01:24: check for inodes claiming duplicate blocks - 19513152 of 19546240 inodes done
	- 22:01:24: Phase 4: elapsed time 9 hours, 58 minutes, 20 seconds - processed 32612 inodes per minute
	- 22:01:24: Phase 4: 99% done - estimated remaining time 1 minute
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - 22:03:25: check for inodes claiming duplicate blocks - 19546240 of 19546240 inodes done
Phase 5 - rebuild AG headers and trees...
        - 22:03:27: rebuild AG headers and trees - 59 of 59 allocation groups done
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
Fri Feb  3 22:04:30 GMT 2012: Finished xfs_repair job

--------------090804090703060000090300
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------090804090703060000090300--
