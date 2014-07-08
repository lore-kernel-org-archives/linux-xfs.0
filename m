Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AA467F4E
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 20:00:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 512778F8070
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 17:59:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	neukUtthTjPYWJI5 for <xfs@oss.sgi.com>;
	Mon, 07 Jul 2014 17:59:57 -0700 (PDT)
Date: Tue, 8 Jul 2014 10:59:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] repair: Repair directory block CRC mismatches
Message-ID: <20140708005954.GD4453@dastard>
References: <1403602415-28767-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1403602415-28767-1-git-send-email-jack@suse.cz>
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

On Tue, Jun 24, 2014 at 11:33:35AM +0200, Jan Kara wrote:
> It can happen that just CRC doesn't match for directory blocks. In that
> case xfs_repair will just report the error but won't fix anything (as
> further checking of the block doesn't reveal any problems). Make sure we
> recompute and write out new CRC when we failed verification during
> reading.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied and pushed. Thanks.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
