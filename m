Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9O98FnL061418 for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 04:08:16 -0500
Date: Mon, 24 Oct 2011 05:08:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] xfstests: add new stress test
Message-ID: <20111024090813.GB31887@infradead.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
	<1319020189-13584-8-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1319020189-13584-8-git-send-email-dmonakhov@openvz.org>
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
Cc: jack@suse.cz, xfs@oss.sgi.com, hch@infradead.org, aelder@sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Oct 19, 2011 at 02:29:48PM +0400, Dmitry Monakhov wrote:
> During stress testing we want to cover as much code paths as possible
> fsstress is very good for this purpose. But it has expandable nature
> (disk usage almost continually grow). So once it goes in no ENOSPC
> condition it will be where till the end. But by running 'dd' writers
> in parallel we can regularly trigger ENOSPC but only for a limited
> periods of time because each time it opens file with O_TRUNC.

Looks good, but please use a more useful subject line, e.g.

xfstests: add a new test that runs fsstress under ENOSPC conditions.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
