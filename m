Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB59hK9R065211 for <xfs@oss.sgi.com>; Sun, 5 Dec 2010 03:43:21 -0600
Received: from a.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id A3B931DB7045
	for <xfs@oss.sgi.com>; Sun,  5 Dec 2010 01:45:05 -0800 (PST)
Received: from a.mx.filmlight.ltd.uk (a.mx.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id NkjptsbVyKdMLHEs for
	<xfs@oss.sgi.com>; Sun, 05 Dec 2010 01:45:05 -0800 (PST)
Subject: Re: xfs_repair of critical volume
Mime-Version: 1.0 (Apple Message framework v1081)
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <4CFB19D5.7010301@hardwarefreak.com>
Date: Sun, 5 Dec 2010 09:44:59 +0000
Message-Id: <BEF29149-D71B-4D56-B90B-6B769F9C9EB4@filmlight.ltd.uk>
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>	<201011121422.28993@zmi.at>
	<4CDDBC5C.7020708@hardwarefreak.com>	(sfid-20101113_121516_584378_2321CE16)
	<201012041130.20344.Martin@lichtvoll.de>
	<4CFB19D5.7010301@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com


On 5 Dec 2010, at 04:49, Stan Hoeppner wrote:

> Martin Steigerwald put forth on 12/4/2010 4:30 AM:
>> Am Freitag 12 November 2010 schrieb Stan Hoeppner:
>>> Michael Monnerie put forth on 11/12/2010 7:22 AM:
>>>> I find the robustness of XFS amazing: You overwrote 1/5th of the disk
>>>> with zeroes, and it still works :-)
>>> 
>>> This isn't "robustness" Michael.  If anything it's a serious problem.
>>> XFS is reporting that hundreds or thousands of files that have been
>>> physically removed still exist.  Regardless of how he arrived at this
>>> position, how is this "robust"?  Most people would consider this
>>> inconsistency of state a "corruption" situation, not "robustness".
>> 
>> I think its necessary to differentiate here:
>> 
>> 1) It appears to be robustness - or pure luck - regarding metadata 
>> consistency of the filesystem. I tend to believe its pure luck and that XFS 
>> just stored the metadata on the other RAID arrays.
>> 
>> 2) XFS does not seem to have a way to detect whether file contents are 
>> still valid and consistent. It shares that with I think every other Linux 
>> filesystem instead BTRFS which uses checksumming for files. (Maybe NILFS as 
>> well, I don't know, and the FUSE or the other ZFS port).
> 
> After re-reading my own words above again, I feel I a need to clarify
> something:  I took exception merely to the description of "robustness"
> being used in this situation.  I was not and am not being derogatory of
> XFS in any way.  I love XFS.  Of all available filesystems (on any OS) I
> feel it is the best.  That's why I use it. :)
> 
> In this scenario, other filesystems may have left the OP empty handed.
> So, I guess XFS deserves deserves a positive attribution for this.  But,
> again, I don't think "robustness" is the correct attribution here.

I think 'lucky' is probably a more appropriate term. The chances are that due to the size of the array, all the inodes and the inline extent lists were on the first volume. If' he'd lost that instead, everything would be gone.

--
Roger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
