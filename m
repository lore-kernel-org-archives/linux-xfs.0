Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0733329DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 13:33:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD3B8304053
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 11:33:41 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id kIV5zTXb2RrLuTCp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Aug 2013 11:33:40 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 254567C0444
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 12:33:40 -0600 (MDT)
Date: Fri, 23 Aug 2013 14:33:38 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstest: fix btrfs/006 for 10+ devices in SCRATCH_DEV_POOL
Message-ID: <20130823183338.GF29654@localhost.localdomain>
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
	<1377263233-8903-4-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377263233-8903-4-git-send-email-sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 23, 2013 at 03:07:13PM +0200, Stefan Behrens wrote:
> One problem was the output of "uniq -c" which added spaces depending
> on the size of the count value (e.g. one space less for 10+ devices).
> 
> The second problem was that "btrfs fi show" was doing the same:
> "devid %4llu size %s used %s path %s".
> 

Got 11 devices together and this works

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
