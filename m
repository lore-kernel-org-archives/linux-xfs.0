Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EE6AE7F86
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 17:24:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D41DAC006
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:23:59 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	g3lIC8xSBLzrJIxu for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 15:23:57 -0800 (PST)
Date: Wed, 12 Nov 2014 10:23:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/11] xfs: Remove unused variable in
	xfs_qm_scall_quotaon()
Message-ID: <20141111232333.GU28565@dastard>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
	<1415739865-2438-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415739865-2438-3-git-send-email-jack@suse.cz>
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

On Tue, Nov 11, 2014 at 10:04:16PM +0100, Jan Kara wrote:
> sbflags variable in xfs_qm_scall_quotaon() was practically unused (we
> only set it to constant at one place and used it elsewhere). Remove it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I have patches in my queue that change the superblock logging
quite a bit and remove the functionality you're changing in this
patch, so eventually you'll be able to drop this patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
