Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67C1029E07
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 17:24:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53B5D30406A
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 15:24:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nuinyP6SHZKy9nXs for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 15:24:56 -0700 (PDT)
Date: Wed, 8 May 2013 08:24:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] Fix test 298 to work for non-XFS filesystems
Message-ID: <20130507222455.GE24635@dastard>
References: <1367964573-29620-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1367964573-29620-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Wed, May 08, 2013 at 12:09:32AM +0200, Jan Kara wrote:
> Call to xfs_io in test 298 forgot to specify -F flag so it failed for
> non-XFS filesystems.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

See Eric's recent patch series to fix this.

http://oss.sgi.com/pipermail/xfs/2013-May/026057.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
