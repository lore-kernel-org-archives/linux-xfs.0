Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A3527F84
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 08:33:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5C55AC003
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 06:33:41 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3vylvCSyfoWfEeRn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 06:33:40 -0800 (PST)
Message-ID: <52EBB431.50301@oracle.com>
Date: Fri, 31 Jan 2014 22:33:21 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Extended attributes limit in Linux
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>	<52EB64DC.4020603@oracle.com>
	<1391165083.4275.7.camel@ubuntu>	<52EB960D.607@oracle.com>
	<1391172723.4275.11.camel@ubuntu>	<52EBA783.1080801@oracle.com>
	<1391178074.4275.19.camel@ubuntu>
In-Reply-To: <1391178074.4275.19.camel@ubuntu>
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
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Sun_Blood <sblood@gmail.com>, xfs@oss.sgi.com


On 01/31 2014 22:21 PM, Vyacheslav Dubeyko wrote:
> On Fri, 2014-01-31 at 21:39 +0800, Jeff Liu wrote:
> 
>>>
>>> I checked the same under Mac OS X 10.6.8 (Snow Leopard). And I have
>>> failed on 3803 bytes size of xattr. So, I suppose that you have Mac OS X
>>> Lion. And EAs is larger under Lion yet.
>>>
>>> What version of Mac OS X have you?
>>>
>> Yup, Mountain Lion v10.8.4 :)
>>
> 
> I suspect that xattrs with significant size is stored in compressed
> state on HFS+. I implemented support of compressed xattrs partially but
> I don't share this code yet. But, yes, EAs with size greater than 64 KB
> can be a problem.
> 
>> FYI, there have a couple of things regarding HFSPlus+xattr+acl on Linux might be
>> deserved to discuss together.
>>
>> We once have a discussion about the errno in case of hit the limits of ACLs, which
>> could be referred to:
>> http://www.spinics.net/lists/linux-fsdevel/msg71125.html
>>
>> HFSPlus return ENOMEM in this case, but it should be E2BIG as per Dave's comments.
>> I worked out a patch series includes HFSPlus, but not yet posted for some reasons.
>>
>> Also, it seems to me we'd better consolidate the errno for EA as well, that is to
>> say, it's better to fix the return error to be consistent with VFS interface in case
>> of the given EA name/value length is larger than the specified limits.
>>
>> Would you like to take a look at the following two patches?
>>
> 
> Yes, sure. Patches looks correct and good for me. But did you take into
> account recent significant changes of Christoph Hellwig? If so, then all
> looks good.

Thanks for the review.  That's one major reason I postpone the patch set submission
as I did it before Christoph's changes got merged, it looks like no obvious conflicts
with that, but I will find time to double check and sent it to you -- still on vacation
for Chinese Spring Festival.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
