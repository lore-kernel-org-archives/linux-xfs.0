Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E3A47F4E
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 08:17:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C3FB304059
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 06:17:50 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id I2C5HPUA1cb4ZpUN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Sep 2013 06:17:49 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 393199A03DC
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 07:17:49 -0600 (MDT)
Date: Mon, 23 Sep 2013 09:17:46 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstest/btrfs/001: fix the misuse of subvolume set-default
Message-ID: <20130923131746.GA18681@localhost.localdomain>
References: <1379926049-22135-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379926049-22135-1-git-send-email-bo.li.liu@oracle.com>
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
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 23, 2013 at 04:47:29PM +0800, Liu Bo wrote:
> The command is
> btrfs subvolume set-default <subvolid> <path>.
> 
> It uses @subvolid to control the default subvolume and
> @subvolid=0 has always been parsed into FS_TREE no matter
> what subvolume @path points to.
> 
> So in order to set a subvolume to the default one, we need
> to get the id of this subvolume first.
> 
> Also fix a typo:
> s/sbuvolid/subvolid/g
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Sent a patch for this already.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
