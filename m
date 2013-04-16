Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E6D4C7F4C
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 20:45:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C30388F8054
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 18:45:16 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id mokN4wGIFSAtKWda
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 18:45:16 -0700 (PDT)
Message-ID: <516CAD27.4070408@hardwarefreak.com>
Date: Mon, 15 Apr 2013 20:45:11 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_fsr, sunit, and swidth
References: <5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
	<5142AE40.6040408@hardwarefreak.com>
	<20130315114538.GF6369@dastard>
	<5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard> <515082C3.2000006@binghamton.edu>
	<515361B5.8050603@hardwarefreak.com>
	<5155F2B2.1010308@binghamton.edu>
	<20130331012231.GJ6369@dastard> <515C3BF3.60601@binghamton.edu>
	<51684382.50008@binghamton.edu>
	<5168AC0B.5010100@hardwarefreak.com>
	<516C649A.8010003@binghamton.edu>
In-Reply-To: <516C649A.8010003@binghamton.edu>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Hall <kdhall@binghamton.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 4/15/2013 3:35 PM, Dave Hall wrote:
> Stan,
> 
> I understand that this will be an ongoing problem.  It seems like all I could do at this point would be to ' manually defrag' my inodes the hard way by doing this 'copy' operation whenever things slow down.  (Either that or go get my PHD in file systems and try to come up with a better inode management algorithm.)  I will be keeping two copies of this data going forward anyways.
> 
> Are there any other suggestions you might have at this time - xfs or otherwise?

I'm no expert in this particular area, so I'll simply give the sysadmin 101 perspective:

Always pick the right tool for the job.  If XFS isn't working satisfactorily for this job and no fix is forthcoming, I'd test EXT4 and JFS to see if either of them is more suitable for this job.

The other option is to switch to a backup job that doesn't create/delete millions of hard links.

There are likely other possibilities.

-- 
Stan


> -Dave
> 
> Dave Hall
> Binghamton University
> kdhall@binghamton.edu
> 607-760-2328 (Cell)
> 607-777-4641 (Office)
> 
> 
> On 04/12/2013 08:51 PM, Stan Hoeppner wrote:
>> On 4/12/2013 12:25 PM, Dave Hall wrote:
>>   
>>> Stan,
>>>
>>> IDid this post get lost in the shuffle?  Looking at it I think it could
>>> have been a bit unclear.  What I need to do anyways is have a second,
>>> off-site copy of my backup data.  So I'm going to be building a second
>>> array.  In copying, in order to preserve the hard link structure of the
>>> source array I'd have to run a sequence of cp -al / rsync calls that
>>> would mimic what rsnapshot did to get me to where I am right now.  (Note
>>> that I could also potentially use rsync --link-dest.)
>>>
>>> So the question is how would the target xfs file system fare as far as
>>> my inode fragmentation situation is concerned?  I'm hoping that since
>>> the target would be a fresh file system, and since during the 'copy'
>>> phase I'd only be adding inodes, that the inode allocation would be more
>>> compact and orderly than what I have on the source array since.  What do
>>> you think?
>>>      
>> The question isn't what it will look like initially, as your inodes
>> shouldn't be sparsely allocated as with your current aged filesystem.
>>
>> The question is how quickly the problem will arise on the new filesystem
>> as you free inodes.  I don't have the answer to that question.  There's
>> no way to predict this that I know of.
>>
>>    
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
