Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59678 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbfAERuj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Jan 2019 12:50:39 -0500
Subject: Re: [PATCH] xfs_quota: fix false error reporting of project
 inheritance flag is not set
References: <20190105102556.GA4200@nevermore.lan>
 <20190105174617.GH12689@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9dc5afc1-b898-6808-e649-753682d79227@sandeen.net>
Date: Sat, 5 Jan 2019 11:50:37 -0600
MIME-Version: 1.0
In-Reply-To: <20190105174617.GH12689@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Achilles Gaikwad <agaikwad@redhat.com>
Cc: linux-xfs@vger.kernel.org, sgardner@redhat.com, sandeen@redhat.com



On 1/5/19 11:46 AM, Darrick J. Wong wrote:
> On Sat, Jan 05, 2019 at 03:56:01PM +0530, Achilles Gaikwad wrote:
>> xfs_quota project check results in "project inheritance flag is not set" error
>> https://bugzilla.redhat.com/show_bug.cgi?id=1663502
>>
>> Reported-by: Steven Gardner <sgardner@redhat.com>
>> Signed-off-by: Achilles Gaikwad <agaikwad@redhat.com>
>> ---
>>  quota/project.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/quota/project.c b/quota/project.c
>> index e4e7a012..8c9be08b 100644
>> --- a/quota/project.c
>> +++ b/quota/project.c
>> @@ -99,6 +99,7 @@ check_project(
>>  {
>>  	struct fsxattr		fsx;
>>  	int			fd;
>> +	int			isdir;
> 
> Use bool for boolean values, or...
> 
>>  
>>  	if (recurse_depth >= 0 && data->level > recurse_depth)
>>  		return -1;
>> @@ -126,7 +127,8 @@ check_project(
>>  			printf(_("%s - project identifier is not set"
>>  				 " (inode=%u, tree=%u)\n"),
>>  				path, fsx.fsx_projid, (unsigned int)prid);
>> -		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT))
>> +		isdir = S_ISDIR(stat->st_mode);
>> +		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && isdir)
> 
> ...move the S_ISDIR test directly into the if condition test?

Yup, since isdir is only used once I thought the same thing, TBH.

-Eric

> 
> Otherwise looks fine to me.
> 
> --D
> 
>>  			printf(_("%s - project inheritance flag is not set\n"),
>>  				path);
>>  	}
>> -- 
>> 2.20.1
>>
> 
