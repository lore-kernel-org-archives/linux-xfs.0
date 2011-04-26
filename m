Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3QLmrVX183973
	for <linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 16:48:53 -0500
Received: from mail.1-click.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6117815C975A
	for <linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 14:52:24 -0700 (PDT)
Received: from mail.1-click.hu (ns2.netcenter.hu [195.228.155.139]) by
	cuda.sgi.com with ESMTP id EoPbzvKpj369vm48 for
	<linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 14:52:24 -0700 (PDT)
Message-ID: <45DD2814B0C84BF3AFD76721A0178E50@myXP>
From: "Janos Haar" <janos.haar@netcenter.hu>
References: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
	<20110411214238.GE21395@dastard>
Subject: Re: 2 question about XFS fragmentation and _fsr: SPLITTED Q1:sparse
	files
Date: Tue, 26 Apr 2011 23:51:08 +0200
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com

Note: I have splitted my previous letter for easyer discusion...
This have only Question-1 the storage with only sparse files.

----- Original Message ----- 
From: "Dave Chinner" <david@fromorbit.com>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-xfs@oss.sgi.com>
Sent: Monday, April 11, 2011 11:42 PM
Subject: Re: 2 question about XFS fragmentation and _fsr


> On Mon, Apr 11, 2011 at 07:39:07PM +0200, Janos Haar wrote:
>> Hello list,
>> 
>> First, please CC me because i am not on the list.
>> 
>> Question 1:
>> I am working in a data recovery company, and we are using one 3TB
>> RAID storage with XFS to store the recovery cases in image files.
>> For spare a lot of space, usually we are imaging only the used
>> spaces of the filesystems. (for example 1TB system drive wich have
>> only 80GB data inside but needs to be bootable, the image is similar
>> like Ghost images)
>> But this makes a lot of sparse files, wich right should be this way.
>> Some cases are done and we are closed (image can be deleted), and
>> some needs to store for long time.
>> In the result, actually we have >6TB images on the 3TB disk, wich is
>> 97.9% fragmented.
> 
> How are you determining that figure?

[root@UNISTORE admin]# cat xfs_get_frat_ratio
echo loop0
xfs_db -c frag -r /dev/loop0
[root@UNISTORE admin]# ./xfs_get_frat_ratio
loop0
actual 7650952, ideal 752501, fragmentation factor 90.16%

> 
>> Basically the sparse RAW disk images should be more faster
>> accessible than the original drive, because this is 4disk raid,
>> instead of one, AND the head don't need to travel through the empty
>> space of the drive...
>> But actually we are proud if we can read or write in 8-10MB/s! :-D
>> I have started to read about xfs_fsr but there is almost none
>> information, how it is _really_ working, and i am doubt about this
>> will try to fill up all of my images, and therefore fail to do any
>> improvement, or this will do the right job and will re-organize the
>> sparse files again.
>> The XFS_FSR can be good for me or not?
> 
> xfs_fsr preserves the layout of sparse files, so it is unlikely to
> help you at all here. Remember, sparse files only reduce the amount
> of space used by a file - they don't magically reduce the number of
> seeks needed to read data from the files...

Yes of course, but heads needs move more closer from one point to another.
I think this should reduce the seeking time.
Or i have missed something? :)

> 
>> If not, i suggest to implement an option to do sparse fles on the
>> result or not in the next releases...
>> I will say a huge thanks in the end. :-)
>> 

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

Thanks,
Janos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
