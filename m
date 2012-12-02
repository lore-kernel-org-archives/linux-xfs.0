Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB21cY12103155 for <xfs@oss.sgi.com>; Sat, 1 Dec 2012 19:38:34 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id WyTkxxd1ICvVUuIO
	for <xfs@oss.sgi.com>; Sat, 01 Dec 2012 17:40:55 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id B71D56C089
	for <xfs@oss.sgi.com>; Sat,  1 Dec 2012 19:40:54 -0600 (CST)
Message-ID: <50BAB19F.1010808@hardwarefreak.com>
Date: Sat, 01 Dec 2012 19:40:47 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfsdump INTERRUPT issue
References: <CCDF949D.B03CC%jellis@dhnet.us>
	<988A65DE-A0CB-412C-8F78-187AD0270613@dhnet.us>
In-Reply-To: <988A65DE-A0CB-412C-8F78-187AD0270613@dhnet.us>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 12/1/2012 11:39 AM, Jeffrey Ellis wrote:
> Anyone?
> 
> Or do I have enough to ask the question?

We aren't the US Govt, i.e. we're not going to ignore your help request
just because you're missing a few details.  They may not be relevant
anyway.  So ask away with the details you do have.  If anything else is
needed we'll ask you to provide it.

-- 
Stan


> Best,
> J. 
> 
> On Dec 1, 2012, at 11:03 AM, "J. Ellis" <jellis@dhnet.us> wrote:
> 
>> I'm trying to prepare a question regarding an xfsdump INTERRUPT error I'm getting, and I'm trying to follow the guidelines for reporting such issues here:
>>
>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>>
>> But these last two instructions I'm having a problem finding the information on how to generate:
>>
>>
>> xfs_info output on the filesystem in question (I tried xfs_info /dev/sdc, but it keeps saying for each drive that it's not a mounted xfs system IIRC)
>>
>> dmesg output showing all error messages and stack traces
>>
>> Then you need to describe your workload that is causing the problem, and a demonstration of the bad behavior that is occurring. If it is a performance problem, then 30s - 1 minute samples of:
>>     1.    iostat -x -d -m 5
>>     2.    vmstat 5
>>
>>
>> Do I run this simultaneously while xfstools are working? I'm also not sure what's meant by describe your workload. Can someone step me through this?
>>
>> Please excuse my n00bness. 
>>
>> Best,
>> Jeffrey
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
