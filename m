Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QJ2T5Q138612 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 14:02:29 -0500
Subject: Re: [PATCH] adding example with xfs_info output decryption
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110722155200.GA31867@infradead.org>
References: <BANLkTikjPhKNBVUamccXbAropDw=oBSRgg@mail.gmail.com>
	<20110722155200.GA31867@infradead.org>
Date: Tue, 26 Jul 2011 14:02:23 -0500
Message-ID: <1311706943.2890.42.camel@doink>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: CoolCold <coolthecold@gmail.com>, xfs@oss.sgi.com

On Fri, 2011-07-22 at 11:52 -0400, Christoph Hellwig wrote:
> On Mon, May 23, 2011 at 02:34:54AM +0400, CoolCold wrote:
> > Basing on irc discussions and questions about reading xfs_info output
> > I've added example in xfs_growfs manpage.
> 
> Alex, Dave, Eric, do you guys have any comments on this?  Language
> nitpicks from the native speakers?  Otherwise I'd be inclined to put it
> in.
> 
> > Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>

I had to dust off my troff command knowledge to review this.
It has been many years...

Christoph prompted to review this from a native speaker's
point of view though, so I do that here.  I do end up
with a question for others to try to resolve.

I think what you are doing (adding the example) is a good idea
to help clarify things in any case.

> > ---
> >  man/man8/xfs_growfs.8 |   34 ++++++++++++++++++++++++++++++++++
> >  1 files changed, 34 insertions(+), 0 deletions(-)
> > 
> > diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
> > index 02793ae..c782fc1 100644
> > --- a/man/man8/xfs_growfs.8
> > +++ b/man/man8/xfs_growfs.8
> > @@ -1,3 +1,14 @@
> > +.\" Verbatim blocks taken from openssl req manpage content
> > +.de Vb \" Begin verbatim text
> > +.ft CW
> > +.nf
> > +.ne \\$1
> > +..
> > +.de Ve \" End verbatim text
> > +.ft R
> > +.fi
> > +..
> > +
> >  .TH xfs_growfs 8
> >  .SH NAME
> >  xfs_growfs, xfs_info \- expand an XFS filesystem
> > @@ -105,6 +116,7 @@ this is specified with
> >  Specifies that no change to the filesystem is to be made.
> >  The filesystem geometry is printed, and argument checking is performed,
> >  but no growth occurs.
> > +.B See output examples below.
> >  .TP
> >  .BI "\-r | \-R " size
> >  Specifies that the real-time section of the filesystem should be grown. If the
> > @@ -152,6 +164,28 @@ reside. In order to grow a filesystem, it is
> > necessary to provide added
> >  space for it to occupy. Therefore there must be at least one spare new
> >  disk partition available. Adding the space is often done through the use
> >  of a logical volume manager.
> > +.SH "EXAMPLES"
> > +
> > +Examining xfs_info output.

How about, "Understanding xfs_info output"

> > +.PP
> > +Let's assume one have the next xfs_info output:
> > +.PP
> > +.Vb 1

Maybe you could add something indicating how the command was issued.
I.e.:

    \&# xfs_info /dev/sda

> > +\& meta-data=/dev/sda      isize=256    agcount=32, agsize=16777184 blks
> > +\&          =              sectsz=512   attr=2
> > +\& data     =              bsize=4096   blocks=536869888, imaxpct=5
> > +\&          =              sunit=32     swidth=128 blks
> > +\& naming   =version 2     bsize=4096
> > +\& log      =internal      bsize=4096   blocks=32768, version=2
> > +\&          =              sectsz=512   sunit=32 blks, lazy-count=1
> > +\& realtime =none          extsz=524288 blocks=0, rtextents=0

I think you should drop the space character after each '&' above.
The way you have it puts a slight indent in the output.

> > +.Ve
> > +.PP
> > +
> > +Here, data section block size (bsize) is 4096 bytes. Therefore
> > +"sunit=32 swidth=128 blks" means stripe unit is 32*4096 bytes = 128 kibibytes
> > +and stripe width is 128*4096 bytes = 512 kibibytes. Filesystem is striped
> > +over 4 ( 128 / 32 ) stripes.

I'll just write what I think it should be rather than trying
to show lots of little changes:

  Here, the data section of the output indicates "bsize=4096",
  meaning the data block size for this filesystem is 4096 bytes.
  This section also shows "sunit=32 swidth=128 blks", which means
  the stripe unit is 32*4096 bytes = 128 kibibytes and the stripe
  width is 128*4096 bytes = 512 kibibytes.

The last sentence I'm not sure I agree with.  I think you're
trying to explain the relationship between a stripe width
and stripe unit, and the components that make up a stripe.
Your use of the term "stripe" doesn't match what I take
to be its meaning.  I'm not saying my meaning is right, but
I'd like to make sure we have agreement on these terms.

Given that, I would re-state your last sentence (using my
terminology as):

  A single stripe of this filesystem therefore consists
  of four stripe units (128 blocks / 32 blocks per unit).

I.e., my meaning says that  a "stripe" is "stripe width"
blocks wide, made up of four "stripe units", each of which
is 32 blocks, where a block is 4096 bytes.

I think you are using the term "stripe" to represent what
I'm calling the "stripe unit".

Perhaps someone else can help ensure we're using
terms with meaning consistent with how XFS has used
them historically.

					-Alex


> >  .SH SEE ALSO
> >  .BR mkfs.xfs (8),
> >  .BR md (4),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
