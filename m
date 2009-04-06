Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n36HdHkY181222 for <xfs@oss.sgi.com>; Mon, 6 Apr 2009 12:39:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F0711F17D6
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2009 10:38:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AW6JgA8uxm3llbHz for
	<xfs@oss.sgi.com>; Mon, 06 Apr 2009 10:38:57 -0700 (PDT)
Date: Mon, 6 Apr 2009 13:38:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: why xfs_write() race with O_DIRECT only?
Message-ID: <20090406173846.GA30403@infradead.org>
References: <49CD7912.6080508@GreenKey.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49CD7912.6080508@GreenKey.net>
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
To: Curtis Doty <Curtis@greenkey.net>
Cc: XFS <xfs@oss.sgi.com>

On Fri, Mar 27, 2009 at 06:10:42PM -0700, Curtis Doty wrote:
> I'm guessing this is the race fixed in 2.6.29.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=25051158
> 
> But my app is running O_DIRECT and only calls pwrite(). Is there
> something I'm missing that explains the aio stuff etc.?

The aboe patch only matters when using dmapi.  Can you send a simple
sample program or other kind of testcases that reproduces the bug that
you see?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
