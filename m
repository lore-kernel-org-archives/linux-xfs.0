Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2QF5cKq057089 for <xfs@oss.sgi.com>; Sat, 26 Mar 2011 10:05:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C56737E537
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2011 08:08:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3kzLnFrnsi85lQOb for
	<xfs@oss.sgi.com>; Sat, 26 Mar 2011 08:08:46 -0700 (PDT)
Date: Sat, 26 Mar 2011 11:08:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: No space left on device on xfs filesystem with 7.7TB free
Message-ID: <20110326150845.GA14334@infradead.org>
References: <AANLkTingRg24yJJ6Dk=KpDywtY9LrXL_jV0KWaCR-8KU@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTingRg24yJJ6Dk=KpDywtY9LrXL_jV0KWaCR-8KU@mail.gmail.com>
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
To: atyu30 atyu30 <ipostfix@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Mar 26, 2011 at 09:41:15PM +0800, atyu30 atyu30 wrote:
> I'm running RedHat Linux Enterprise Server 5.2, on a 64-bit x86_64 Linux
> machine with kernel version 2.6.18-128.el5 smp.  I appear to have version
> 2.9.4 of xfsprogs.

RHEL5.2 does not include XFS support, so you must have gotten an
unssuported module from somewhere.  If you need to use XFS with
RHEL upgrade to a version that officially supports it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
