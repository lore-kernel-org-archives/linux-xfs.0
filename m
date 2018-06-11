Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35254 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753786AbeFKUGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 16:06:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5BK5h4I034899
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:06:06 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2jgecxe8py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:06:06 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5BK65oH021503
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:06:05 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5BK656a006293
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:06:05 GMT
Subject: Re: [PATCH v2 27/27] xfsprogs: Clean up old parent pointer
 definitions
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
 <1528607272-11122-28-git-send-email-allison.henderson@oracle.com>
 <20180611182028.GH22045@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a3669716-2daf-9e02-6307-da822ef61bfd@oracle.com>
Date: Mon, 11 Jun 2018 13:06:03 -0700
MIME-Version: 1.0
In-Reply-To: <20180611182028.GH22045@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 06/11/2018 11:20 AM, Darrick J. Wong wrote:
> On Sat, Jun 09, 2018 at 10:07:52PM -0700, Allison Henderson wrote:
>> Existing parent pointer stubs and structs are not used in this
>> implementation.  Remove uneeded definitions.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   include/parent.h   | 10 ----------
>>   libhandle/handle.c | 26 --------------------------
>>   libhandle/jdm.c    | 20 --------------------
>>   3 files changed, 56 deletions(-)
>>
>> diff --git a/include/parent.h b/include/parent.h
>> index 33f8d85..5665d64 100644
>> --- a/include/parent.h
>> +++ b/include/parent.h
>> @@ -18,16 +18,6 @@
>>   #ifndef __PARENT_H__
>>   #define	__PARENT_H__
>>   
>> -typedef struct parent {
>> -	__u64	p_ino;
>> -	__u32	p_gen;
>> -	__u16	p_reclen;
>> -} parent_t;
>> -
>> -typedef struct parent_cursor {
>> -	__u32	opaque[4];      /* an opaque cookie */
>> -} parent_cursor_t;
>> -
>>   struct path_list;
>>   
>>   typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi, struct xfs_parent_ptr *pptr,
>> diff --git a/libhandle/handle.c b/libhandle/handle.c
>> index a70fa32..862b943 100644
>> --- a/libhandle/handle.c
>> +++ b/libhandle/handle.c
>> @@ -20,7 +20,6 @@
>>   #include "platform_defs.h"
>>   #include "xfs.h"
>>   #include "handle.h"
>> -#include "parent.h"
>>   
>>   /* just pick a value we know is more than big enough */
>>   #define	MAXHANSIZ	64
>> @@ -422,31 +421,6 @@ attr_list_by_handle(
>>   }
>>   
>>   int
>> -parents_by_handle(
>> -	void		*hanp,
>> -	size_t		hlen,
>> -	parent_t	*buf,
>> -	size_t		bufsiz,
>> -	unsigned int	*count)
>> -
>> -{
>> -	errno = EOPNOTSUPP;
>> -	return -1;
>> -}
> 
> You probably need to scrape the declarations out of the header files
> because otherwise any program that thinks it wants to use this will
> compile ok but barf on unresolved symbols in the linker phase.
> 
> There's a murkier question here about how do we handle deprecating these
> libhandle APIs that have never been usable on Linux?
> 
> --D
Oh I see... is there a formal procedure for deprecation that we need to 
be following?  In case someone was depending on getting their EOPNOTSUPP rc?

> 
>> -
>> -int
>> -parentpaths_by_handle(
>> -	void		*hanp,
>> -	size_t		hlen,
>> -	parent_t	*buf,
>> -	size_t		bufsiz,
>> -	unsigned int	*count)
>> -{
>> -	errno = EOPNOTSUPP;
>> -	return -1;
>> -}
>> -
>> -int
>>   fssetdm_by_handle(
>>   	void		*hanp,
>>   	size_t		hlen,
>> diff --git a/libhandle/jdm.c b/libhandle/jdm.c
>> index 821061b..0c2440b 100644
>> --- a/libhandle/jdm.c
>> +++ b/libhandle/jdm.c
>> @@ -20,7 +20,6 @@
>>   #include "xfs.h"
>>   #include "handle.h"
>>   #include "jdm.h"
>> -#include "parent.h"
>>   
>>   /* internal fshandle - typecast to a void for external use */
>>   #define FSHANDLE_SZ		8
>> @@ -178,22 +177,3 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
>>   	return rval;
>>   }
>>   
>> -int
>> -jdm_parents( jdm_fshandle_t *fshp,
>> -		xfs_bstat_t *statp,
>> -		parent_t *bufp, size_t bufsz,
>> -		unsigned int *count)
>> -{
>> -	errno = EOPNOTSUPP;
>> -	return -1;
>> -}
>> -
>> -int
>> -jdm_parentpaths( jdm_fshandle_t *fshp,
>> -		xfs_bstat_t *statp,
>> -		parent_t *bufp, size_t bufsz,
>> -		unsigned int *count)
>> -{
>> -	errno = EOPNOTSUPP;
>> -	return -1;
>> -}
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
