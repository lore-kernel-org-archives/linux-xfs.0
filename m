Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KIRFix076195 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 13:27:15 -0500
Message-ID: <4E78DAFF.3020204@sgi.com>
Date: Tue, 20 Sep 2011 13:27:11 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfsdump: enable dump header checksums
References: <1316523954-7688-1-git-send-email-wkendall@sgi.com>
	<1316538365.2912.32.camel@doink>
In-Reply-To: <1316538365.2912.32.camel@doink>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

Alex Elder wrote:
> On Tue, 2011-09-20 at 08:05 -0500, Bill Kendall wrote:
>> +static inline u_int32_t
>> +calc_checksum(void *bufp, size_t len)
>> +{
>> +	u_int32_t sum = 0;
>> +	u_int32_t *sump = (u_int32_t *)bufp;
>> +	u_int32_t *endp = (void *)sump + len
> 
> No need to cast a (void *) object to another
> pointer type (and vice-versa).
> 
> And although gcc allows arithmetic on void pointers,
> it is not standard, so (char *) would be a more
> portable choice.

Ha...I couldn't remember and when gcc didn't complain
I went with it. Using (char *) requires the result
to be cast back:

	u_int32_t *endp = (u_int32_t *)((char *)sump + len)

This is a bit cleaner:

	u_int32_t *endp = sump + len / sizeof(u_int32_t);

> 
> The multiple-of-4 assumption would be well stated with
> an assertion.

I didn't want to add the extra cycles to a checksum routine,
but realistically it won't affect the run time of dump or
restore and asserts are likely disabled on released binaries
anyway. I'll add the assert here and remove the ones done
during initialization.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
