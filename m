Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1GAWnNj138887 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 04:32:49 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D4B21CD393D
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:34:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gAxSnBeInh9Rh8lp for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:34:06 -0800 (PST)
Subject: Re: [PATCH 00/10] quotactl fixed and cleanups
From: Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <20100216084446.377980079@bombadil.infradead.org>
References: <20100216084446.377980079@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 10:37:20 +0000
Message-ID: <1266316640.2738.0.camel@localhost>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

Hi,

On Tue, 2010-02-16 at 03:44 -0500, Christoph Hellwig wrote:
> This is a first large batch of refactoring the generic quotactl code.
> I started looking at this for merging the FS interfaces for "VFS" and "XFS"
> style quotas now that we grow more filesystems wanting to support quota
> in a more advanced way than the generic implementation can, e.g. GFS2
> and cifs.  There will be another couple of patches do do the actual
> work which are not quite ready, but this is a large and useful enough batch
> to get review and possibly included first.

Looks good from a GFS2 PoV, so:

Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
