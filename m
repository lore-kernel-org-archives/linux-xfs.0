Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LGXku9081571 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 10:33:46 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfstests: fix format string warnings in locktest.c
Date: Thu, 21 Jan 2010 10:34:12 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69AE@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69AC@cf--amer001e--3.americas.sgi.com>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Alex Elder wrote:
> Christoph Hellwig wrote:
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

By the way, the content of this patch is already incorporated
in Dave's patch "[7/8] xfstests: fix printf warnings in loctest.c".
http://patchwork.xfs.org/patch/517/


>> Index: xfstests-dev/src/locktest.c
>> ===================================================================
>> --- xfstests-dev.orig/src/locktest.c	2010-01-21 11:26:53.000000000 +0000
>> +++ xfstests-dev/src/locktest.c	2010-01-21 11:27:13.000000000 +0000
>> @@ -741,7 +741,7 @@ send_ctl(void)
>>          if (nwrite < 0)
>>              perror("send_ctl: write");
>>          else
>> -            fprintf(stderr, "send_ctl[%d]: write() returns %d, not %lu as expected\n",
>> +            fprintf(stderr, "send_ctl[%d]: write() returns %d, not %zu as expected\n",
>>                      ctl.test, nwrite, sizeof(ctl));          exit(1);
>>          /*NOTREACHED*/
>> @@ -756,7 +756,7 @@ void recv_ctl(void)
>>          if (nread < 0)
>>              perror("recv_ctl: read");
>>          else {
>> -            fprintf(stderr, "recv_ctl[%d]: read() returns %d, not %lu as expected\n",
>> +            fprintf(stderr, "recv_ctl[%d]: read() returns %d, not %zu as expected\n",
>>                      ctl.test, nread, sizeof(ctl));
>>  	    fprintf(stderr, "socket might has been closed by other locktest\n");  	}
>> 
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
