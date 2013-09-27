Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1D9427F53
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 08:45:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8392AC004
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 06:45:47 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id LCA9tqFHQBDtCAqa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 06:45:46 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7F3CE7C0423
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 07:45:46 -0600 (MDT)
Date: Fri, 27 Sep 2013 09:45:44 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests/btrfs: do not test btrfs/010 with autodefrag
Message-ID: <20130927134544.GI18681@localhost.localdomain>
References: <1379481475-10842-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379481475-10842-1-git-send-email-bo.li.liu@oracle.com>
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

On Wed, Sep 18, 2013 at 01:17:55PM +0800, Liu Bo wrote:
> btrfs/010 is going to create a fragmented file, however, with autodefrag
> this is impossible, so just skip the test when we're with autodefrag.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

I'd rather you just strip out the autodefrag option if it is there and add it
back once the test is done (or hell just remove it, mount, and add it back).
Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
