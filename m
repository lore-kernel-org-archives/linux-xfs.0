Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o947FFYL050788 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 02:15:16 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2AAE1501100
	for <xfs@oss.sgi.com>; Mon,  4 Oct 2010 00:29:48 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	a3kY3F7mKZC0rZlh for <xfs@oss.sgi.com>;
	Mon, 04 Oct 2010 00:29:48 -0700 (PDT)
Date: Mon, 4 Oct 2010 18:16:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair never finishes on lvm partition
Message-ID: <20101004071613.GG4681@dastard>
References: <AANLkTinH93VekNiAEbJbp43xnG2QPgnr+70nvC771ifG@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTinH93VekNiAEbJbp43xnG2QPgnr+70nvC771ifG@mail.gmail.com>
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
To: Knowledge Seeker <knoseeker@googlemail.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 04, 2010 at 02:57:42AM +0000, Knowledge Seeker wrote:
> Extra information:
> The versions:
> # xfs_repair -V
> xfs_repair version 2.9.8

upgrade to a more recent version - that is positively ancient ;)

Then if it still freezes in pahse 6, run with the -P option to turn
off prefetching (slower, but should prevent the hang).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
