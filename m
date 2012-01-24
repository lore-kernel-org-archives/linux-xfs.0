Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O8LO59223084 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 02:21:24 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bYIwuRIReZzQMwiz for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 00:21:22 -0800 (PST)
Date: Tue, 24 Jan 2012 19:21:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/8] vfs: Protect write paths by sb_start_write -
	sb_end_write
Message-ID: <20120124082119.GO15102@dastard>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1327091686-23177-3-git-send-email-jack@suse.cz>
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

On Fri, Jan 20, 2012 at 09:34:40PM +0100, Jan Kara wrote:
> There are three entry points which dirty pages in a filesystem.  mmap (handled
> by block_page_mkwrite()), buffered write (handled by
> __generic_file_aio_write()), and truncate (it can dirty last partial page -
> handled inside each filesystem separately). Protect these places with
> sb_start_write() and sb_end_write().

fallocate can also dirty pages, either during preallocation or hole
punching.  Hence if you are going to promote truncate to
SB_FREEZE_WRITE protection then you need to promote everything else
that can zero partial blocks as well.

That also means that anything the has implemented XFS_IOC_ ioctl
interfaces for prellocation and hole punching (xfs, ocfs2 and gfs2
IIRC) also needs to be protected in the same way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
