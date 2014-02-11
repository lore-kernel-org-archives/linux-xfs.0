Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D94547F3F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 01:19:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 995198F8050
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 23:19:31 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7WKCpjGTCkblDs4Q for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 23:19:30 -0800 (PST)
Date: Tue, 11 Feb 2014 18:19:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 07/11] xfs: refactor xfs_difree() inobt bits into
	xfs_difree_inobt() helper
Message-ID: <20140211071927.GH13647@dastard>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-8-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391536182-9048-8-git-send-email-bfoster@redhat.com>
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

On Tue, Feb 04, 2014 at 12:49:38PM -0500, Brian Foster wrote:
> Refactor xfs_difree() in preparation for the finobt. xfs_difree()
> performs the validity checks against the ag and reads the agi
> header. The work of physically updating the inode allocation btree
> is pushed down into the new xfs_difree_inobt() helper.
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
