Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38C9F7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 13:43:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA086AC001
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 11:43:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Wnptv1ONZzvlB3OY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 11:43:04 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: vfs/xfs: directio updates to ease COW handling V2
References: <1454524816-11392-1-git-send-email-hch@lst.de>
Date: Wed, 03 Feb 2016 14:43:02 -0500
In-Reply-To: <1454524816-11392-1-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Wed, 3 Feb 2016 19:40:13 +0100")
Message-ID: <x49zivhy3zt.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

Hi, Christoph,

Can you explain a bit what you mean by easing COW handling?  Whenever I
see COW referenced near DIO, my mind always turns to g_u_p vs. fork.

Thanks!
Jeff

Christoph Hellwig <hch@lst.de> writes:

> See http://www.infradead.org/rpr.html
>
> The first patch ensures ->end_io is always called for direct I/O requests
> that pass it in, even if there was a zero length write, or if an error
> occured.  The existing users have been updated to ignore it, but XFS
> will make use of it in the future, and a comment in ext4 suggests it
> might be useful for it as well.
>
> The other two simplify the XFS direct I/O code.
>
> Changes since V1:
>  - allow ->end_io to return errors
>  - a comment spelling fix
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
