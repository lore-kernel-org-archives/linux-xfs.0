Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 809EF803D
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 10:31:52 -0600 (CST)
Date: Mon, 4 Mar 2013 10:31:48 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/9] xfs: add support for large btree blocks
Message-ID: <20130304163148.GF22182@sgi.com>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
	<1358774760-21841-3-git-send-email-david@fromorbit.com>
	<20130215212015.GO22182@sgi.com> <20130222013456.GN26694@dastard>
	<20130223022722.GI26081@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130223022722.GI26081@dastard>
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
Cc: xfs@oss.sgi.com

Hi Dave,

On Sat, Feb 23, 2013 at 01:27:22PM +1100, Dave Chinner wrote:
> On Fri, Feb 22, 2013 at 12:34:56PM +1100, Dave Chinner wrote:
> > On Fri, Feb 15, 2013 at 03:20:15PM -0600, Ben Myers wrote:
> > > On Tue, Jan 22, 2013 at 12:25:53AM +1100, Dave Chinner wrote:
> > > > From: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Add support for larger btree blocks that contains a CRC32C checksum,
> > > > a filesystem uuid and block number for detecting filesystem
> > > > consistency and out of place writes.
> > > > 
> > > > [dchinner@redhat.com] Also include an owner field to allow reverse
> > > > mappings to be implemented for improved repairability and a LSN
> > > > field to so that log recovery can easily determine the last
> > > > modification that made it to disk for each buffer.
> > > > 
> > > > [dchinner@redhat.com] Add buffer log format flags to indicate the
> > > > type of buffer to recovery so that we don't have to do blind magic
> > > > number tests to determine what the buffer is.
> > > > 
> > > > [dchinner@redhat.com] Modified to fit into the verifier structure.
> > > 
> > > This patch is far too large for a good review.  It needs to be split up into
> > > it's various ideas which you outlined in patch 0.  If you need to add dead code
> > > in each piece and then enable it at the end, that's fine with me.
> > 
> > You want it broken up into 7 or 8 separate patches - what does it
> > gain us? It'll take a week for me to do the patch monkeying and to
> > retest and validate the resulting stack (i.e. it is bisectable, each
> > patch passes xfstests, etc), and in the end the code will be
> > identical.
> > 
> > As I've said before, there's a point where the tradeoff for
> > splitting patches up doesn't make sense. Asking a developer to do
> > days of work to end up with exactly the same code to save the
> > reviewer an hour or two is *not* a good tradeoff. Especially for the
> > first patch of a much larger 15-20 patch series which contains
> > several larger and more complex patches....
> 
> Ben, reading this back it comes across as unnecessarily negative and
> narky. I was just about at the end of the attribute leaf changes and
> it's been a mind-numbing slog making mechanical changes to lots of
> code.
> 
> This is after having to do the same slog through all the directory
> code. The block, leaf, node, freespace and da_btree code all had to
> get the same treatment, and it's worn me down.  My wrists are
> starting to hurt from the last three months of slogging through this
> stuff (roughly +20,000/-10,000 lines modified according to a quick
> diffstat) and that doesn't make me a happy camper.
> 
> So I'm not meaning to be narky or nasty - I just want to get this
> stuff done ASAP before it burns me out. Hence the prospect of having
> to go back and redo significant chunks to split out trivial pieces
> of code (i.e. a mind-numbing slog making mechanical changes) hit a
> bit of a raw nerve.
> 
> All I'm asking is that you take into account the extra load that the
> rework you ask me to do adds and whether it is absolutely necessary
> to be able to review the code. The last thing I want is be burnt out
> by this stuff....

Once I get back to it I'll consider whether to pull it apart myself.  I had a
hard time keeping track of everything that was going on in that patch.  And it
seems like whenever that happens I miss something important in my review.
Working through the rest of the series may also help to get more comfortable
with this patch.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
