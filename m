Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B34A17F6B
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 18:26:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 809628F8037
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 16:26:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Eu1konBVhNonQaCy for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 16:26:12 -0700 (PDT)
Date: Thu, 2 Oct 2014 09:25:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: check for null dquot in xfs_quota_calc_throttle()
Message-ID: <20141001232559.GG10298@dastard>
References: <542C28E5.506@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <542C28E5.506@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 01, 2014 at 11:16:37AM -0500, Eric Sandeen wrote:
> Coverity spotted this.
> 
> Granted, we *just* checked xfs_inod_dquot() in the caller (by calling
> xfs_quota_need_throttle), but to be honest I don't know if this can
> race, and this is the only place we don't check the return value -
> and the check seems cheap and future-proof.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Sorry for the handwavy commit log, if it's obvious that it can
> race, feel free to fix the description. ;)

Description changed simply to say:

... this is the only place we don't check the return value, but the
check is cheap and future-proof, so add it.

And so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
