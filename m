Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8LK7ETB245033 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 15:07:14 -0500
Date: Fri, 21 Sep 2012 15:08:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: 275, Don't remove all the files in SCRATCH_MNT.
Message-ID: <20120921200825.GC1140@sgi.com>
References: <1347620592-3420-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1347620592-3420-1-git-send-email-tm@tao.ma>
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
To: Tao Ma <tm@tao.ma>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Sep 14, 2012 at 07:03:12PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> After the volume is mkfsed, it should have no other files that
> need to be rmed. And what's more, it makes ext4 complain since
> lost+found is also removed.
> 
> So remove this useless "rm -rf $SCRATCH_MNT/*".
> 
> Cc: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Committed to git://oss.sgi.com/xfs/cmds/xfstests.git, master branch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
