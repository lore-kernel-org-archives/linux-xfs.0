Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4AB7E7CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 13:13:49 -0500 (CDT)
Date: Tue, 30 Jul 2013 13:13:45 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 7/9] xfs: WQ_NON_REENTRANT is meaningless and going away
Message-ID: <20130730181345.GO3111@sgi.com>
References: <1375188028-11910-1-git-send-email-tj@kernel.org>
	<1375188028-11910-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1375188028-11910-8-git-send-email-tj@kernel.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: xfs@oss.sgi.com, Alex Elder <elder@kernel.org>, shli@kernel.org, linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com


On Tue, Jul 30, 2013 at 08:40:26AM -0400, Tejun Heo wrote:
> Hello,
> 
> Please route this through the subsystem tree.  As written in the
> description, this shouldn't make any functional difference and just
> prepares for the removal of WQ_NON_REENTRANT which is already noop.
> 
> Thanks.
>
> ------ 8< -------
> dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
> WQ_NON_REENTRANT no-op and the flag is going away.  Remove its usages.
> 
> This patch doesn't introduce any behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: xfs@oss.sgi.com

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
