Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9EF97FB5
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 07:54:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 530EFAC001
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 05:54:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id hk2NKG4Qg7czbkES for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 05:54:06 -0700 (PDT)
Message-ID: <53C5246E.9090202@sandeen.net>
Date: Tue, 15 Jul 2014 07:54:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs/quota: fix NULL pointer dereference in report_f
References: <52849CC5.10109@oracle.com> <53C091E1.1010907@sandeen.net>
	<20140715101437.GB30363@infradead.org>
In-Reply-To: <20140715101437.GB30363@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/15/14, 5:14 AM, Christoph Hellwig wrote:
> On Fri, Jul 11, 2014 at 08:39:45PM -0500, Eric Sandeen wrote:
>>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>> I know hch had grand plans to make this all nicer, but based on Jeff's
>> followup emails, it looks like this is the only spot needed to simply
>> resolve the problems w/ nonexistent paths in quota, and is a small,
>> contained change we can easily make before the next point release.
> 
> Didn't I say I'm fine with putting this in earlier even if I'd prefer
> a grand solution?

Yes, you did, but it never got a formal reviewed-by or got merged, so I bumped it :)


FWIW I did look at the grand solution, and there was .. something that
didn't make sense to me, so I backed off.  Oh, yeah, I wasn't quite
sure what to do with:

add_args_command(init_args_command);
and
init_args_command();

in quota/init.c  

-Eric



> either way, consider this:
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
