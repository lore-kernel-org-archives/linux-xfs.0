Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9FE6LXY132400 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 09:06:21 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 91706AC002
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 07:07:31 -0700 (PDT)
Message-ID: <4CB86023.3050906@sgi.com>
Date: Fri, 15 Oct 2010 09:07:31 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfsrestore: turn off NODECHK
References: <20101012215322.749700656@sgi.com>	
	<20101012215400.430780299@sgi.com>
	<1287081911.2362.574.camel@doink>
In-Reply-To: <1287081911.2362.574.camel@doink>
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

On 10/14/2010 01:45 PM, Alex Elder wrote:
> On Tue, 2010-10-12 at 16:53 -0500, wkendall@sgi.com wrote:
>> plain text document attachment (no_node_check)
>> The NODECHK macro should only be enabled as needed for
>> development/debugging.  Having it on limits xfsrestore to
>> 268 million directory entries instead of 4 billion.
>
> I was going to suggest you leave it in the Makefile in
> commented-out form, perhaps with an explanation that
> it's available for development.  But since NODECHK is
> only ever referenced inside "restore/node.c", maybe
> such a thing could be done inside that file instead.
>
> I.e., something like:
>
> /*
>   * NODECHK can be enabled for development and debugging
>   * in order to enforce additional checks on handles
>   * when nodes are mapped, unmapped, and freed.  It should
>   * not be used for production code, it cuts into the number
>   * of directory entries xfsrestore can handle.
>   */
> /* #define NODECHK */
>
> I'll leave it up to you whether you think that's worth
> doing (and if so, let me know).  Either way:
>
> Reviewed-by: Alex Elder<aelder@sgi.com>

Sounds like a good idea. I'll add something like this
and repost.

Bill

>
>> Signed-off-by: Bill Kendall<wkendall@sgi.com>
>>
>> Index: xfsdump-kernel.org/restore/Makefile
>> ===================================================================
>> --- xfsdump-kernel.org.orig/restore/Makefile
>> +++ xfsdump-kernel.org/restore/Makefile
>> @@ -103,7 +103,7 @@ LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBA
>>   LTDEPENDENCIES = $(LIBRMT)
>>
>>   LCFLAGS = -DRESTORE -DRMT -DBASED -DDOSOCKS -DINVCONVFIX -DPIPEINVFIX \
>> -	-DEOMFIX -DSESSCPLT -DWHITEPARSE -DNODECHK -DDIRENTHDR_CHECKSUM \
>> +	-DEOMFIX -DSESSCPLT -DWHITEPARSE -DDIRENTHDR_CHECKSUM \
>>   	-DF_FSSETDM
>>
>>   default: depend $(LTCOMMAND)
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
