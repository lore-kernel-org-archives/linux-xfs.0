Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 79A8F7FA1
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:15:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A96A304053
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 07:15:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0rQyNoRitFPyKLOl for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 07:15:53 -0700 (PDT)
Message-ID: <5346A797.4030508@sandeen.net>
Date: Thu, 10 Apr 2014 09:15:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 15/14] xfs_io: free memory on error path exit from bmap_f()
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
	<5345C751.8040803@sandeen.net> <53469EF0.3030407@sgi.com>
In-Reply-To: <53469EF0.3030407@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 4/10/14, 8:38 AM, Mark Tinguely wrote:
> On 04/09/14 17:18, Eric Sandeen wrote:
>> If realloc() fails, the memory it was trying to realloc remains;
>> free it on the error path.
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
>>
>> diff --git a/io/bmap.c b/io/bmap.c
>> index a78cbb1..8e5d75e 100644
>> --- a/io/bmap.c
>> +++ b/io/bmap.c
>> @@ -227,6 +227,7 @@ bmap_f(
>>                   fprintf(stderr,
>>                       _("%s: cannot realloc %d bytes\n"),
>>                       progname, (int)(map_size*sizeof(*map)));
>> +                free(map);
>>                   exitcode = 1;
>>                   return 0;
>>               }
> 
> 
> Didn't it get into this block by comparing map to NULL?

Uh yes, yes we did.  Sorry, was getting a bit slap-happy by then.
I guess p = realloc(p) will always lose the memory if it fails,
w/o a temporary var.


Sorry about that!
-Eric

 
> --Mark.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
