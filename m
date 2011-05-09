Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p49EIm5J012964 for <xfs@oss.sgi.com>; Mon, 9 May 2011 09:18:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F59CC68B9C
	for <xfs@oss.sgi.com>; Mon,  9 May 2011 07:18:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8wNoKp7LLuMMBXq3 for
	<xfs@oss.sgi.com>; Mon, 09 May 2011 07:18:47 -0700 (PDT)
Date: Mon, 9 May 2011 10:18:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: __write_lock_failed
Message-ID: <20110509141846.GG12262@infradead.org>
References: <4DC3E566.8070601@lrz.uni-muenchen.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DC3E566.8070601@lrz.uni-muenchen.de>
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
To: stefanx <stefanx@lrz.uni-muenchen.de>
Cc: xfs@oss.sgi.com

On Fri, May 06, 2011 at 02:11:18PM +0200, stefanx wrote:
> 
> Hello,
> 
> some of my virtual machines (kvm/qemu) sometimes crash (xfs, Ubuntu 10.04, 2.6.32-31-x86_64).
> I think it happens while taking LVM-snapshots from the XFS-Filesystem of that machines:

This area has gotten a lot of changes since 2.6.32, including removing
the lock that's causing softlockups for you.  I don't think there's much
of a chance for help with a kernel that old as people's minds have moved
on to much more recent codebases.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
