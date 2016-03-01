Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C780F7CB3
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 07:23:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9897F304039
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 05:23:49 -0800 (PST)
Received: from lists.s-osg.org (lists.s-osg.org [54.187.51.154]) by
	cuda.sgi.com with ESMTP id 0nLOA0D0akSx6Gsz for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 05:23:46 -0800 (PST)
Message-ID: <56D597D5.3040002@osg.samsung.com>
Date: Tue, 01 Mar 2016 13:23:33 +0000
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: remove impossible condition
References: <1456404237-18169-1-git-send-email-luisbg@osg.samsung.com>
	<20160301120814.GA5217@infradead.org>
In-Reply-To: <20160301120814.GA5217@infradead.org>
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
Cc: cmaiolino@redhat.com, darrick.wong@oracle.com, namjae.jeon@samsung.com, bfoster@redhat.com, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, billodo@redhat.com

On 01/03/16 12:08, Christoph Hellwig wrote:
> On Thu, Feb 25, 2016 at 12:43:57PM +0000, Luis de Bethencourt wrote:
>> bp_release is set to 0 just before the breakpoint of the for loop before
>> the conditional check (in line 458). The other breakpoint is a goto that
>> skips the dead code.
> 
> Yes, this looks correct:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> The whole code around this is rather grotty and could use some more
> work, though..
> 

Thanks for the review Christoph!

If you have some specific things in mind that I could fix in the code around
this, I am happy to add it to my ToDo list. Or I can continue reading it and
let you know of anything I see, so you can confirm before I try to fix it.

Regards,
Luis

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
