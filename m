Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28GNgTt047711 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 10:23:42 -0600
Date: Thu, 8 Mar 2012 10:23:48 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: df bigger than ls?
Message-ID: <20120308162348.GT7762@sgi.com>
References: <20120307155439.GA23360@nsrc.org> <20120307171619.GA23557@nsrc.org>
	<4F57A32A.5010704@sandeen.net> <20120308021054.GM3592@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120308021054.GM3592@dastard>
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
Cc: Brian Candler <B.Candler@pobox.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Mar 08, 2012 at 01:10:54PM +1100, Dave Chinner wrote:
> On Wed, Mar 07, 2012 at 12:04:26PM -0600, Eric Sandeen wrote:
> > But there does seem to be an issue here; if I make a 4G filesystem
> > and repeat the above test 3 times, the 3rd run gets ENOSPC, and
> > the last file written comes up short, while the first one retains
> > all it's extra preallocated space:
> > 
> > # du -hc bigfile* 2.0G	bigfile1 1.1G	bigfile2 907M
> > bigfile3
> > 
> > Dave, is this working as intended?
> 
> Yes. Your problem is that you have a very small filesystem, which is
> not the case that we optimise XFS for. :/

I have seen a similar problem on some very large filesystems too.  This
is not just dependent upon the size of the filesystem, but also the
workload.  I think it is also a big problem for folks using quotas.

> > I know the speculative
> > preallocation amount for new files is supposed to go down as the
> > fs fills, but is there no way to discard prealloc space to avoid
> > ENOSPC on other files?
>
> I see two possible ways to
> minimise this problem:
>
> 	1. reduce the maximum speculative preallocation size based
> 	on filesystem size at mount time.
> 
> 	2. track inodes with active speculative preallocation and
> 	have an enospc based trigger that can find them and truncate
> 	away excess idle speculative preallocation.
>
> 
> The first is relatively easy to do, but will only reduce the
> incidence of your problem - we still need to allow significant
> preallocation sizes (e.g. 64MB) to avoid the fragmentation problems.
> 
> The second is needed to reclaim the space we've already preallocated
> but is not being used. That's more complex to do - probably a radix
> tree bit and a periodic background scan to reduce the time window
> the preallocation sits around from cache lifetime to "idle for some
> time" along with a on-demand, synchronous ENOSPC scan. This will
> need some more thought as to how to do it effectively, but isn't
> impossible to do....

Alex and I discussed this problem briefly awhile ago.  What is the best
way to lose when you hit ENOSPC (project quotas) or EDQUOT in
xfs_iomap_write_delay?  You want to be fair; one user hitting his quota
shouldn't be able to steal some other user's block reservations unless
you really are near ENOSPC for the entire filesystem.  

I suggested something like... track inodes with preallocated block
reservations in LRU order and by dquot, so that the poor fella who is at
EDQUOT will first clean up the preallocations that resulted in quota
being enforced, try again, and then work on preallocations of other
users only if it can help in his situation.  IIRC Alex shut me down when
he heard LRU.  ;)

Now that block reservations count toward quotas the symptom will
probably be a little different.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
