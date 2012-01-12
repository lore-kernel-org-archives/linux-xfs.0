Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0C2mlXq209885 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 20:48:47 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ER1cpCUME2dI6cbY for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 18:48:44 -0800 (PST)
Date: Thu, 12 Jan 2012 13:48:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] Fix filesystem freezing
Message-ID: <20120112024841.GB2806@dastard>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326331253-6497-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jan 12, 2012 at 02:20:49AM +0100, Jan Kara wrote:
> 
>   Hello,
> 
>   filesystem freezing is currently racy and thus we can end up with dirty data
> on frozen filesystem (see changelog of the first patch for detailed race
> description and proposed fix). This patch series aims at fixing this.

It only fixes the dirty data race (i.e. SB_FREEZE_WRITE). The same
race conditions exist for SB_FREEZE_TRANS on XFS, and so need the
same fix. That race has had one previous attempt at fixing it in
XFS but that's not possible:

b2ce397 Revert "xfs: fix filesystsem freeze race in xfs_trans_alloc"
7a249cf xfs: fix filesystsem freeze race in xfs_trans_alloc

It was looking at that problem earlier today that lead to the
solution Eric proposed. Essentially the method in these patches
needs to replace the xfs specifc m_active_trans counter and delay
during ->fs_freeze to prevent that race condition....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
