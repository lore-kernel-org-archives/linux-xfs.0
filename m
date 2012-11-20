Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKFT9Wj184465 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 09:29:09 -0600
Message-ID: <50ABA245.8070404@sgi.com>
Date: Tue, 20 Nov 2012 09:31:17 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 2/2 V3] xfstests: xfs_tosspages() test addition
References: <20121108222315.505370321@sgi.com>
	<20121108222315.709683665@sgi.com>
	<20121108232726.GV6434@dastard> <50A19EC0.4040405@sgi.com>
	<50A3DC58.4080704@sgi.com> <50A3E46E.9040508@sgi.com>
	<50A3E99F.8070303@sgi.com>
In-Reply-To: <50A3E99F.8070303@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrew Dahl <adahl@sgi.com>
Cc: xfs@oss.sgi.com

On 11/14/12 12:57, Andrew Dahl wrote:
>
> Tests the XFS_IOC_ZERO_RANGE ioctl by way of the "xfs_io zero" utility
> to ensure it is tossing the expected ranges.
>
> The ranges tested are [0,1] [0,4095] [0,4096] [0,4097] [4095,8191]
>    [4095,8192] [4095,8193] [4096,8192] [1024,4096]
>
> Signed-off-by: Andrew Dahl<adahl@sgi.com>

This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests 
master branch, commit 82846 (test 290).

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
