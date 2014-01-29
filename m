Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 828447F8A
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 07:14:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B996AC004
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 05:14:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pt08lxs0biQkWYqU for
	<xfs@oss.sgi.com>; Wed, 29 Jan 2014 05:14:05 -0800 (PST)
Message-ID: <52E8FE81.7040402@redhat.com>
Date: Wed, 29 Jan 2014 08:13:37 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [xfs] c91c46c12: xfstests generic/313 regression
References: <20140110122700.GA12624@localhost>
	<52CFF402.5080409@oracle.com>	<20140110133306.GA22918@infradead.org>	<52CFFD1C.7050005@oracle.com>
	<20140111111045.GA29380@infradead.org>
In-Reply-To: <20140111111045.GA29380@infradead.org>
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
To: xfs@oss.sgi.com
Cc: hch@infradead.org

On 01/11/2014 06:10 AM, Christoph Hellwig wrote:
> On Fri, Jan 10, 2014 at 10:01:00PM +0800, Jeff Liu wrote:
>> I also thought to fix this problem in this way, however I'm not sure
>> if those flags can be set back to iattr->ia_valid internally...
>>
>> Otherwise, this fix looks good to me.
> 
> Nothing in the truncate or open code path (or non-size setattr for that
> matter) looks at ia_valid after calling the filesystem, and they really
> have no business to.
> 
> In the meantime this has passed xfstests, so I'll send it along.  Thanks
> for the first fix, btw!
> 

ping... any plans to repost this with a proper commit log and whatnot?
Thanks.

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
