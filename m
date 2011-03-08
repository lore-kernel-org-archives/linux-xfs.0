Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p280lSic191806 for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 18:47:28 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B2BA1C92470
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2011 16:50:20 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5k2yPEGDYBb4aY5I for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2011 16:50:20 -0800 (PST)
Date: Tue, 8 Mar 2011 11:50:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4, 14/16] xfsprogs: metadump: fix duplicate handling
	once and for all
Message-ID: <20110308005017.GC1956@dastard>
References: <1299519558.2578.322.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299519558.2578.322.camel@doink>
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

On Mon, Mar 07, 2011 at 11:39:18AM -0600, Alex Elder wrote:
> This is a case where I think I've solved a problem to death.
> 
> The metadump code now stops rather than spinning forever in the face
> of finding no obfuscated name that hasn't already been seen.
> Instead, it simply gives up and passes the original name back to use
> without obfuscation.
> 
> Unfortunately, as a result it actually creates entries with
> duplicate names in a directory (or inode attribute fork).  And at
> least in the case of directories, xfs_mdrestore(8) will populate the
> directory it restores with duplicate entries.  That even seems to
> work, but xfs_repair(8) does identify this as a problem and fixes it
> (by moving duplicates to "lost+found").
> 
> This might have been OK, given that it was a rare occurence.  But
> it's possible, with short (5-character) names, for the obfuscation
> algorithm to come up with only a single possible alternate name,
> and I felt that was just not acceptable.
> 
> This patch fixes all that by creating a way to generate alternate
> names directly from existing names by carefully flipping pairs of
> bits in the characters making up the name.
> 
> 	
> The first change is that a name is only ever obfuscated once.
> If the obfuscated name can't be used, an alternate is computed
> based on that name rather than re-starting the obfuscation
> process.  (Names shorter than 5 characters are still not
> obfuscated.)
> 
> Second, once a name is selected for use (obfuscated or not), it is
> checked for duplicates.  The name table is consulted to see if it
> has already been seen, and if it has, an alternate for that name is
> created (a different name of the same length that has the same hash
> value).  That name is checked in the name table, and if it too is
> already there the process repeats until an unused one is found.
> 
> Third, alternates are generated methodically rather than by
> repeatedly trying to come up with new random names.  A sequence
> number uniquely defines a particular alternate name, given an
> existing name.  (Note that some of those alternates aren't valid
> because they contain at least one unallowed character.)
> 
> Finally, because all names are now maintained in the name table,
> and because of the way alternates are generated, it's actually
> possible for short names to get modified in order to avoid
> duplicates.
> 
> The algorithm for doing all of this is pretty well explained in
> the comments in the code itself, so I'll avoid duplicating any
> more of that here.
> 
> Updates since last posting:
>     - Definition of ARRAY_SIZE() macro moved to "include/libxfs.h"
>     - Added some more background commentary:
> 	- About the details of operation in flip_bit().
> 	  Specifically, that the table can be expanded as needed,
> 	  but that it is already way bigger than practically
> 	  necessary (and why it is that way).
> 	- About the number of alternates available as the length
> 	  of a name increases.
> 	- That the key cases we're interested in are names that are
> 	  around 5 characters in length.  Less than that it's not
> 	  very important because we don't obfuscate the name, and
> 	  greater than that the odds of the result of conflicting 
> 	  with an existing name are small.
>     - Basically, the density of meaning in this code is kind of
>       high, so it warrants a lot more comments to help make what
>       it's doing more apparent.  So I fleshed this out, as requested
>       by Dave.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

The additional comments help a lot in explaining this code. Very
well written, Alex.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
