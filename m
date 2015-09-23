Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F8B77F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 22:09:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 439FD8F8035
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 20:09:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Z4JKa2qE0rxAUzok for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 20:09:03 -0700 (PDT)
Date: Wed, 23 Sep 2015 13:09:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/14] xfsprogs: avoid dependency on Linux XATTR_SIZE_MAX
Message-ID: <20150923030901.GM3902@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-4-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1442311164-12921-4-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 15, 2015 at 11:59:13AM +0200, Jan Tulak wrote:
> Currently, we depends on Linux XATTR value for on disk
> definitions. Which causes trouble on other platforms and
> maybe also if this value was to change.
> 
> Fix it by creating a custom definition independent from
> those in Linux (although with the same values), so it is OK
> with the be16 fields used for holding these attributes.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Looks good. We'll need a kernel version of this patch, too.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
