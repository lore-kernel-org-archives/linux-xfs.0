Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 244D529DFB
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 16:45:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A41CAAC001
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 14:44:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vq6GhKnDV2N775GQ for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 14:44:56 -0700 (PDT)
Date: Tue, 12 May 2015 07:44:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Inode and dentry cache behavior
Message-ID: <20150511214442.GF15721@dastard>
References: <CABppvi55C+vE7Ei8u=_ntC_heDQb4HwUcKom-_9hGkunk84Sfw@mail.gmail.com>
	<20150423224324.GM15810@dastard>
	<CABppvi7+Mu78FAM75YvJvekX2CHtKk4yeMrU7j35fvvWRb923Q@mail.gmail.com>
	<20150424061554.GN15810@dastard>
	<CABppvi6N6McmfLgAPcP9cxXxPrBMaD81UyeiVHWOaxrJisSN=g@mail.gmail.com>
	<20150429013024.GU15810@dastard>
	<CABppvi63mY=-UFEyupF2-TQux+arOaCy+B-rtckvZziuachCbA@mail.gmail.com>
	<CABppvi4CA_FOuJz8zrr=gNguzKKrQqG5Q30gfP9YMf1KSCM8jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi4CA_FOuJz8zrr=gNguzKKrQqG5Q30gfP9YMf1KSCM8jQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: xfs@oss.sgi.com

On Mon, May 11, 2015 at 02:07:39PM -0700, Shrinand Javadekar wrote:
> In case you're curious, the solutions to this problem are being
> discussed at [1] on the Swift side.
> 
> O_TMPFILE and linkat() aren't available in all kernels (and python)
> and therefore not a viable option right away. Among few others, one of
> the proposals is to shard the tmp directory into say 256 dirs and
> create these files inside those dirs. That way files won't get created
> in a single AG. Are there any other problems if this is done?

Yes, you don't get any locality between files in the same directory
once you move them to their final location in the hash tree. You'll
end up with the same problems you are trying to solve now as the
object count goes up - you'll simply have taken a different path to
the same destination....

Create your temp files in their eventual destination directory -
doing anything else is pretty much guaranteed to compromise all the
locality algorithms the filesystem uses. Without good locality
within the data set, performance of lookups and writeback will
degrade to large seek time random IO pretty quickly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
