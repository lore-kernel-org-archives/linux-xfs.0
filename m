Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 08:54:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m61FsK10015547
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 08:54:20 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2BE82A4DF4
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 08:55:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id o2aCQAMFSN3UPp2K for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 08:55:23 -0700 (PDT)
Date: Tue, 1 Jul 2008 11:55:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: grub fails boot after update
Message-ID: <20080701155522.GA29722@infradead.org>
References: <alpine.LNX.1.10.0807011712470.20393@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0807011712470.20393@fbirervta.pbzchgretzou.qr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com


sync works perfectly fine on xfs.  Grub just doesn't understand what
sync means, and because of that it's buggy on all filesystems, just
with less a chance on others.   The fix is pretty simple and that is
stopping to try to access the filesystem with it's own driver through
the block device node.
