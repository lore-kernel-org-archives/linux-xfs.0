Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p72E7QID105088 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 09:07:27 -0500
Message-ID: <4E38049A.3080405@sgi.com>
Date: Tue, 02 Aug 2011 09:07:22 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfsdump: remove conditional OPENMASKED code
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<1311972011-1446-2-git-send-email-wkendall@sgi.com>
	<20110802101325.GA16239@infradead.org>
In-Reply-To: <20110802101325.GA16239@infradead.org>
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
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Jul 29, 2011 at 03:40:08PM -0500, Bill Kendall wrote:
>> xfsdump contains a couple wrapper functions which block signals
>> during an open(2) call. This code is conditionally compiled and has
>> not been enabled for a long time. Remove the wrappers rather than
>> converting them to use the POSIX signal API.
>>
>> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Any idea what this code was used for?  Driver-specific open quirks on
> IRIX?

Not sure, but probably something along those lines. The original
revision in the IRIX tree has the OPENMASKED code, but it too
is not enabled.

Thanks for the review.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
