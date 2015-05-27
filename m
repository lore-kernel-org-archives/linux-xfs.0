Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B76107F47
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 20:56:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B7848F8033
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 18:56:10 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0HpJRMB4fOCWV4WH for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 18:56:08 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YxQZh-0001XP-OZ
	for xfs@oss.sgi.com; Wed, 27 May 2015 11:56:05 +1000
Date: Wed, 27 May 2015 11:56:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: extent size hints can round up extents past
	MAXEXTLEN
Message-ID: <20150527015605.GZ15721@dastard>
References: <1432686984-15195-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1432686984-15195-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Wed, May 27, 2015 at 10:36:24AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This results in BMBT corruption, as seen by this test:
....
> -	if ((temp = (align_alen % extsz))) {
> -		align_alen += extsz - temp;
> -	}
> +	while (align_alen > MAXEXTLEN)
> +		align_alen -= extsz;
> +	ASSERT(align_alen <= MAXEXTLEN);

FYI, this bit is the only difference in this version - it fixes the
test case that Brian pointed out that still didn't work properly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
