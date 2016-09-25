Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A0967CA1
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 16:38:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C2D3E8F8052
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 14:38:23 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	as4kHpDGsNl2BiX4 for <xfs@oss.sgi.com>;
	Sun, 25 Sep 2016 14:38:21 -0700 (PDT)
Date: Mon, 26 Sep 2016 07:38:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxcmd: fix counting of xfs entries in fs_table_insert
Message-ID: <20160925213818.GR340@dastard>
References: <1474798162-25960-1-git-send-email-eguan@redhat.com>
	<20160925143155.GB29268@infradead.org>
	<20160925145816.GD27776@eguan.usersys.redhat.com>
	<20160925161256.GA25791@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160925161256.GA25791@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, billodo@redhat.com, Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

On Sun, Sep 25, 2016 at 09:12:56AM -0700, Christoph Hellwig wrote:
> On Sun, Sep 25, 2016 at 10:58:16PM +0800, Eryu Guan wrote:
> > It's already part of xfs/244, I noticed this bug because xfs/244 kept
> > running. I just put the minimum steps in commit log. So I think we're
> > good :)
> 
> But only as part of xfs/244 which doesn't work for v5 file systems.
> To have good coverage we should not rely on testing an old format.
> That beeing said I can't see a good reason for why xfs/244 should not
> be run for v5 file systems, so I'll look into that instead.

It's because it's testing the projid32bit mkfs option works
correctly. i.e. that project IDs > 16 bits fail on a a
filesystem that only supports 16 bit project IDs. v5 filesystems
only support 32 bit project IDs, so setting a > 16bit ID will
succeed, not fail like the test is expecting.

A new test would be simplest.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
