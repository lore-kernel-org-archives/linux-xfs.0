Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2DBYWF131051 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 08:11:34 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	k8tLjmhgf16x2A1F (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 06:13:27 -0700 (PDT)
Date: Fri, 2 Nov 2012 09:13:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: fix buffer shudown reference count mismatch
Message-ID: <20121102131326.GG12578@infradead.org>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-6-git-send-email-david@fromorbit.com>
	<20121102024351.GU29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121102024351.GU29378@dastard>
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
Cc: xfs@oss.sgi.com

> The fix that I've done here means all buffers going through this
> path will take an extra reference, but that reference is only
> dropped on async buffers. Because all the buffers are markd stale,
> they are removed from the LRU, and so xfs_buftarg_wait() during
> unmount does not find them and hence the remaining reference is
> never removed. Hence the perag reference still remains, and we
> assert fail there.
> 
> Solution seems simple - set the XBF_ASYNC flag on all buffers so
> that the last reference is taken away correctly. Testing that now.

I don't like this.  ioend processing is very different for synchrous
writes, with the most important difference being that synchronous
writes need to wake the submitter at I/O completion.  From all I can
see your v2 patch breaks that beahviour.  For 3.7-rc I'd suggest
taking the additional reference conditionally.

For 3.8 I'm going to look into simply acquiring an additional reference
for synchronous writes during I/O submission to kill these special cases
all over the buffer code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
