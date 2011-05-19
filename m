Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4JI5duw047514 for <xfs@oss.sgi.com>; Thu, 19 May 2011 13:05:39 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63D2C1BE42AE
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 11:05:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id y7rzfeUWLcfe5pp1 for
	<xfs@oss.sgi.com>; Thu, 19 May 2011 11:05:38 -0700 (PDT)
Date: Thu, 19 May 2011 14:19:16 -0400
From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v2] xfstests:Make 225 compare map and fiemap at each block.
Message-ID: <20110519181916.GC18123@dhcp231-156.rdu.redhat.com>
References: <1305789665-32743-1-git-send-email-xiaoqiangnk@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1305789665-32743-1-git-send-email-xiaoqiangnk@gmail.com>
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
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org, josef@redhat.com, xfs@oss.sgi.com

On Thu, May 19, 2011 at 03:21:05PM +0800, Yongqiang Yang wrote:
> Due to my carelessness, I induced a ugly patch to ext4's fiemap, but
> 225 could not find it.  So I looked into the 225 and could not figure out
> logic in compare_map_and_fiemap(), which seemed to mix extents with
> blocks.  Then I made 225 compare map and fiemap at each block, the new
> 225 can find another bug in ext4 with 1k block.
> 
> The new 225 works well on ext3, ext4 and xfs with both 1K and 4K block.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
