Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBV9ZJ9V117811 for <xfs@oss.sgi.com>; Thu, 31 Dec 2009 03:35:19 -0600
Date: Thu, 31 Dec 2009 04:36:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Convert some trace events to DEFINE_TRACE
Message-ID: <20091231093604.GA29917@infradead.org>
References: <4B3C64D4.3060706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B3C64D4.3060706@cn.fujitsu.com>
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
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>, Ingo Molnar <mingo@elte.hu>

On Thu, Dec 31, 2009 at 04:46:12PM +0800, Li Zefan wrote:
> Use DECLARE_EVENT_CLASS/DEFINE_EVENT to remove duplicate code:
> 
>    text    data     bss     dec     hex filename
>  871963   35416    3612  910991   de68f fs/xfs/xfs.o.orig
>  575027   35416    3404  613847   95dd7 fs/xfs/xfs.o
> 
> To test this patch, I compared the format files of trace events,
> before and after patching:

I already sent this patch a long time ago, still waiting for Alex to
pick it up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
