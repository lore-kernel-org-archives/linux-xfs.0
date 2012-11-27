Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qARNfwhh109282 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 17:41:58 -0600
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id qEfuWHaB4fxG5uz1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 15:44:14 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 470043EE0AE
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 08:44:12 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 2C4A145DEBB
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 08:44:12 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0E46145DEB6
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 08:44:12 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id EB6A41DB8041
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 08:44:11 +0900 (JST)
Received: from G01JPEXCHKW23.g01.fujitsu.local
	(G01JPEXCHKW23.g01.fujitsu.local [10.0.193.106])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id A265F1DB803C
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 08:44:11 +0900 (JST)
Message-ID: <50B54FB3.60604@jp.fujitsu.com>
Date: Wed, 28 Nov 2012 08:41:39 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [RFC] [PATCH] xfs_quota: support relative path as `path' arguments
References: <50B49074.1020000@jp.fujitsu.com>
	<20121127165001.GA11620@andromeda.usersys.redhat.com>
In-Reply-To: <20121127165001.GA11620@andromeda.usersys.redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>, xfs ML <xfs@oss.sgi.com>

Hi Carlos,

(2012/11/28 1:50), Carlos Maiolino wrote:
> On Tue, Nov 27, 2012 at 07:05:40PM +0900, Satoru Takeuchi wrote:
> 
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> Current xfs_quota only accepts absolute path as its `path' arguments.
>> This patch adds the support of relative path for user's convenience.
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
> 
> Using realpath() to handle the path being passed by user, not only makes able
> the usage of relative paths, but also fixes the problem in having a "/" at the
> end of the path. For those who abuses of TABs, this is very annoying.

Ah, I also tend to fix the trailing "/" at the end of the path as you said.
But I forgot to mentioned about it by the patch description :-)

Thanks,
Satoru

> 
> Looks good,
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com> 
> Tested-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
>> ---
>>  libxcmd/paths.c |   42 +++++++++++++++++++++++++++++-------------
>>  1 file changed, 29 insertions(+), 13 deletions(-)
>>
>> diff --git a/libxcmd/paths.c b/libxcmd/paths.c
>> index 2a92299..bd84cde 100644
>> --- a/libxcmd/paths.c
>> +++ b/libxcmd/paths.c
>> @@ -27,6 +27,7 @@
>>  #include <xfs/path.h>
>>  #include <xfs/input.h>
>>  #include <xfs/project.h>
>> +#include <limits.h>
>>  
>>  extern char *progname;
>>  
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
