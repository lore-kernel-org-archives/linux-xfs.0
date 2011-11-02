Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA2Js1ih196780 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 14:54:02 -0500
Date: Wed, 2 Nov 2011 15:53:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] xfstests: add a new test that runs fsstress under
	ENOSPC conditions
Message-ID: <20111102195357.GA22500@infradead.org>
References: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
	<1319849297-3506-8-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1319849297-3506-8-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de, aelder@sgi.com

On Sat, Oct 29, 2011 at 04:48:16AM +0400, Dmitry Monakhov wrote:
> During stress testing we want to cover as much code paths as possible
> fsstress is very good for this purpose. But it has expandable nature
> (disk usage almost continually grow). So once it goes in no ENOSPC
> condition it will be where till the end. But by running 'dd' writers
> in parallel we can regularly trigger ENOSPC but only for a limited
> periods of time because each time it opens the same file with O_TRUNC.

This fails for me on XFS because the fsstress process has already
finished by the time you try to kill it:

--- 266.out	2011-11-02 19:46:27.000000000 +0000
+++ 266.out.bad	2011-11-02 19:48:33.000000000 +0000
@@ -3,3 +3,4 @@
 Run fsstress
  
 Run dd writers in parallel
+./266: line 60: kill: (3403) - No such process

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
