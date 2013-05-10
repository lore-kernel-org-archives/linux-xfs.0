Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2186929DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 20:38:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ACBF8AC001
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 18:38:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AtiAWjuxIiY6mnsH for <xfs@oss.sgi.com>;
	Thu, 09 May 2013 18:38:32 -0700 (PDT)
Date: Fri, 10 May 2013 11:38:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
Message-ID: <20130510013830.GO23072@dastard>
References: <20130507193146.GA7539@redhat.com> <51895CD7.7040806@sgi.com>
	<20130507195954.GA8384@redhat.com> <51895E51.2050508@sgi.com>
	<20130507202217.GA9883@redhat.com> <518962FC.2060509@sgi.com>
	<20130507222256.GD24635@dastard> <51898400.8000900@sgi.com>
	<20130507235458.GG24635@dastard> <518A5213.60307@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518A5213.60307@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Dave Jones <davej@redhat.com>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Wed, May 08, 2013 at 08:24:35AM -0500, Mark Tinguely wrote:
> On 05/07/13 18:54, Dave Chinner wrote:
> 
> 
> Checking the EFI for whether it is being released from recovery
> after we've already released the known active reference is a mistake
> worthy of a brown paper bag. Fix the (now) obvious use after free
> that it can cause.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_extfree_item.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> Looks good.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Zach pointed out that the fix is much more complex than it needs to
be. I'll respin the patch and resend it later today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
