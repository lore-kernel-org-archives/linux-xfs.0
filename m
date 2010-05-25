Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4P3YZ07220744 for <xfs@oss.sgi.com>; Mon, 24 May 2010 22:34:35 -0500
Received: from hrndva-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E57D36C569
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 20:36:57 -0700 (PDT)
Received: from hrndva-omtalb.mail.rr.com (hrndva-omtalb.mail.rr.com
	[71.74.56.123]) by cuda.sgi.com with ESMTP id pCqwKO4lXfqhRDSf
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 20:36:57 -0700 (PDT)
Subject: Re: [PATCH] xfs: convert more trace events to DEFINE_EVENT
From: Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4BFA3815.7070000@cn.fujitsu.com>
References: <4BFA3815.7070000@cn.fujitsu.com>
Date: Mon, 24 May 2010 23:36:54 -0400
Message-ID: <1274758614.22648.205.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Reply-To: rostedt@goodmis.org
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
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Dave Chinner <dchinner@redhat.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

On Mon, 2010-05-24 at 16:25 +0800, Li Zefan wrote:
> Use DECLARE_EVENT_CLASS, and save ~15K:
> 
>    text    data     bss     dec     hex filename
>  171949   43028      48  215025   347f1 fs/xfs/linux-2.6/xfs_trace.o.orig
>  156521   43028      36  199585   30ba1 fs/xfs/linux-2.6/xfs_trace.o
> 
> No change in functionality.
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/xfs/linux-2.6/xfs_trace.h |  356 ++++++++++++++++++++++--------------------
>  1 files changed, 188 insertions(+), 168 deletions(-)
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
