Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q69FIYpv240252 for <xfs@oss.sgi.com>; Mon, 9 Jul 2012 10:18:34 -0500
Message-ID: <4FFAF649.8040504@sgi.com>
Date: Mon, 09 Jul 2012 10:18:33 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: improve test 286 for repeated unwritten/hole
	extents.
References: <4FF31296.8050406@oracle.com>
In-Reply-To: <4FF31296.8050406@oracle.com>
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
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com

On 07/03/12 10:41, Jeff Liu wrote:
> v2->v1.
> * Drop the diff of seq.full.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---
>   286 |   87
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 files changed, 86 insertions(+), 1 deletions(-)

Looks good. I also perforned a xfs_bmap on the source and destination 
files to see the portions that were being detected and copied as data.


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
