Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 581667F51
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 19:53:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E98F0AC002
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 17:53:34 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XZGMjOwPDZklB3IH for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 17:53:33 -0800 (PST)
Date: Tue, 25 Nov 2014 12:53:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
	day stale
Message-ID: <20141125015332.GE27262@dastard>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-4-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1416599964-21892-4-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 21, 2014 at 02:59:23PM -0500, Theodore Ts'o wrote:
> Guarantee that the on-disk timestamps will be no more than 24 hours
> stale.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

If we put these inodes on the dirty inode list with at writeback
time of 24 hours, this is completely unnecessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
