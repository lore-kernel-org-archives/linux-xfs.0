Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2353VQb067261 for <xfs@oss.sgi.com>; Wed, 2 Mar 2011 23:03:32 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29698130C610
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2011 21:06:21 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4gXnqFtPTgaf0Q2l for <xfs@oss.sgi.com>;
	Wed, 02 Mar 2011 21:06:21 -0800 (PST)
Date: Thu, 3 Mar 2011 16:06:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 15/16] xfsprogs: metadump: use printable characters
	for obfuscated names
Message-ID: <20110303050614.GG15097@dastard>
References: <201102182121.p1ILL2Ti029193@stout.americas.sgi.com>
	<20110224084545.GC3166@dastard> <1298657636.1990.6989.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298657636.1990.6989.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 25, 2011 at 12:13:56PM -0600, Alex Elder wrote:
> On Thu, 2011-02-24 at 19:45 +1100, Dave Chinner wrote:
> > On Fri, Feb 18, 2011 at 03:21:02PM -0600, Alex Elder wrote:
> > > There is probably not much need for an extreme amount of randomness
> > > in the obfuscated names produced in metadumps.  Limit the character
> > > set used for (most of) these names to printable characters rather
> > > than every permittable byte.  The result makes metadumps a bit more
> > > natural to work with.
> > > 
> > > I chose the set of all upper- and lower-case letters, digits, and
> > > the dash and underscore for the alphabet.  It could easily be
> > > expanded to include others (or reduced for that matter).
> > > 
> > > This change also avoids ever having to retry after picking an
> > > unusable character.
> > > 
> > > Signed-off-by: Alex Elder <aelder@sgi.com>
> > > 
> > > No significant changes in this version from the last version posted.
> > > 
> > > ---
> > >  db/metadump.c |    9 ++++-----
> > >  1 file changed, 4 insertions(+), 5 deletions(-)
> > > 
> > > Index: b/db/metadump.c
> > > ===================================================================
> > > --- a/db/metadump.c
> > > +++ b/db/metadump.c
> > > @@ -412,12 +412,11 @@ nametable_add(xfs_dahash_t hash, int nam
> > >  static inline uchar_t
> > >  random_filename_char(void)
> > >  {
> > > -	uchar_t			c;
> > > +	static uchar_t filename_alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
> > > +						"abcdefghijklmnopqrstuvwxyz"
> > > +						"0123456789-_";
> > >  
> > > -	do {
> > > -		c = random() % 127 + 1;
> > > -	} while (c == '/');
> > > -	return c;
> > > +	return filename_alphabet[random() % (sizeof filename_alphabet - 1)];
> > >  }
> > 
> > Why not just:
> > 
> > 	do {
> > 		c = random() % 127 + 1;
> > 	} while (!isalnum(c));
> > 
> > 	return c;
> > 
> 
> Mainly because I wasn't sure what people would want as an acceptable
> alphabet to select from.  We could just use [a-z], for example, and
> this way that could easily be changed without changing how the
> function worked.  It's also locale-independent (which may or may not
> be good I suppose).

isalnum() allows locale specific characters, so allows a larger
number of potential characters than just the static table you
defined. That was the primary reasonn I suggested it - more random
characters to chose from means less probability of duplicates
occurring....

> Plus as an added bonus, it will never need to compute any
> unnecessary random numbers, thereby saving about 12 CPU
> cycles. :)

I doubt that is likely to be a problem. :)

> I don't really care much, but would lean toward leaving
> it the way I have it.  Do you feel strongly that I should
> change it?  Do you think [a-z] (islower()) would be even
> better?

No, the more random characters there are to chose from the better. I
guess that the table you've defined is plenty to chose from, so in
the absense of any hard numbers, I think your table-based approach
will be fine.

Swings and round-abouts, deck chairs on the Titanic...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
