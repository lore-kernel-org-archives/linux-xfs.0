Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAFIKwsP058343 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 12:20:58 -0600
Date: Tue, 15 Nov 2011 12:21:13 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/3] xfstests 265: add a prealloc and reserve test
Message-ID: <20111115182113.GD29840@sgi.com>
References: <4EB20505.7070005@cn.fujitsu.com> <4EB205CC.6010509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EB205CC.6010509@cn.fujitsu.com>
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
To: WuBo <wu.bo@cn.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

Hi Wu Bo,

On Thu, Nov 03, 2011 at 11:09:00AM +0800, WuBo wrote:
> This test is for preallocation test. If the disk is full, just with a prealloc
> file has some free space that prealloc early. We need to check whether the write
> to the free space is success or not.
> 
> Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>

This test is failing for me because I don't have fallocate installed.  I
suggest the test could to be changed to check for binaries it uses,
possibly the version of those binaries, and then not run unless the
right ones are installed.  But the best I can do right now is make a
note of it.

Just a heads up.  ;)

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
