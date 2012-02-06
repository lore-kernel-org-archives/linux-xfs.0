Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q165wR0B103557 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 23:58:27 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id nOR36PD9ofZK5VvV for <xfs@oss.sgi.com>;
	Sun, 05 Feb 2012 21:58:25 -0800 (PST)
Message-ID: <4F2F6C00.5050108@sandeen.net>
Date: Sun, 05 Feb 2012 23:58:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults with ag_stride option
References: <4F293FCC.7010101@rhul.ac.uk>
	<20120202124248.GA12107@infradead.org>
	<4F2F23F3.9000402@rhul.ac.uk>
In-Reply-To: <4F2F23F3.9000402@rhul.ac.uk>
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
To: Tom Crane <T.Crane@rhul.ac.uk>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 2/5/12 6:50 PM, Tom Crane wrote:
> Hi Christoph,
> Many thanks for the quick response and the patch. It was a big help.
> I was able to repair our 60TB FS in about 30 hours. I have a couple
> of questions;
> 
> (1) The steps in the progress report seem a little strange. See the
> attachment. Is this expected?
> 
> (2) This may be a little out of band but I have heard second hand
> reports from another sysadmin that the xfs tools which come with SLC5
> (our current Linux distro) should not be relied upon and that SLC6
> should be used. Our 60TB FS is significantly fragmented (~40%) and I
> would very much like to run xfs_fsr on it. Given that I have built
> the latest xfsprogs, is there any reason I should be afraid of
> running xfs_fsr, on the FS which comes with SLC5? Unfortunately I
> don't have ~60TB spare storage space elsewhere to backup the FS
> before defragging. What would you advise?> 
> Many thanks

Newer tools are fine to use on older filesystems, there should be no
issue there.

running fsr can cause an awful lot of IO, and a lot of file reorganization.
(meaning, they will get moved to new locations on disk, etc).

How bad is it, really?  How did you arrive at the 40% number?  Unless
you see perf problems which you know you can attribute to fragmentation,
I might not worry about it.

You can also check the fragmentation of individual files with the
xfs_bmap tool.

-Eric

> Tom.
> 
> Christoph Hellwig wrote:
>> Hi Tom,
>>
>> On Wed, Feb 01, 2012 at 01:36:12PM +0000, Tom Crane wrote:
>>  
>>> Dear XFS Support,
>>>    I am attempting to use xfs_repair to fix a damaged FS but always
>>> get a segfault if and only if -o ag_stride is specified. I have
>>> tried ag_stride=2,8,16 & 32.  The FS is approx 60T. I can't find
>>> reports of this particular problem on the mailing list archive.
>>> Further details are;
>>>
>>> xfs_repair version 3.1.7, recently downloaded via git repository.
>>> uname -a
>>> Linux store3 2.6.18-274.17.1.el5 #1 SMP Wed Jan 11 11:10:32 CET 2012
>>> x86_64 x86_64 x86_64 GNU/Linux
>>>     
>>
>> Thanks for the detailed bug report.
>>
>> Can you please try the attached patch?
>>
>>   
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
