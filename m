Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6FEJ7kE207356 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 09:19:07 -0500
Subject: Re: [PATCH] stable: restart busy extent search after node removal
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4E1CF47D.7080909@sandeen.net>
References: <4E1CC4BA.1010107@redhat.com> <20110713001234.GN23038@dastard>
	<4E1CE35B.4010404@redhat.com> <20110713002022.GO23038@dastard>
	<4E1CF47D.7080909@sandeen.net>
Date: Fri, 15 Jul 2011 09:19:02 -0500
Message-ID: <1310739542.2921.8.camel@doink>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, 2011-07-12 at 20:27 -0500, Eric Sandeen wrote:
> On 7/12/11 7:20 PM, Dave Chinner wrote:
> > On Tue, Jul 12, 2011 at 07:14:19PM -0500, Eric Sandeen wrote:
> >> On 7/12/11 7:12 PM, Dave Chinner wrote:
> >>> On Tue, Jul 12, 2011 at 05:03:38PM -0500, Eric Sandeen wrote:
> >>>> Sending this for review prior to stable submission...
> >>>>
> >>>> A user on #xfs reported that a log replay was oopsing in
> >>>> __rb_rotate_left() with a null pointer deref.
> >>>>
> >>>> I traced this down to the fact that in xfs_alloc_busy_insert(),
> >>>> we erased a node with rb_erase() when the new node overlapped,
> >>>> but left it specified as the parent node for the new insertion.
> >>>>
> >>>> So when we try to insert a new node with an erased node as
> >>>> its parent, obviously things go very wrong.
> >>>>
> >>>> Upstream,
> >>>> 97d3ac75e5e0ebf7ca38ae74cebd201c09b97ab2 xfs: exact busy extent tracking
> >>>> actually fixed this, but as part of a much larger change.  Here's
> >>>> the relevant bit:
> >>>>
> >>>>                 * We also need to restart the busy extent search from the
> >>>>                 * tree root, because erasing the node can rearrange the
> >>>>                 * tree topology.
> >>>>                 */
> >>>>                rb_erase(&busyp->rb_node, &pag->pagb_tree);
> >>>>                busyp->length = 0;
> >>>>                return false;
> >>>>
> >>>> We can do essentially the same thing to older codebases by restarting
> >>>> the search after the erase.
> >>>>
> >>>> This should apply to .35 through .39, and was tested on .39
> >>>> with the oopsing replay reproducer.
> >>>>
> >>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >>>> ---
> >>>>
> >>>> Index: linux-2.6/fs/xfs/xfs_alloc.c
> >>>> ===================================================================
> >>>> --- linux-2.6.orig/fs/xfs/xfs_alloc.c
> >>>> +++ linux-2.6/fs/xfs/xfs_alloc.c
> >>>> @@ -2664,6 +2664,12 @@ restart:
> >>>>  					new->bno + new->length) -
> >>>>  				min(busyp->bno, new->bno);
> >>>>  		new->bno = min(busyp->bno, new->bno);
> >>>> +		/*
> >>>> +		 * Start the search over from the tree root, because
> >>>> +		 * erasing the node can rearrange the tree topology.
> >>>> +		 */
> >>>> +		spin_unlock(&pag->pagb_lock);
> >>>> +		goto restart;
> >>>>  	} else
> >>>>  		busyp = NULL;
> >>>
> >>> Looks good.
> >>>
> >>> I'm guessing that the only case I was able to hit during testing of
> >>> this code originally was the "overlap with exact start block match",
> >>> otherwise I would have seen this. I'm not sure that there really is
> >>> much we can do to improve the test coverage of this code, though.
> >>> Hell, just measuring our test coverage so we know what we aren't
> >>> testing would probably be a good start. :/
> >>
> >> Apparently the original oops, and the subsequent replay oopses,
> >> were on a filesystem VERY busy with torrents.
> >>
> >> Might be a testcase ;)

So, would you mind trying to create this as a test?
Can you come up with a reliable way to create a
small but *very* fragmented filesystem to do stuff
with?

Maybe a function to do that would be useful (sort
of like the one Allison Henderson did for creating
full filesystem) for doing various tests, including
log replay, xfs_repair, and various operations while
"loaded" in that way.

					-Alex


> > 
> > That just means large files. And fragmentation levels are
> > effectively dependent on whether the torrent client uses
> > preallocation or not. Just creating a set of large fragmented file
> > using preallocation, shutting the filesystem down in the middle
> > of it and then doing log replay might do the trick...
> 
> well yeah, my point was, it was in fact badly fragmented.
> 
> To quote my favorite meaningless xfs_db statistic,
> 
> actual 29700140, ideal 185230, fragmentation factor 99.38%
> 
> I guess that's "only" 160 extents per file.
> 
> But one of the 2.2G files had 44,000 extents, as an example.
> I am guessing the client did not preallocate.  :)
> 
> -Eric
> 
> > Cheers,
> > 
> > Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
