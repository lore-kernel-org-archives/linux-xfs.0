Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2EALmM5064938 for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 05:21:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABC2E138E39B
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 03:24:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lCwI7PbykSyzxb6X for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2011 03:24:32 -0700 (PDT)
Date: Mon, 14 Mar 2011 06:24:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Check for immutable flag in fallocate path
Message-ID: <20110314102426.GA29888@infradead.org>
References: <4D6221B8.9040303@gmail.com> <4D6F5473.2070709@gmail.com>
	<20110303213903.GL15097@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110303213903.GL15097@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, cluster-devel@redhat.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, Mar 04, 2011 at 08:39:03AM +1100, Dave Chinner wrote:
> WTF?  Why does append mode have any effect on whether we can punch
> holes in a file or not? There's no justification for adding this in
> the commit message. Why is it even in a patch that is for checking
> immutable inodes? What is the point of adding it, when all that will
> happen is people will switch to XFS_IOC_UNRESVSP which has never had
> this limitation?

xfs_ioc_space unconditionally rejects inodes with S_APPEND set for
all preallocation / hole punching ioctls.  This might be overzealous for
preallocations not changing the size, or just extending i_size, but it's
IMHO entirely correct for hole punching.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
