Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RFSZlT209624 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 10:28:35 -0500
Subject: Re: [PATCH] adding example with xfs_info output decryption
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <431429966.20110727131343@gmail.com>
References: <BANLkTikjPhKNBVUamccXbAropDw=oBSRgg@mail.gmail.com>
	<20110722155200.GA31867@infradead.org> <1311706943.2890.42.camel@doink>
	<431429966.20110727131343@gmail.com>
Date: Wed, 27 Jul 2011 10:28:31 -0500
Message-ID: <1311780511.1999.67.camel@doink>
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
To: Roman Ovchinnikov <coolthecold@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, 2011-07-27 at 13:13 +0400, Roman Ovchinnikov wrote:
> 
> On Tue, Jul 26, 2011 at 11:02 PM, Alex Elder <aelder@sgi.com> wrote:
> > On Fri, 2011-07-22 at 11:52 -0400, Christoph Hellwig wrote:
> >> On Mon, May 23, 2011 at 02:34:54AM +0400, CoolCold wrote:
> >> > Basing on irc discussions and questions about reading xfs_info output
> >> > I've added example in xfs_growfs manpage.
> >>
> >> Alex, Dave, Eric, do you guys have any comments on this?  Language
> >> nitpicks from the native speakers?  Otherwise I'd be inclined to put it
> >> in.

I have some stuff at the very end of this message I'd like some
feedback on--so dear reader please take a look at that before
you delete this message.

> >> > Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
> >
> > I had to dust off my troff command knowledge to review this.
> > It has been many years...
> I was testing how manpage will look with "man man/man8/xfs_growfs.8",
> works for me.

Yes it works fine.  I was just trying to understand what
the "Vb" (verbatim) macro was doing.  Today I found a
"groff_man(7)" manual page, which documents the ".EX"
and ".EE" macros which do what the ".Vb" macro defined
here does, plus drops hyphenation and does a better
job of temporarily substituting the font.

I looked for something like that yesterday but didn't
find it until today.  I guess I would prefer to use
the .EE/.EX macros if they work.  But I'll leave it
up to you to decide.

> > Christoph prompted to review this from a native speaker's
> > point of view though, so I do that here.  I do end up
> > with a question for others to try to resolve.
> >
> > I think what you are doing (adding the example) is a good idea
> > to help clarify things in any case.
> Thanks!
> >
> >> > ---
> >> >  man/man8/xfs_growfs.8 |   34 ++++++++++++++++++++++++++++++++++
> >> >  1 files changed, 34 insertions(+), 0 deletions(-)
> >> >
> >> > diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
> >> > index 02793ae..c782fc1 100644
> >> > --- a/man/man8/xfs_growfs.8
> >> > +++ b/man/man8/xfs_growfs.8
> >> > @@ -1,3 +1,14 @@
> >> > +.\" Verbatim blocks taken from openssl req manpage content
> >> > +.de Vb \" Begin verbatim text
> >> > +.ft CW
> >> > +.nf
> >> > +.ne \\$1
> >> > +..
> >> > +.de Ve \" End verbatim text
> >> > +.ft R
> >> > +.fi
> >> > +..
> >> > +
> >> >  .TH xfs_growfs 8
> >> >  .SH NAME
> >> >  xfs_growfs, xfs_info \- expand an XFS filesystem
> >> > @@ -105,6 +116,7 @@ this is specified with
> >> >  Specifies that no change to the filesystem is to be made.
> >> >  The filesystem geometry is printed, and argument checking is performed,
> >> >  but no growth occurs.
> >> > +.B See output examples below.
> >> >  .TP
> >> >  .BI "\-r | \-R " size
> >> >  Specifies that the real-time section of the filesystem should be grown. If the
> >> > @@ -152,6 +164,28 @@ reside. In order to grow a filesystem, it is
> >> > necessary to provide added
> >> >  space for it to occupy. Therefore there must be at least one spare new
> >> >  disk partition available. Adding the space is often done through the use
> >> >  of a logical volume manager.
> >> > +.SH "EXAMPLES"
> >> > +
> >> > +Examining xfs_info output.
> >
> > How about, "Understanding xfs_info output"
> >
> >> > +.PP
> >> > +Let's assume one have the next xfs_info output:
> >> > +.PP
> >> > +.Vb 1
> >
> > Maybe you could add something indicating how the command was issued.
> > I.e.:
> >
> >    \&# xfs_info /dev/sda
> Okay.
> 
> >
> >> > +\& meta-data=/dev/sda      isize=256    agcount=32, agsize=16777184 blks
> >> > +\&          =              sectsz=512   attr=2
> >> > +\& data     =              bsize=4096   blocks=536869888, imaxpct=5
> >> > +\&          =              sunit=32     swidth=128 blks
> >> > +\& naming   =version 2     bsize=4096
> >> > +\& log      =internal      bsize=4096   blocks=32768, version=2
> >> > +\&          =              sectsz=512   sunit=32 blks, lazy-count=1
> >> > +\& realtime =none          extsz=524288 blocks=0, rtextents=0
> >
> > I think you should drop the space character after each '&' above.
> > The way you have it puts a slight indent in the output.
> Personally I like indentation here, to make the text look like "quote",
> and may be I'd add one more space

