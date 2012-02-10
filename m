Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1AMNA5w025696 for <xfs@oss.sgi.com>; Fri, 10 Feb 2012 16:23:10 -0600
Message-ID: <4F3598CB.2060008@sgi.com>
Date: Fri, 10 Feb 2012 16:23:07 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH -v2 3/3] xfs: cleanup quota check on disk blocks and inodes
	reservations
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
	<20120206125105.12624.93123.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20120206125105.12624.93123.stgit@ltc219.sdl.hitachi.co.jp>
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
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com, xfs@oss.sgi.com

On 02/06/12 06:51, Mitsuo Hayasaka wrote:
> This patch is a cleanup of quota check on disk blocks and inodes
> reservations, and changes it as follows.
>
> (1) add a total_count variable to store the total number of
>      current usages and new reservations for disk blocks and inodes,
>      respectively.
>
> (2) make it more readable to check if the local variables softlimit
>      and hardlimit are positive. It has been changed as follows.
> 	    if (softlimit>  0ULL) ->  if (softlimit)
> 	    if (hardlimit>  0ULL) ->  if (hardlimit)
>      This is because they are defined as xfs_qcnt_t which is unsigned.
>
> Signed-off-by: Mitsuo Hayasaka<mitsuo.hayasaka.hu@hitachi.com>


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
