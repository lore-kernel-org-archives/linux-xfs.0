Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0658E7CA0
	for <xfs@oss.sgi.com>; Sun, 17 Apr 2016 03:47:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B31C98F8033
	for <xfs@oss.sgi.com>; Sun, 17 Apr 2016 01:47:13 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id wfB5xUtQcow00EqB (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 17 Apr 2016 01:47:06 -0700 (PDT)
Subject: Re: [PATCH 41/42] block: do not use REQ_FLUSH for tracking flush
	support
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
	<1460747777-8479-42-git-send-email-mchristi@redhat.com>
From: Juergen Gross <kernel@pfupf.net>
Message-ID: <57134D83.8020309@pfupf.net>
Date: Sun, 17 Apr 2016 10:46:59 +0200
MIME-Version: 1.0
In-Reply-To: <1460747777-8479-42-git-send-email-mchristi@redhat.com>
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
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On 15/04/16 21:16, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> The last patch added a REQ_OP_FLUSH for request_fn drivers
> and the next patch renames REQ_FLUSH to REQ_PREFLUSH which
> will be used by file systems and make_request_fn drivers so
> they can send a write/flush combo.
> 
> This patch drops xen's use of REQ_FLUSH to track if it supports
> REQ_OP_FLUSH requests, so REQ_FLUSH can be deleted.
> 
> v7:
> - Fix feature_flush/fua use.
> 
> v6:
> - Dropped parts of patch handled by Jens's QUEUE_FLAG_WC/FUA
> patches and modified patch to check feature_flush/fua bits.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Cc: Juergen Gross <kernel@pfupf.net>

Acked-by: Juergen Gross <jgross@suse.com>


Juergen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
