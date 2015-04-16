Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C88329DFB
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 06:48:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6CC1AC003
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 04:48:10 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8E8i1rbRqNoe8qve for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2015 04:48:04 -0700 (PDT)
Date: Thu, 16 Apr 2015 21:47:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: add DAX file operations support
Message-ID: <20150416114750.GC21261@dastard>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-6-git-send-email-david@fromorbit.com>
	<552F81E6.4050700@plexistor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <552F81E6.4050700@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Thu, Apr 16, 2015 at 12:33:26PM +0300, Boaz Harrosh wrote:
> On 03/24/2015 12:51 PM, Dave Chinner wrote:
> <>
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 94713c2..8017175 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -385,7 +385,11 @@ xfs_file_splice_read(
> >  
> >  	trace_xfs_file_splice_read(ip, count, *ppos, ioflags);
> >  
> > -	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
> > +	/* for dax, we need to avoid the page cache */
> > +	if (IS_DAX(VFS_I(ip)))
> > +		ret = default_file_splice_read(infilp, ppos, pipe, count, flags);
> > +	else
> > +		ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
> 
> Dave hi
> 
> Linus has accepted this patch:
>   [be64f884be] dax: unify ext2/4_{dax,}_file_operations
> 
> Which adds the same exact if(IS_DAX)) to generic_file_splice_read for use
> by ext2/4. (It made things easier for both ext2/4)
> 
> But also this code is just fine of course

I'll leave it like this for the moment - I've missed the 4.1 merge
window for this code so I'll fix it up when 4.1-rc1 is out and I can
merge it pretty much straight away for the 4.2 cycle....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