OK.  I wasn't sure multiple spaces would reliably show up,
but since the formatting will be disabled it might.  I
think the indent is fine, but maybe you should use ".RS"
and ".RE" to control the position of the left margin.

> >
> >> > +.Ve
> >> > +.PP
> >> > +
> >> > +Here, data section block size (bsize) is 4096 bytes. Therefore
> >> > +"sunit=32 swidth=128 blks" means stripe unit is 32*4096 bytes = 128 kibibytes
> >> > +and stripe width is 128*4096 bytes = 512 kibibytes. Filesystem is striped
> >> > +over 4 ( 128 / 32 ) stripes.
> >
> > I'll just write what I think it should be rather than trying
> > to show lots of little changes:
> >
> >  Here, the data section of the output indicates "bsize=4096",
> >  meaning the data block size for this filesystem is 4096 bytes.
> >  This section also shows "sunit=32 swidth=128 blks", which means
> >  the stripe unit is 32*4096 bytes = 128 kibibytes and the stripe
> >  width is 128*4096 bytes = 512 kibibytes.
> >
> > The last sentence I'm not sure I agree with.  I think you're
> > trying to explain the relationship between a stripe width
> > and stripe unit, and the components that make up a stripe.
> > Your use of the term "stripe" doesn't match what I take
> > to be its meaning.  I'm not saying my meaning is right, but
> > I'd like to make sure we have agreement on these terms.
> Generally I was trying to fact out units of measurement - as,say,
> mkfs.xfs manpage describes option parameters as 512 bytes blocks/just
> bytes to be specified when calling mkfs.xfs, and when someone gets
> xfs_info output for that mount point it really differs from parameters
> he passed to mkfs.xfs (at least at first sight).

I think this is good.  My only concern was that we use
terminology consistently, so it doesn't just shift to
a different source of confusion.

> > Given that, I would re-state your last sentence (using my
> > terminology as):
> >
> >  A single stripe of this filesystem therefore consists
> >  of four stripe units (128 blocks / 32 blocks per unit).
> >
> > I.e., my meaning says that  a "stripe" is "stripe width"
> > blocks wide, made up of four "stripe units", each of which
> > is 32 blocks, where a block is 4096 bytes.
> >
> > I think you are using the term "stripe" to represent what
> > I'm calling the "stripe unit".
> >
> > Perhaps someone else can help ensure we're using
> > terms with meaning consistent with how XFS has used
> > them historically.
> I've checked manpage for mkfs.xfs and it operates with terms
> "stripe unit" & "stripe width" in your understanding, so I
> think this is historically proper way to think about stripes.

