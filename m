Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D609D7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 05:37:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8855304053
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 03:37:20 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id phn3FCPBCmgnHIUf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Mar 2014 03:37:19 -0700 (PDT)
Date: Mon, 10 Mar 2014 03:37:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Multi-CPU harmless lockdep on x86 while copying data
Message-ID: <20140310103716.GA1431@infradead.org>
References: <531BD8B9.1090400@gmail.com>
 <20140310025523.GV6851@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140310025523.GV6851@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 10, 2014 at 01:55:23PM +1100, Dave Chinner wrote:
> Changing the directory code to handle this sort of locking is going
> to require a bit of surgery. However, I can see advantages to moving
> directory data to the same locking strategy as regular file data -
> locking heirarchies are identical, directory ilock hold times are
> much reduced, we don't get lockdep whining about taking page faults
> with the ilock held, etc.
> 
> A quick hack at to demonstrate the high level, initial step of using
> the IOLOCK for readdir serialisation. I've done a little smoke
> testing on it, so it won't die immediately. It should get rid of all
> the nasty lockdep issues, but it doesn't start to address the deeper
> restructing that is needed.

What synchronization do we actually need from the iolock?  Pushing the
ilock down to where it's actually needed is a good idea either way,
though.

> This would be a straight forward change, except for two things:
> filestreams and lockdep. The filestream allocator takes the
> directory iolock and makes assumptions about parent->child locking
> order of the iolock which will now be invalidated. Hence some
> changes to the filestreams code is needed to ensure that it never
> blocks on directory iolocks and deadlocks. instead it needs to fail
> stream associations when such problems occur.

I think the right fix is to stop abusing the iolock in filestreams.
To me it seems like a look inside fstrm_item_t should be fine
for what the filestreams code wants if I understand it correctly.

>From looking over some of the filestreams code just for a few minutes
I get an urge to redo lots of it right now..

> @@ -1228,7 +1244,7 @@ xfs_create(
>  	 * the transaction cancel unlocking dp so don't do it explicitly in the
>  	 * error path.
>  	 */
> -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);

What do we need the iolock on these operations for?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
