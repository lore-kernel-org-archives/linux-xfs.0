Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAFJ8Pam061623 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 13:08:25 -0600
Date: Tue, 15 Nov 2011 14:08:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfstests 265: add a prealloc and reserve test
Message-ID: <20111115190821.GA15331@infradead.org>
References: <4EB20505.7070005@cn.fujitsu.com> <4EB205CC.6010509@cn.fujitsu.com>
	<20111115182113.GD29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111115182113.GD29840@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, WuBo <wu.bo@cn.fujitsu.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Nov 15, 2011 at 12:21:13PM -0600, Ben Myers wrote:
> Hi Wu Bo,
> 
> On Thu, Nov 03, 2011 at 11:09:00AM +0800, WuBo wrote:
> > This test is for preallocation test. If the disk is full, just with a prealloc
> > file has some free space that prealloc early. We need to check whether the write
> > to the free space is success or not.
> > 
> > Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>
> 
> This test is failing for me because I don't have fallocate installed.  I
> suggest the test could to be changed to check for binaries it uses,
> possibly the version of those binaries, and then not run unless the
> right ones are installed.  But the best I can do right now is make a
> note of it.

It might be even better to just use the xfs_io falloc command as we
generally expect an uptodate xfs_io for use with xfstests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
