Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE09F7F50
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 09:38:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80E218F804C
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 07:38:08 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gI4lU1osuBNCOuLH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 07:38:07 -0800 (PST)
Date: Fri, 22 Nov 2013 07:38:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: integrate xfs_quota_priv header file to xfs_qm
Message-ID: <20131122153807.GC15143@infradead.org>
References: <528E188C.6070208@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528E188C.6070208@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Nov 21, 2013 at 10:28:28PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> The xfs_quota_priv header file is only included by xfs_qm header and
> there is no much users for its contents, hence we can move those stuff
> to xfs_qm header file and kill it.
> 
> This patch also remove an unused macro DQFLAGTO_TYPESTR.

Looks like you pasted the remaining defintions twice into the new
location.

Except for that looks fine to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
