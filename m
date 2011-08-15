Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7FDAp8R080334 for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 08:10:51 -0500
Message-ID: <4E491AD8.8010504@sgi.com>
Date: Mon, 15 Aug 2011 08:10:48 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 6/7] xfsdump: convert to the POSIX signal API
References: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
	<1312497011-24840-7-git-send-email-wkendall@sgi.com>
	<1313012883.2865.139.camel@doink> <4E457BEE.7060704@sgi.com>
	<20110812204554.GA30615@infradead.org>
In-Reply-To: <20110812204554.GA30615@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, aelder@sgi.com

On 08/12/2011 03:45 PM, Christoph Hellwig wrote:
> On Fri, Aug 12, 2011 at 02:15:58PM -0500, Bill Kendall wrote:
>>> Is there any requirement that the fields
>>> other than sa_flags and sa_handler should
>>> be zeroed before use?
>>
>> The sa_sigaction field will only be used if sa_flags
>> has SA_SIGINFO set, and the sa_restored field is obsolete
>> and not specified by POSIX. Better to explicitly initialize
>> everything though, so I'll change that.
>
> sigaction actuall is a rare case where this is harmful.  To quote
> the manpage:
>
> 	On some architectures a union is involved:  do not assign to both
> 	sa_handler and sa_sigaction.

Thanks, I do remember reading this now. I'll leave the code as is,
which sets sa_handler instead of sa_sigaction, and does not touch
the obsolete (possibly undefined) sa_restorer. The rest of the
fields are initialized.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
