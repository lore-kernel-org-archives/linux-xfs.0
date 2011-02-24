Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1OLlpVZ162013 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 15:47:51 -0600
Subject: Re: [PATCH v3, 01/16] xfsprogs: metadump: some names aren't all
	that special
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110224011837.GO3166@dastard>
References: <201102182121.p1ILL1T8029031@stout.americas.sgi.com>
	<20110224011837.GO3166@dastard>
Date: Thu, 24 Feb 2011 15:50:33 -0600
Message-ID: <1298584233.1990.194.camel@doink>
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

On Thu, 2011-02-24 at 12:18 +1100, Dave Chinner wrote:
> On Fri, Feb 18, 2011 at 03:21:01PM -0600, Alex Elder wrote:
> > Move the check for short names out of is_special_dirent() and into
> > generate_obfuscated_name().  That way the check is more directly
> > associated with the algorithm that requires it.
> > 
> > Similarly, move the check for inode == 0, since that case has to do
> > with storing extended attributes (not files) in the name table.
> > 
> > As a result, is_special_dirent() is really only focused on whether a
> > given file is in the lost+found directory.  Rename the function to
> > reflect its more specific purpose.
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> > 
> > Updated:

. . .

> > +#define	is_lost_found(mnt, dir_ino, nmlen, nm)			\
> > +		((dir_ino) == (mnt)->m_sb.sb_rootino &&		\
> > +			(nmlen) == ORPHANAGE_LEN &&		\
> > +			!memcmp((nm), ORPHANAGE, ORPHANAGE_LEN))
> 
> Perhaps a static inline function?

OK.

> > +
> > +#define	ORPHANAGE	"lost+found"
> > +#define	ORPHANAGE_LEN	(sizeof ORPHANAGE - 1)
> 
> sizeof works without ()? Even it is does, it is unusual to do so,
> and a little ambiguous....

Yes it does.  You need the parentheses when you're
asking about a type name, but for an object they are
not needed.  It is not ambiguous.  Nevertheless I don't
mind adding two characters to the patch.

> > +
> >  static int
> > -is_special_dirent(
> > +in_lost_found(
> 
> Oh, that confused me for a second - in_lost_found and is_lost_found
> are very similar in name, hence easily confused when scanning the
> code. Not sure how better to name them, maybe you've got a better
> idea, Alex?

I had the same thought, actually, but didn't do anything
about it.  I could use is_orphanage_dir(), what do you think
of that?  Or alternately could  change in_lost_found() to
be is_orphan() (or both).  Unless I hear a better suggestion
I'll just do is_orphanage_dir(), as an inline function.

> 
> >  	xfs_ino_t		ino,
> >  	int			namelen,
> >  	uchar_t			*name)
> >  {
> >  	static xfs_ino_t	orphanage_ino = 0;
> > -	char			s[32];
> > +	char			s[24];	/* 21 is enough */
> 
> Why is 21 enough?

Because it's formatting a 64-bit unsigned in
decimal.  2^64 = 18 446 744 073 709 551 616
That's 20 digits, plus a trailing '\0'.  Do
you want me to clarify this in a comment
somehow?  (I suppose unsigned long long is
not technically guaranteed to be 64 bits
either.)

> 
> >  	int			slen;
> >  
> > -	/*
> > -	 * due to the XFS name hashing algorithm, we cannot obfuscate
> > -	 * names with 4 chars or less.
> > -	 */
> > -	if (namelen <= 4)
> > -		return 1;
> > +	/* Record the "lost+found" inode if we haven't done so already */
> >  
> > -	if (ino == 0)
> > +	ASSERT(ino != 0);
> > +	if (!orphanage_ino && is_lost_found(mp, cur_ino, namelen, name))
> > +		orphanage_ino = ino;
> > +
> > +	/* We don't obfuscate the "lost+found" directory itself */
> > +
> > +	if (ino == orphanage_ino)
> > +	    	return 1;
> > +
> > +	/* Most files aren't in "lost+found" at all */
> > +
> > +	if (cur_ino != orphanage_ino)
> >  		return 0;
> 
> I'm judging by this that if a directory tree is attached to
> lost+found we are obfuscating anything in that subdirectory?

Yes.  I preserved the way the code worked before, which is that:
- lost+found itself is not obfuscated
- files directly under lost+found whose filename is the
  decimal representation of the file's inode number are
  treated as orphans, and they are not obfuscated
- anything else (including things in lost+found with
  non-inode-number names, and anything below a subdirectory
  under lost+found) is obfuscated.

> >  
> >  	/*
> > -	 * don't obfuscate lost+found nor any inodes within lost+found with
> > -	 * the inode number
> > +	 * Within "lost+found", we don't obfuscate any file whose
> > +	 * name is the same as its inode number.  Any others are
> > +	 * stray files and can be obfuscated.
> >  	 */
> > -	if (cur_ino == mp->m_sb.sb_rootino && namelen == 10 &&
> > -			memcmp(name, "lost+found", 10) == 0) {
> > -		orphanage_ino = ino;
> > -		return 1;
> > -	}
> > -	if (cur_ino != orphanage_ino)
> > -		return 0;
> > +	slen = snprintf(s, sizeof s, "%llu", (unsigned long long) ino);
> >  
> > -	slen = sprintf(s, "%lld", (long long)ino);
> > -	return (slen == namelen && memcmp(name, s, namelen) == 0);
> > +	return slen == namelen && !memcmp(name, s, namelen);
> >  }
> >  
> >  static void
> > @@ -426,13 +442,25 @@ generate_obfuscated_name(
> >  	xfs_dahash_t		newhash;
> >  	uchar_t			newname[NAME_MAX];
> >  
> > -	if (is_special_dirent(ino, namelen, name))
> > -		return;
> > +	/*
> > +	 * Our obfuscation algorithm requires at least 5-character
> > +	 * names, so don't bother if the name is too short.
> > +	 */
> > +	if (namelen < 5)
> > +	    	return;
> 
> Please make usre you include the reason for this - that this is a
> property of the name hashing algorithm.

Well, the comment above it alludes to it, although
it emphasizes obfuscation rather than the hash.
I'll try to come up with a concise way to do
what you ask though.

> > -	hash = libxfs_da_hashname(name, namelen);
> > +	/*
> > +	 * We don't obfuscate "lost+found" or any orphan files
> > +	 * therein.  When the name table is used for extended
> > +	 * attributes, the inode number provided is 0, in which
> > +	 * case we don't need to make this check.
> > +	 */
> > +	if (ino && in_lost_found(ino, namelen, name))
> > +		return;
> >  
> >  	/* create a random name with the same hash value */
> >  
> > +	hash = libxfs_da_hashname(name, namelen);
> >  	do {
> >  		dup = 0;
> >  		newname[0] = '/';
> > 


I'll adjust my patch based on your comments and re-post for
a final review.  I'll fix and re-post the few other patches
you had suggestions on too.

Thanks a lot for reviewing it, Dave.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
