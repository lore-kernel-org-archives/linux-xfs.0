Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5524B7F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 11:39:05 -0500 (CDT)
Message-ID: <517567B1.60704@sgi.com>
Date: Mon, 22 Apr 2013 11:39:13 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [V2] xfsprogs: xfs_quota allow user or group names beginning
	with digits
References: <20130422133106.892072381@sgi.com>
	<1366647526.3762.32396.camel@chandra-dt.ibm.com>
In-Reply-To: <1366647526.3762.32396.camel@chandra-dt.ibm.com>
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
To: sekharan@us.ibm.com
Cc: xfs@oss.sgi.com

On 04/22/2013 11:18 AM, Chandra Seetharaman wrote:
>
> Is there any specific reason why quota_proj_type() is not changed ?
>
Yes project quota's were being punished. ;)
Good catch Chandra, I will submit a V3.

3 times seems to be the charm on patches. :D

Thanks
--Rich

> On Mon, 2013-04-22 at 08:31 -0500, rjohnston@sgi.com wrote:

>> Index: xfsprogs/quota/quota.c
>> ===================================================================
>> --- xfsprogs.orig/quota/quota.c	2013-03-22 14:22:09.000000000 -0500
>> +++ xfsprogs/quota/quota.c	2013-04-22 07:20:52.000000000 -0500
>> @@ -224,7 +224,7 @@
>>   	uid_t		id;
>>
>>   	if (name) {
>> -		if (isdigit(name[0])) {
>> +		if (isdigits_only(name)) {
>>   			id = atoi(name);
>>   			name = getusername(id, flags & NO_LOOKUP_FLAG);
>>   		} else if ((u = getpwnam(name))) {
>> @@ -273,7 +273,7 @@
>>   	int		i, ngroups, dofree = 0;
>>
>>   	if (name) {
>> -		if (isdigit(name[0])) {
>> +		if (isdigits_only(name)) {
>>   			gid = atoi(name);
>>   			name = getgroupname(gid, flags & NO_LOOKUP_FLAG);
>>   		} else {
>> Index: xfsprogs/quota/quota.h
>> ===================================================================
>> --- xfsprogs.orig/quota/quota.h	2013-03-22 14:22:09.000000000 -0500
>> +++ xfsprogs/quota/quota.h	2013-04-22 08:12:26.000000000 -0500
>> @@ -19,6 +19,7 @@
>>   #include <xfs/xqm.h>
>>   #include <xfs/path.h>
>>   #include <xfs/project.h>
>> +#include <stdbool.h>
>>
>>   /*
>>    * Different forms of XFS quota
>> @@ -80,4 +81,5 @@
>>   extern char *uid_to_name(__uint32_t __uid);
>>   extern char *gid_to_name(__uint32_t __gid);
>>   extern char *prid_to_name(__uint32_t __prid);
>> +extern bool isdigits_only(const char *);
>>
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
