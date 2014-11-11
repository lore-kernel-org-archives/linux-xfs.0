Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ED6DF7F57
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 17:27:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA6A5304062
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:27:17 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pvLHTVIWcHH9DDKW for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 15:27:16 -0800 (PST)
Date: Wed, 12 Nov 2014 10:27:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] xfs: Remove useless test
Message-ID: <20141111232714.GW28565@dastard>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
	<1415739865-2438-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415739865-2438-2-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 11, 2014 at 10:04:15PM +0100, Jan Kara wrote:
> Q_XQUOTARM is never passed to xfs_fs_set_xstate() so remove the test.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks fine - the higher layers ahave changed since this was added.
I'll pick this one up straight away.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
