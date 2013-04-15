Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F8EB7F4C
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 15:35:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E4F8F304048
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 13:35:43 -0700 (PDT)
Received: from mail-vc0-f170.google.com (mail-vc0-f170.google.com
	[209.85.220.170]) by cuda.sgi.com with ESMTP id
	jVX24ZzaFVD6dpTi (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 13:35:42 -0700 (PDT)
Received: by mail-vc0-f170.google.com with SMTP id lf10so4325449vcb.1
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 13:35:41 -0700 (PDT)
Message-ID: <516C649A.8010003@binghamton.edu>
Date: Mon, 15 Apr 2013 16:35:38 -0400
From: Dave Hall <kdhall@binghamton.edu>
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
In-Reply-To: <5168AC0B.5010100@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Stan,

I understand that this will be an ongoing problem.  It seems like all I 
could do at this point would be to ' manually defrag' my inodes the hard 
way by doing this 'copy' operation whenever things slow down.  (Either 
that or go get my PHD in file systems and try to come up with a better 
inode management algorithm.)  I will be keeping two copies of this data 
going forward anyways.

Are there any other suggestions you might have at this time - xfs or 
otherwise?

-Dave

Dave Hall
Binghamton University
kdhall@binghamton.edu
607-760-2328 (Cell)
607-777-4641 (Office)


On 04/12/2013 08:51 PM, Stan Hoeppner wrote:
> On 4/12/2013 12:25 PM, Dave Hall wrote:
>    
>> Stan,
>>
>> IDid this post get lost in the shuffle?  Looking at it I think it could
>> have been a bit unclear.  What I need to do anyways is have a second,
>> off-site copy of my backup data.  So I'm going to be building a second
>> array.  In copying, in order to preserve the hard link structure of the
>> source array I'd have to run a sequence of cp -al / rsync calls that
>> would mimic what rsnapshot did to get me to where I am right now.  (Note
>> that I could also potentially use rsync --link-dest.)
>>
>> So the question is how would the target xfs file system fare as far as
>> my inode fragmentation situation is concerned?  I'm hoping that since
>> the target would be a fresh file system, and since during the 'copy'
>> phase I'd only be adding inodes, that the inode allocation would be more
>> compact and orderly than what I have on the source array since.  What do
>> you think?
>>      
> The question isn't what it will look like initially, as your inodes
> shouldn't be sparsely allocated as with your current aged filesystem.
>
> The question is how quickly the problem will arise on the new filesystem
> as you free inodes.  I don't have the answer to that question.  There's
> no way to predict this that I know of.
>
>    

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
