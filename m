Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6913C7F4E
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 21:54:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 487B7304051
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 19:54:09 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	p1pI1SgFCkdyY9hY for <xfs@oss.sgi.com>;
	Mon, 16 Dec 2013 19:54:07 -0800 (PST)
Date: Tue, 17 Dec 2013 14:54:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Handling of reviewed patch series
Message-ID: <20131217035404.GD31386@dastard>
References: <20131213053611.GQ10988@dastard> <20131213185618.GJ1935@sgi.com>
	<20131213231401.GZ10988@dastard> <20131216233940.GR1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131216233940.GR1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 16, 2013 at 05:39:40PM -0600, Ben Myers wrote:
> Hi Dave,
> 
> On Sat, Dec 14, 2013 at 10:14:01AM +1100, Dave Chinner wrote:
> > On Fri, Dec 13, 2013 at 12:56:18PM -0600, Ben Myers wrote:
> > > > Anyway, have a think and discuss - I'm going to push the
> > > > branches I mentioned above....
> > > 
> > > I've been tracking message id and patchwork id in git notes along
> > > with commits for awhile.  I'm hoping this will become useful later
> > > for cross referencing the list, patchworks, and test results.  If
> > > you wouldn't mind also doing so I'd appreciate it.  Maybe it could
> > > be done with a post-commit script or something.
> > 
> > There's no notes in the repo of oss.sgi.com, so I'm not sure what
> > you are doing here.
> 
> I'm just trying to track the message id along with patchwork id.  Maybe later I
> can script it up so that test results are cross referenced with the list archives.
> 
> commit c91c46c12768daac8486dff0f74bc52c2ec974cd
> Author: Christoph Hellwig <hch@infradead.org>
> Date:   Mon Nov 18 05:10:52 2013 -0800
> 
>     xfs: add xfs_setattr_time
>     
>     Split out a xfs_setattr_time helper to share code between truncate and
>     regular setattr similar to xfs_setattr_mode.  I might also have another
>     caller growing for this in the near future.
>     
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Reviewed-by: Brian Foster <bfoster@redhat.com>
>     Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> Notes:
>     X-Patchwork-ID: 6941
>     
>     Message-Id: <20131118131052.GB21649@infradead.org>

There are no notes in the oss repository that I can find. AFAIK,
notes stay in the local repo and don't get pushed. Basically, if you
want notes to be pushed/pulled, everyone has to use a non-standard
repository config to tell git to push/pull refs/notes.

Really, if it's necessary information, it should be in the commit
message. I've never used message IDs or patchworks IDs in my life,
so you can guess how necessary I consider that information to be....

> > As it is, patchworks is not something I use or want to use. I
> > capture and track patches with procmail and mutt - I really don't
> > want to have to use patchworks just to find some arbitrary ID number
> > that some 3rd party tool generates and add it to notes attached to a
> > commit.
> 
> I'm a mutt user as well.  I'm not necessarily the biggest fan of patchwork
> either, but it does turn out to be helpful sometimes.  I don't know what your
> workflow is like.  Is there any chance you can get the message id in there?
> 
> messageid=$(formail -X Message-Id: < $patch | awk '{print $2}')
> git notes append -m "Message-Id: $messageid"

Doesn't work for my workflow, because I don't keep individual
patches around - I pushed everything to mbox format files and then
bulk git-am the file. And that still doesn't solve the patchwork id
problem, or the fact non standard repo configs are needed to manage
it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
