Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3S2GI1N242119 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 21:16:18 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 458CC154B151
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 19:19:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	q9rSm8P0KzTRNCDQ for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2011 19:19:50 -0700 (PDT)
Date: Thu, 28 Apr 2011 12:19:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: 253: test the metadump functionality of xfs_db
Message-ID: <20110428021948.GO12436@dastard>
References: <01d934eed0de0a992f3f8d6d609fa32d7e966b04.1303422281.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <01d934eed0de0a992f3f8d6d609fa32d7e966b04.1303422281.git.aelder@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 21, 2011 at 04:44:45PM -0500, Alex Elder wrote:
> This patch creates a test that exercises xfs_metadump, with a focus
> on its obfuscation of names.  It was created to verify fixes that
> avoided a hang condition when running "xfs_metadump" on a directory
> containing files having particular bit patterns in their name.
> Arkadiusz Mi=C5=9Bkiewicz first reported seeing this while attempting
> to create a metadump for a filesystem containing a file named
> "R\323\257NE".
> =

> For now this script checks the following (using only filenames, not
> attributes):
> - that short names (4 characters or less) aren't obfuscated
> - that long names get obfuscated
> - that (long) directory names get obfuscated
> - that names that are known to produce bit patterns that lead
>   to invalid path components still generate obfuscated names
>   (this could previously lead to a hang)
> - that many names of the same length can still generate new
>   obfuscated names (this could previously lead to a hang)
> - that neither "lost+found" nor orphaned files stored in it ge
>   obfuscated
> =

> Right now there are two sets of "ls" commands executed (one before
> and one after obfuscation).  This produces repeatable results for
> me on one filesystem, but on a different filesystem I expect the
> inode numbers to change (and random number generation might change
> the output too).  I'm interested in suggestions on how to filter
> the output so the results can be verified.  If nothing else, the
> test serves its purpose if I simply comment out those commands,
> and will do that if there's not a better suggstion.

Don't put the listing in the golden output - just put it in
$seq.full. That way if the test fails, the output is still there for
analysis.

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
