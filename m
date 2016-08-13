Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3F3627CA0
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 01:51:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B013DAC002
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 23:50:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TnLU2nT6sKxHRzDS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Aug 2016 23:50:58 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 0F63467325
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 06:50:58 +0000 (UTC)
Date: Sat, 13 Aug 2016 14:50:56 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: XFS: Assertion failed: bp->b_flags & XBF_ASYNC, file:
	fs/xfs/xfs_buf.c, line: 118 on 4.8-rc1 kernel
Message-ID: <20160813065056.GX27776@eguan.usersys.redhat.com>
References: <20160812140414.GV27776@eguan.usersys.redhat.com>
	<20160812144752.GW27776@eguan.usersys.redhat.com>
	<20160812170714.GA64450@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160812170714.GA64450@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 12, 2016 at 01:07:15PM -0400, Brian Foster wrote:
> On Fri, Aug 12, 2016 at 10:47:52PM +0800, Eryu Guan wrote:
> > On Fri, Aug 12, 2016 at 10:04:14PM +0800, Eryu Guan wrote:
> > > Hi,
> > > 
> > > I hit oops while building kernel on XFS, 4.8-rc1 kernel, hit twice in
> > > six kernel builds. I'm not sure if it's a regression since 4.7 kernel
> > > yet, will do more testings.
> > 
> > Just hit again on 4.8-rc1 kernel, I was doing
> > 
> > # clean partial builds from previous run and build again
> > make clean
> > make -j 8
> > 
> > Seems I have to do kernel build on 4.7 kernel to finish the bisect.
> > 
> > Thanks,
> > Eryu
> > 
> > [ 2515.752039] XFS: Assertion failed: bp->b_flags & XBF_ASYNC, file: fs/xfs/xfs_buf.c, line: 118
> 
> This is commit 9c7504aa7 ("xfs: track and serialize in-flight async
> buffers against unmount"). The assert is actually incorrect, as Dave had
> previously pointed out[1]. A patch was posted[2] to fix it, but hasn't
> been merged yet.
> 
> Brian
> 
> [1] http://oss.sgi.com/pipermail/xfs/2016-August/050613.html
> [2] http://oss.sgi.com/pipermail/xfs/2016-August/050634.html

Thanks for the reminder, I had impression of this thread and patch, but
didn't realize I was hitting the same problem. I don't have to do bisect
then :)

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
