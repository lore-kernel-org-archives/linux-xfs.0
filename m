Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UJbYt1211374 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 14:37:45 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24B45AC01F
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 12:37:11 -0700 (PDT)
Message-Id: <2466E954-2122-4FEB-B3DA-8F06AA22BAB7@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090330175451.GA1041@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfstests: fix async io error handling in fsx
Date: Mon, 30 Mar 2009 13:53:21 -0500
References: <1238391050-14211-1-git-send-email-felixb@sgi.com>
	<20090330175451.GA1041@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Mar 30, 2009, at 12:54 PM, Christoph Hellwig wrote:

> On Mon, Mar 30, 2009 at 12:30:50AM -0500, Felix Blyakher wrote:
>> --- a/ltp/fsx.c
>> +++ b/ltp/fsx.c
>> @@ -976,19 +976,41 @@ __aio_rw(int rw, int fd, char *buf, unsigned  
>> len, unsigned offset)
>> 		fprintf(stderr, "errcode=%d\n", ret);
>> 		fprintf(stderr, "aio_rw: io_submit failed: %s\n",
>> 				strerror(ret));
>> -		return(-1);
>> +		errno = -ret;
>> +		return -1;
>
> I think we'd be better off having all these places that set errno in  
> one
> place and use goto labels.  That way you can also add a small comment
> about it.

Makes sense, will do.

>
>
>> +		/*
>> +		 * The b0rked libaio defines event.res as signed.
>> +		 * However the kernel strucuture has it unsigned,
>> +		 * and it's used to pass negated error value.
>> +		 * Till the library is fixed use the temp var.
>> +		 */
>
> This comment seems backwards to the patch description and the actual
> code.

Hmm, not really.
If the libaio library would be correct (do you know whom to talk
to and where to send a patch), the code would look like this:

                 if (event.res >= 0)
                         fprintf(stderr, "bad io length: %lu instead  
of %u\n",
                                         event.res, len);
                 else {
                         fprintf(stderr, "errcode=%d\n", -event.res);
                         fprintf(stderr, "aio_rw: async io failed: %s 
\n",
                                         strerror(-event.res));
                         errno = -event.res;
                         return -1;
                 }


and no need for the temp var of right type, as in a patch now.
The comments just explains the need for that "long res" var.
It does not really describe the need to check the error value,
that's just the part of interface, I assume.
Though, I think, it would be clearer if I state the need to
check the error first, and then note why it could not be
done as above.

I'll repost.

Thanks,
Felix


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
