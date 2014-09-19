Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFC777F3F
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 10:02:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8D9B0AC006
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 08:02:47 -0700 (PDT)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id Ee9bHBlwGCQUGlhD
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 08:02:43 -0700 (PDT)
Message-ID: <541C458E.3080406@fb.com>
Date: Fri, 19 Sep 2014 11:02:38 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: remove check_scratch_fs in btrfs/012
References: <1409714759-9805-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1409714759-9805-1-git-send-email-bo.li.liu@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Liu Bo <bo.li.liu@oracle.com>, xfs@oss.sgi.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>

On 09/02/2014 11:25 PM, Liu Bo wrote:
> From: Liu Bo <liub.liubo@gmail.com>
>
> btrfs/012 is a case to verify btrfs-convert feature, it converts an ext4 to
> btrfs firstly and do something, then rolls back to ext4.
>
> So at last we have a ext4 on the scratch device, but setting _require_scratch
> will force a btrfsck on a ext4 fs because $FSTYP here is btrfs, and it ends up
> with a failure report of _check_btrfs_filesystem.
>
> Now that we have deliberately check the final ext4 fs in btrfs/012, just do not
> set _require_scratch in this case.
>
> Signed-off-by: Liu Bo <liub.liubo@gmail.com>

I sent a patch for this already, it's on the fs-tests list.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
