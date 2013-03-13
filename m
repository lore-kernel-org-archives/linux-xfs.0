Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ADF917F37
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 23:09:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8589C30406A
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 21:09:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vq5vXrtB7OgzeWXL for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 21:09:50 -0700 (PDT)
Message-ID: <513FFC0D.3030705@sandeen.net>
Date: Tue, 12 Mar 2013 23:09:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: properly set Parent's PID
References: <1359663197-30473-1-git-send-email-cmaiolino@redhat.com>
	<513F58FE.1010200@sgi.com>
In-Reply-To: <513F58FE.1010200@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On 3/12/13 11:34 AM, Rich Johnston wrote:
> On 01/31/2013 02:13 PM, Carlos Maiolino wrote:
>> Set parentpid variable to the correct Parent's ID using getppid() instead of
>> getpid()
>>
>> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
>> ---
>>   common/main.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/common/main.c b/common/main.c
>> index 980d2d4..848a887 100644
>> --- a/common/main.c
>> +++ b/common/main.c
>> @@ -198,7 +198,7 @@ main( int argc, char *argv[] )
>>       /* Get the parent's pid. will be used in signal handling
>>        * to differentiate parent from children.
>>        */
>> -    parentpid = getpid( );
>> +    parentpid = getppid( );
>>       rval = atexit(mlog_exit_flush);
>>       assert(rval == 0);
>>
>>
> Sorry for the late review, this does not apply to current xfsdump tree.

Hm, and hasn't since 2011.  ;)

2da84e5d changed this:

         * to differentiate parent from children.
         */
-       parentpid = getpid( );
+       parenttid = pthread_self( );

Carlos, was this maybe against an older tree or released version?

-Eric

> Regards
> --Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
