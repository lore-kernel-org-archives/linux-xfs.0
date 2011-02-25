Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PIBBAK215402 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 12:11:11 -0600
Subject: Re: [PATCH v3, 15/16] xfsprogs: metadump: use printable characters
	for obfuscated names
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110224084545.GC3166@dastard>
References: <201102182121.p1ILL2Ti029193@stout.americas.sgi.com>
	<20110224084545.GC3166@dastard>
Date: Fri, 25 Feb 2011 12:13:56 -0600
Message-ID: <1298657636.1990.6989.camel@doink>
Mime-Version: 1.0
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

On Thu, 2011-02-24 at 19:45 +1100, Dave Chinner wrote:
> On Fri, Feb 18, 2011 at 03:21:02PM -0600, Alex Elder wrote:
> > There is probably not much need for an extreme amount of randomness
> > in the obfuscated names produced in metadumps.  Limit the character
> > set used for (most of) these names to printable characters rather
> > than every permittable byte.  The result makes metadumps a bit more
> > natural to work with.
> > 
> > I chose the set of all upper- and lower-case letters, digits, and
> > the dash and underscore for the alphabet.  It could easily be
> > expanded to include others (or reduced for that matter).
> > 
> > This change also avoids ever having to retry after picking an
> > unusable character.
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> > 
> > No significant changes in this version from the last version posted.
> > 
> > ---
> >  db/metadump.c |    9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > Index: b/db/metadump.c
> > ===================================================================
> > --- a/db/metadump.c
> > +++ b/db/metadump.c
> > @@ -412,12 +412,11 @@ nametable_add(xfs_dahash_t hash, int nam
> >  static inline uchar_t
> >  random_filename_char(void)
> >  {
> > -	uchar_t			c;
> > +	static uchar_t filename_alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
> > +						"abcdefghijklmnopqrstuvwxyz"
> > +						"0123456789-_";
> >  
> > -	do {
> > -		c = random() % 127 + 1;
> > -	} while (c == '/');
> > -	return c;
> > +	return filename_alphabet[random() % (sizeof filename_alphabet - 1)];
> >  }
> 
> Why not just:
> 
> 	do {
> 		c = random() % 127 + 1;
> 	} while (!isalnum(c));
> 
> 	return c;
> 

Mainly because I wasn't sure what people would want as an acceptable
alphabet to select from.  We could just use [a-z], for example, and
this way that could easily be changed without changing how the
function worked.  It's also locale-independent (which may or may not
be good I suppose).

Plus as an added bonus, it will never need to compute any
unnecessary random numbers, thereby saving about 12 CPU
cycles. :)

I don't really care much, but would lean toward leaving
it the way I have it.  Do you feel strongly that I should
change it?  Do you think [a-z] (islower()) would be even
better?

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
