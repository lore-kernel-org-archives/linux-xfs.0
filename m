Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F10A37F37
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2015 10:07:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E140D304039
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2015 08:07:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gBtHeuxpflLYeJg7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2015 08:07:27 -0800 (PST)
Date: Tue, 24 Nov 2015 08:07:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: fix race aio-dio vs freeze_fs
Message-ID: <20151124160723.GA17466@infradead.org>
References: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
	<20151124132421.GG25232@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151124132421.GG25232@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, tytso@mit.edu, xfs@oss.sgi.com

On Tue, Nov 24, 2015 at 02:24:21PM +0100, Jan Kara wrote:
> Well, this problem seems to suggest that we have the freeze protection for
> AIO writes wrong. We should call file_end_write() from aio_complete() and
> not from aio_run_iocb()... I believe XFS and other filesystems may have
> problems with this as well (CCed). Attached patch (so far only compile
> tested since my test machine is pondering on something else) should fix
> this.

Sounds like one way to do it, but we'd really want a vfs_* helper for
this so that it doesn't have to duplicated in other write_iter users
like the loop driver, which seems to be missing file
file_start_write/file_end_write entirely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
