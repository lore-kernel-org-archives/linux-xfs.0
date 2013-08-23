Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C9A329DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 13:34:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 06C208F8033
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 11:34:35 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id z6apEa9bxFzFbnUm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Aug 2013 11:34:34 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B61C57C0444
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 12:34:33 -0600 (MDT)
Date: Fri, 23 Aug 2013 14:34:31 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests: update _filter_size() for Btrfs
Message-ID: <20130823183431.GG29654@localhost.localdomain>
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
	<1377263233-8903-3-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377263233-8903-3-git-send-email-sbehrens@giantdisaster.de>
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

On Fri, Aug 23, 2013 at 03:07:12PM +0200, Stefan Behrens wrote:
> From: root <root@qvarne.iata>
> 
> The btrfs-progs tools changed the output:
> - 100GiB instead of 100GB
> 
> xfstest btrfs/006 is one that failed due to this change.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

Thank you for this, it was super annoying with the new btrfs-progs breaking
this.

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
