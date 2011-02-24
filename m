Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O1iUcL098032 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 19:44:30 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 518A52F8074
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 17:47:14 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Ksv0EDjoumQ1oMhd for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 17:47:14 -0800 (PST)
Date: Thu, 24 Feb 2011 12:47:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 07/16] xfsprogs: metadump: use pointers in
	generate_obfuscated_name()
Message-ID: <20110224014712.GU3166@dastard>
References: <201102182121.p1ILL1AZ029097@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102182121.p1ILL1AZ029097@stout.americas.sgi.com>
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
> Switch from using array references to using pointers to refer to the
> pathname characters as they get generated.  Also limit the scope of
> a few automatic variables.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> The only update since the last post version is the addition of an
> ASSERT() in the loop generating the last 5 bytes.

One small comment below, otherwise:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> @@ -500,16 +502,17 @@ generate_obfuscated_name(
>  		 */
>  		newhash = rol32(newhash, 3) ^ hash;
>  
> +		first = newp;
>  		high_bit = 0;
> -		for (i = 5; i > 0; i--) {
> -		    	int shift = (i - 1) * 7;
> -
> -			newp[namelen - i] = ((newhash >> shift) & 0x7f) ^ high_bit;
> -			if (is_invalid_char(newp[namelen - i])) {
> -				newp[namelen - i] ^= 1;
> +		for (shift = 28; shift >= 0; shift -= 7) {
> +			*newp = (newhash >> shift & 0x7f) ^ high_bit;

I'd prefer not to have to refer to my C bible to remind myself what
the precedence of ">>" vs "&" is, so perhaps leaving the second set
of () in this statement would be a good idea.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
