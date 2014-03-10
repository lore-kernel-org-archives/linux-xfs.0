Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 628687F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 15:51:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5423B8F8037
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 13:51:22 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XdsEcW9rRxegxv3h for <xfs@oss.sgi.com>;
	Mon, 10 Mar 2014 13:51:20 -0700 (PDT)
Date: Tue, 11 Mar 2014 07:51:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Multi-CPU harmless lockdep on x86 while copying data
Message-ID: <20140310205118.GX6851@dastard>
References: <531BD8B9.1090400@gmail.com> <20140310025523.GV6851@dastard>
	<20140310103716.GA1431@infradead.org>
	<20140310111253.GA4801@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140310111253.GA4801@infradead.org>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 10, 2014 at 04:12:53AM -0700, Christoph Hellwig wrote:
> On Mon, Mar 10, 2014 at 03:37:16AM -0700, Christoph Hellwig wrote:
> > I think the right fix is to stop abusing the iolock in filestreams.
> > To me it seems like a look inside fstrm_item_t should be fine
> > for what the filestreams code wants if I understand it correctly.
> 
> Seems like the iolock could be removed fairly easily by using either of
> the two options:
> 
>  a) reference count fstrm_item, and just grab a reference to it for each
>     child as well as the parent and insert it multiple times.  Kill
>     ->pip.
>  b) only allocate and insert fstrm_items for directories.  Find the
>     directory by grabbing an entry off inode->i_dentry and then grabbing
>     the parent.  There always should be a dentry around when we allocate
>     blocks, and if none we can just skip out of the filestreams
>     allocator if there's none.  For the cases that matter there is.
> 
> Both mean that the race it tries to protect against using the iolock is
> remove entirely, and the code becomes more efficient as well.  Option a)
> seems simple to implement, but b) will save a lot more memory and
> operations when using the filestreams allocator.

Yeah, b) seems like the way to simplify it - the filestreams code
really only needs to track the parent/ag relationship rather than
the child/parent relationship if there is a reliable way of
determining the parent from the child.

What do we do with hardlinked files in this case? I'm happy to say
"too bad" for these files mainly because the filestream allocator is
aimed at associating multiple file creations together, so hard links
really don't matter AFAICT...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
