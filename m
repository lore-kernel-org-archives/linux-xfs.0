Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAD0HdXR041264 for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 18:17:39 -0600
Message-Id: <200911130017.nAD0Heww013746@mail07.syd.optusnet.com.au>
Content-Disposition: inline
Mime-Version: 1.0
From: Barry Naujok <bnaujok@optusnet.com.au>
Date: Fri, 13 Nov 2009 11:17:40 +1100
Subject: Re: Re: [PATCH 06/14] repair: use a btree instead of a radix tree
	for	theprefetch queue
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Barry Naujok <bnaujok@optusnet.com.au>, Alex Elder <aelder@sgi.com>





> Christoph Hellwig <hch@infradead.org> wrote:
> 
> On Wed, Oct 21, 2009 at 12:12:33PM -0500, Alex Elder wrote:
> > - I accept that this uses less memory for sparsely populated
> >   key space than radix trees; but it would be nice if that
> >   could be characterized a bit more precisely (i.e., what
> >   will the range of values that'll be represented be, just
> >   how sparse is it, and at what point does this really
> >   pay off?).
> > - Related to the previous one--it would be good to have
> >   a little info about why the value 7 was chosen as the
> >   number of keys per node.  Perhaps I just don't know
> >   enough of the history (or content of the upcoming
> >   patches).
> 
> Maybe Barry still remembers some of this.  I've added his current
> personal address to the Cc list.

Radix tree was instantly dismissed as during my early testing, it actually used more memory than the original flat array on a large filesystem!

I experimented with different values for the key, it didn't make a huge difference. A short node involves less memory copying and more node splitting and merging and tree traversals. Bigger nodes, a lot more memory copying when inserting and deleting entries. No clear winner - can tune it for specific workloads though (and what Dave Chinner said is correct too and started as my basis). 

Barry.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
