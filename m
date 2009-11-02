Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2LodUa096087 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 15:50:39 -0600
Received: from mxout-08.mxes.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5A95566D0
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 13:50:52 -0800 (PST)
Received: from mxout-08.mxes.net (mxout-08.mxes.net [216.86.168.183]) by
	cuda.sgi.com with ESMTP id m53XAiL6GFLuG3FF for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2009 13:50:52 -0800 (PST)
Message-ID: <4AEF5438.5050801@aol.com>
Date: Mon, 02 Nov 2009 16:50:48 -0500
From: "AndrewL733@aol.com" <AndrewL733@aol.com>
MIME-Version: 1.0
Subject: Re: XFS and DPX files
References: <4AEC2CF4.8040703@aol.com>
	<4AEC4BAA.20606@aol.com>	<20091031174836.3fc9505b@galadriel.home>	<200911021205.28006@zmi.at>
	<20091102185249.0da8e388@harpe.intellique.com>
In-Reply-To: <20091102185249.0da8e388@harpe.intellique.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com


>> I believe for a 15 drive RAID-6, where 2 disks are used forredundancy, the correct mkfs would be:
>> mkfs -t xfs -d su=65536,sw=13 /dev/sdXX
>>     
>
> Yes you're right, I replied a bit too quickly :)
>
>
>   
>> Another thing to try is if it would help to turn disk cache writes
>> *on*, despite all warnings if the FAQ. 
>>     

Thank you for your suggestions.  Yes I have write caching enabled. And I 
have StorSave set to "Performance". And I have a UPS on the system at 
all times!

The information about barriers was useful.  In years past I was running 
much older firmware for the 3ware 9650 cards and that did not support 
barriers.  But it is true the current firmware does support barriers.  I 
also believe the 3ware StorSave "Performance" setting will disable 
barriers as well -- at least it makes the card ignore FUA commands.

Anyway, I have mounted the XFS filesystem with the "nobarrier" flag and 
I'm still seeing the same behavior.  If you want to take a closer look 
at what I mean, please go to this link:

    http://sites.google.com/site/andrewl733info/xfs_and_dpx

At this point, I have tried the following -- and none of these 
approaches seems to fix the problem:

    -- preallocation of DPX files
    -- reservation of DXP files (Make 10,000 zero-byte files named
    0000001.dpx through 0010000.dpx)
    -- creating xfs filesystem with external log device (also a 16-drive
    RAID array, because that's what I have available)
    -- mounting with large logbsize
    -- mounting with more logbufs
    -- mounting with larger allocsize


Again, I want to point out that I don't have any problem with the 
underlying RAID device.  On Linux itself, I get Bonnie++ scores of 
around 740 MB/sec reading and 650 MB/sec writing, minimum.  Over 10 
Gigabit Ethernet, I can write uncompressed HD streams (160 MB/sec) and I 
can read 2K DPX files (300+ MB/sec).  DD shows similar results.

My gut feeling is that XFS is falling over after creating a certain 
number of new files.  Because the DPX format creates one file for every 
frame (30 files/sec), it's not really a video stream. It's really like 
making 30 photoshop files per second. It seems as if some resource that 
XFS needs is being used up after a certain number of files are created, 
and that it is very disruptive and costly to get more of that resource. 
Why ext3 and ext4 can keep going past 60,000 files and xfs falls over 
after 4000 or 5000 files, I do not understand.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
