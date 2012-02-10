Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1AG9RJK006643 for <xfs@oss.sgi.com>; Fri, 10 Feb 2012 10:09:27 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HrGgTadwPrVWhVhy for
	<xfs@oss.sgi.com>; Fri, 10 Feb 2012 08:09:26 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/4] Generic O_SYNC AIO DIO handling
References: <1328889842-23231-1-git-send-email-jack@suse.cz>
Date: Fri, 10 Feb 2012 11:09:09 -0500
In-Reply-To: <1328889842-23231-1-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Fri, 10 Feb 2012 17:03:58 +0100")
Message-ID: <x49aa4qpt5m.fsf@segfault.boston.devel.redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: cluster-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

Jan Kara <jack@suse.cz> writes:

>   Hi Jeff,
>
>   these patches implement generic way of handling O_SYNC AIO DIO. They work
> for all filesystems except for ext4 and xfs. Thus together with your patches,
> all filesystems should handle O_SYNC AIO DIO correctly. I've tested ext3,
> btrfs, and xfs (to check that I didn't break anything when the generic code
> is unused) and things seem to work fine. Will you add these patches to your
> series please? Thanks.

Thanks, Jan!  I'll add them in and give them some testing.  I should be
ready to repost the series early next week.

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
