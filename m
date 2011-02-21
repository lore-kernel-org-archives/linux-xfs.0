Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1LChtOX149883 for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 06:43:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E059112B5D49
	for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 04:46:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yeumd6oxBuvlPbuO for
	<xfs@oss.sgi.com>; Mon, 21 Feb 2011 04:46:38 -0800 (PST)
Date: Mon, 21 Feb 2011 07:46:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
Message-ID: <20110221124635.GA5525@infradead.org>
References: <4D6221B8.9040303@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D6221B8.9040303@gmail.com>
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
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, cluster-devel@redhat.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Mon, Feb 21, 2011 at 09:26:32AM +0100, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> All fs must check for the immutable flag in their fallocate callback.
> It's possible to have a race condition in this scenario: an application
> open a file in read/write and it does something, meanwhile root set the
> immutable flag on the file, the application at that point can call
> fallocate with success. Only Ocfs2 check for the immutable flag at the
> moment.

Please add the check in fs/open.c:do_fallocate() so that it covers all
filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
