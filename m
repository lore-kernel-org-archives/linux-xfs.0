Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 651F77F4E
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 06:50:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 470778F8033
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 04:50:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YSPemxFWWws0mQFI for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 04:50:24 -0700 (PDT)
Date: Fri, 26 Jul 2013 21:50:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: understanding speculative preallocation
Message-ID: <20130726115021.GO13468@dastard>
References: <1374823420041-35002.post@n7.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374823420041-35002.post@n7.nabble.com>
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
To: jbr <jbr@squareup.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 26, 2013 at 12:23:40AM -0700, jbr wrote:
> Hello,
> 
> I'm looking for general documentation/help with the speculative
> preallocation feature in xfs.  So far, I haven't really been able to find
> any definitive, up to date documentation on it.

Read the code - it's documented in the comments. ;)

Or ask questions here, because the code changes and the only up to
date reference is the code and/or the developers that work on it...

> I'm wondering how I can find out definitively which version of xfs I am
> using, and what the preallocation scheme in use is.

Look at the kernel version, then look at the corresponding source
code.

> We are running apache kafka on our servers, and kafka uses sequential io to
> write data log files.  Kafka uses, by default, a maximum log file size of
> 1Gb.  However, most of the log files end up being 2Gb, and thus the disk
> fills up twice as fast as it should.
> 
> We are using xfs on CentOS 2.6.32-358.  Is there a way I can know which
> version of xfs is built into this version of the kernel?

The XFS code is part of the kernel, so look at the kernel source
code that CentOS ships.

> We are using xfs (mounted with no allocsize specified).  I've seen varying
> info suggesting this means it either defaults to an allocsize of 64K (which
> doesn't seem to match my observations), or that it will use dynamic
> preallocation.
> 
> I've also seen hints (but no actual canonical documentation) suggesting that
> the dynamic preallocation works by progressively doubling the current file
> size (which does match my observations).

Well, it started off that way, but it has been refined since to
handle many different cases where this behaviour is sub-optimal.

> What I'm not clear on, is the scheduling for the preallocation. At what
> point does it decide to preallocate the next doubling of space.

Depends on the type of IO being done.

> Is it when
> the current preallocated space is used up,

Usually.

> or does it happen when the
> current space is used up within some threshold.

No.

> What I'd like to do, is
> keep the doubling behavior in tact, but have it capped so it never increases
> the file beyond 1Gb.  Is there a way to do that?

No.

> Can I trick the
> preallocation to not do a final doubling, if I cap my kafka log files at
> say, 900Mb (or some percentage under 1Gb)?

No.

> There are numerous references to an allocation schedule like this:
> 
> freespace       max prealloc size
>   >5%             full extent (8GB)
>   4-5%             2GB (8GB >> 2)
>   3-4%             1GB (8GB >> 3)
>   2-3%           512MB (8GB >> 4)
>   1-2%           256MB (8GB >> 5)
>   <1%            128MB (8GB >> 6)
> 
> I'm just not sure I understand what this is telling me.  It seems to tell me
> what the max prealloc size is, with being reduced if the disk is nearly
> full.

Yes, that's correct. Mainline also does this for quota exhaustion,
too.

> But it doesn't tell me about the progressive doubling in
> preallocation (I assume up to a max of 8Gb).  Is any of this configurable? 

No.

> Can we specify a max prealloc size somewhere?

Use the allocsize mount option. It turns off dynamic behaviour and
fixes the pre-allocation size.

> The other issue seems to be that after the files are closed (from within the
> java jvm), they still don't seem to have their pre-allocated space
> reclaimed.  Are there known issues with closing the files in java not
> properly causing a flush of the preallocated space?

Possibly. There's a heuristic that turns of truncation at close - if
your applicatin keeps doing "open-write-close" it will not truncate
preallocation. Log files typically see this IO pattern from
applications, and hence triggering that "no truncate" heuristic is
exactly what you want to have happen to avoid severe fragmentation
of the log files.

> Any help pointing me to any documentation/user guides which accurately
> describes this would be appreciated!

The mechanism is not documented outside the code as it changes from
kernel release to kernel release and supposed to be transparent to
userspace. It's being refined and optimisaed as issues are reported.
Indeed, I suspect that all your problems would disappear on mainline
due to the background removal of preallocation that is no longer
needed, and Centos doesn't have that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
