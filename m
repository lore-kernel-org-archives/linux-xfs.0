Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3KC0qle032578 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 07:00:53 -0500
Received: from lon1-post-3.mail.demon.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94141148CEAB
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 05:02:50 -0700 (PDT)
Received: from lon1-post-3.mail.demon.net (lon1-post-3.mail.demon.net
	[195.173.77.150]) by cuda.sgi.com with ESMTP id
	tGeGMao9ztLWPu7M for <xfs@oss.sgi.com>;
	Tue, 20 Apr 2010 05:02:50 -0700 (PDT)
Message-ID: <4BCD97C8.6090406@rsk.demon.co.uk>
Date: Tue, 20 Apr 2010 13:02:16 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] writeback: tracing and wbc->nr_to_write fixes
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1271731314-5893-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 20/04/10 03:41, Dave Chinner wrote:
> This series contains the initial writeback tracing patches from
> Jens, as well as the extensions I added to provide visibility into
> writeback control structures as the are used by the writeback code.
> The visibility given is sufficient to understand what is happening
> in the writeback path - what path is writing data, what path is
> blocking on congestion, etc, and to determine the differences in
> behaviour for different sync modes and calling contexts. This
> tracing really needs to be integrated into mainline so that anyone
> can improve the tracing as they use it to track down problems
> in our convoluted writeback paths.
> 
> The remaining patches are fixes to problems that the new tracing
> highlighted.
> 

Hi Dave,

Thanks for adding tracing to this, it will be really useful.

The fix to write_cache_pages looks really interesting, I'm going to test
it on my machine. Maybe it should be a separate patch to get more
visibility?

Ext4 also multiplies nr_to_write, so will that need fixing too?

regards
Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
