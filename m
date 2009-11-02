Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2JFH2x085088 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 13:15:17 -0600
Message-ID: <4AEF2FCD.4090707@redhat.com>
Date: Mon, 02 Nov 2009 13:15:25 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfststests 220: test for prealloc/delalloc/reserved
	spacerecapture
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE58@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE58@cf--amer001e--3.americas.sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Alex Elder wrote:
> Eric Sandeen wrote:
>> Test writing and removing a file in a loop; filesize is 64m,
>> filesystem size is 256m.  Loop 16 times each for buffered and
>> direct.
>>
>> ext4 hits enospc after a couple loops.
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
> 
> 
> Dumb nit mentioned below, but otherwise looks good.
> Also note that you'll need to use a different test
> number now--like 221.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> 

...


>> +# real QA test starts here
>> +_supported_fs generic
>> +_supported_os Linux IRIX
>> +_require_scratch
>> +
>> +# real QA test starts here
> 
> So which is it, here or above that the "real QA test starts"?

It depends on how you measure the starting point, and in fact by 
measuring, you may affect the outcome of that measurement ... it could 
be both at the same time!

-Eric Heisenberg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
