Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TMCxIR071183 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 17:12:59 -0500
Subject: Re: Updated xfsprogs 2.6.38 merge
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110705024855.GA561@dastard>
References: <20110705024855.GA561@dastard>
Date: Fri, 29 Jul 2011 17:12:44 -0500
Message-ID: <1311977564.2790.67.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-07-05 at 12:48 +1000, Dave Chinner wrote:
> Folks,
> 
> I pushed out an updated 2.6.38 kernel merge to xfsprogs patchset a
> couple of days ago. I've been doing quite a bit of testing on it,
> both 32 bit and 64 bit, with 512 byte, 1k and 4k block size
> filesystems and I haven't come across any regressions. The patchset
> can be found here:
> 
>   git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev kernel-2.6.38-sync
> 
> It's pretty much unchanged from the last set of patches I sent,
> except for one minor fix to the radix tree code for an off by one in
> the path array size for item and tag deletes.
> 
> I'm pretty much ready to commit this update so I can then move
> forward with updating it to the 3.0 kernel code base as a smaller
> incremental series.
> 
> Cheers,
> 
> Dave.

I looked over the changes--the third one really since
the first two already indicated I'd signed off on them.

It is a very large patch, and most of the changes are
pretty easily seen to be straightforward transformations.
So my "review" consisted of a full-but-quick scan through
it.

More importantly, you report no regressions and I can
confirm that I haven't seen any myself either so far,
except that the golden output for test 122 needs to be
updated:
  - to reflect that xfs_bmbt_rec_{32,64}_t have now
    been replaced by xfs_bmbt_rec_t
  - to reflect that xfs_dinode_core_t no longer exists
  - and that xfs_alloctype_t isn't shown any more,
    because it's no longer an enum type.
It looks to me like that test could be updated so it
looks for structure definitions rather than typedef's,
and possibly review the list of ignored types.

Anyway, I really want to see this committed so we can move
forward without further ado.  So I say get it in...

Signed-off-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
