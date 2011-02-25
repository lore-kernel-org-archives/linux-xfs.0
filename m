Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PIAwdi215328 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 12:10:58 -0600
Subject: [PATCH v4, 07/16] xfsprogs: metadump: use pointers in
	generate_obfuscated_name()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110224014712.GU3166@dastard>
References: <201102182121.p1ILL1AZ029097@stout.americas.sgi.com>
	<20110224014712.GU3166@dastard>
Date: Fri, 25 Feb 2011 12:13:40 -0600
Message-ID: <1298657620.1990.6985.camel@doink>
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

. . .
> One small comment below, otherwise:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > @@ -500,16 +502,17 @@ generate_obfuscated_name(
> >  		 */
> >  		newhash = rol32(newhash, 3) ^ hash;
> >  
> > +		first = newp;
> >  		high_bit = 0;
> > -		for (i = 5; i > 0; i--) {
> > -		    	int shift = (i - 1) * 7;
> > -
> > -			newp[namelen - i] = ((newhash >> shift) & 0x7f) ^ high_bit;
> > -			if (is_invalid_char(newp[namelen - i])) {
> > -				newp[namelen - i] ^= 1;
> > +		for (shift = 28; shift >= 0; shift -= 7) {
> > +			*newp = (newhash >> shift & 0x7f) ^ high_bit;
> 
> I'd prefer not to have to refer to my C bible to remind myself what
> the precedence of ">>" vs "&" is, so perhaps leaving the second set
> of () in this statement would be a good idea.

Done.




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