OK, thanks for checking.

> >
> >                                        -Alex
> >
> >
> >> >  .SH SEE ALSO
> >> >  .BR mkfs.xfs (8),
> >> >  .BR md (4),
> >
> >
> 
> So, I've updated patch (now it mostly contains your text), but left
> indentation. Patch is attached and url for it is
> http://web.coolcold.org/data/0001-adding-example-with-xfs_info-decryption-v2.patch
> 
> I'm new to all this public patch-through-email process,
> should I start new mail thread with new patch text inside
> message?

Below is the typical process.  It's quite a bit more
than what you're asking for, but I've been asked it
more than once so I thought I'd write something up
once and for all so I can refer to it later.

A quick look shows this is not really documented on
the xfs.org Wiki, so if others don't point me at
another place that has this I can put a copy of the
following there.  Please review and comment.

Initial:
- Developer makes a change against a particular version
  of the XFS master branch (typically it's the latest
  published version).
- Developer tests the change:
    - Builds clean--no errors or warnings appear
      as a result of the change
    - Test system boots and/or XFS kernel module
      loads without any error or warning using
      this newly-built code
    - New code is run through "xfstests", and the
      result shows no new or unexplainable test
      failures
- Developer proposes the change by submitting it
  to the XFS mailing list for discussion and review.
  Note that the file "Documentation/SubmittingPatches"
  in the Linux kernel source tree covers much of this,
  and in particular the Developer's Certificate of
  Origin (DCO).  A copy of that file can also be found
  here:    http://lwn.net/Articles/139918/
    - A patch(1) file is created, encoding the change
      using unified diff format.  It is also preferable
      to have the diff include the C function name with
      each hunk if possible, and depending on how the
      patch is generated you may be able to sort the
      order of the files in the patch and use a canonical
      "a/..." versus "b/..." naming scheme for the files.
      The "git format-patch" and "quilt refresh" commands
      are good tools for formatting patches for review.
    - The patch file is sent to the XFS mailing list
      for review:
        - To: xfs@oss.sgi.com
        - Subject: [PATCH] xfs: <very short summary>
        - Above the patch there should be a concise
          but complete explanation for the change
          (unless it is trivial enough that the
          subject line alone does it well enough).
        - There must be a signoff line:
            Signed-off-by: I. Develop Code <idc@n00b.com>
        - Then comes the patch text
- People on the XFS mailing list will review the
  proposed change.
    - This is often done within a (non-weekend) day
      or two, but occasionally may take a week or more.
    - If a few weeks go by without any attention,
      re-post the patch to the mailing list, indicating
      that you are posting it again.  This can just be
      a polite "may I get a review" request in response
      to your original posting.
    - Reviewers will comment on the patch, possibly
      requesting changes.  All reviews and follow-up
      discussion is normally copied to the entire
      mailing list to ensure it is public and gets
      preserved.
    - If a reviewer accepts the patch, a signoff is
      supplied, for example:
        Reviewed-by: Alex Elder <aelder@sgi.com>
      Other lesser degrees of signoff are sometimes seen,
      such as "Signed-off-by" or "Acked-by".  These are
      all connected to the DCO process documented as
      stated above.
    - If the review comes back positive, the XFS maintainer
      will pull the changes in, and in time it will get
      published in an update to the XFS master branch.
- Developer may be requested to make changes during review
    - In this case, the process above pretty much repeats,
      using the previous code as a basis of the change.
    - When posting the updated patch for review, a few
      things are different:
        - Subject: [PATCH, v2] xfs: <same very short summary>
          (and similarly "v3", etc. for subsequent updates.)
        - If someone has already indicated they approve
          the patch (for example it's one of a series
          in which other patches are getting updated),
          include that person's signoff line in the
          updated patch.
        - Add a very short description of what changed
          since the last time it was posted to the end
          of the description.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
