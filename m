Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O1Y9UW097166 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 19:34:09 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C9A42F7FEB
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 17:31:53 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	agEZRquw6XB5n0os for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 17:31:53 -0800 (PST)
Date: Thu, 24 Feb 2011 12:31:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 03/16] xfsprogs: metadump: drop unneeded use of a
	random character
Message-ID: <20110224013135.GQ3166@dastard>
References: <201102182121.p1ILL1x7029051@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102182121.p1ILL1x7029051@stout.americas.sgi.com>
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

On Fri, Feb 18, 2011 at 03:21:01PM -0600, Alex Elder wrote:
> With the exception of the last five bytes, an obfuscated name is
> simply a random string of (acceptable) characters.  The last five
> bytes are chosen, based on the random portion before them, such that
> the resulting obfuscated name has the same hash value as the
> original name.
> 
> This is done by essentially working backwards from the difference
> between the original hash and the hash value computed for the
> obfuscated name so far, picking final bytes based on how that
> difference gets manipulated by completing the hash computation.
> 
> Of those last 5 bytes, all but the upper half of the first one are
> completely determined by this process.  The upper part of the first
> one is currently computed as four random bits, just like all the
> earlier bytes in the obfuscated name.
> 
> It is not actually necessary to randomize these four upper bits,
> and we can simply make them 0.
> 
> Here's why:
> - The final bytes are pulled directly from the hash difference
>   mentioned above, with the lowest-order byte of the hash
>   determining the last character used in the name.
> - The upper nibble of the 5th-to-last byte in a name will affect the
>   lowest 4 bits of hash value and therefore the last byte of the
>   name.  Those four bits are combined with the hash computed from
>   the random characters generated earlier.
> - Because those earlier bytes were random, their hash value will
>   also be random, and in particular, the lowest-order four bits of
>   the hash will be random.
> - So it doesn't matter whether we choose all 0 bits or some other
>   random value for that upper nibble of the byte at offset
>   (namelen - 5).  When it's combined with the hash, the last byte of
>   the name will be random either way.
> 
> Therefore we will choose to use all 0's for that upper nibble.
> 
> Doing this simplifies the generation of two of the final five
> characters, and makes all five of them get computed in a consistent
> way.  We'll still get some small bit of obfuscation for even
> 5-character names, since the upper bits of the first character will
> generally be cleared and likely different from the original.
> 
> Add the use of a mask in the one case it wasn't used to be even more
> consistent.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
