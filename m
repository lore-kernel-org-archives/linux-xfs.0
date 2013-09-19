Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40D7D29DFB
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 18:50:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 330718F8066
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 16:50:48 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	a9tiGz9cSJSDcqFC for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 16:50:46 -0700 (PDT)
Date: Fri, 20 Sep 2013 09:50:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 4/4] xfs: clean up xfs_inactive() error handling, kill
	VN_INACTIVE_[NO]CACHE
Message-ID: <20130919235038.GS9901@dastard>
References: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
	<1379618121-35105-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379618121-35105-5-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 19, 2013 at 03:15:21PM -0400, Brian Foster wrote:
> The xfs_inactive() return value is meaningless. Turn xfs_inactive()
> into a void function and clean up the error handling appropriately.
> Kill the VN_INACTIVE_[NO]CACHE directives as they are not relevant
> to Linux.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
