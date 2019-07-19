Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46787 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728747AbfGSXHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jul 2019 19:07:32 -0400
Date: Fri, 19 Jul 2019 23:07:29 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: don't trip over uninitialized buffer on extent read
 of corrupted inode
Message-ID: <20190719230729.GS19023@42.do-not-panic.com>
References: <20190718230617.7439-1-mcgrof>
 <20190719193032.11096-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719193032.11096-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, zlang@redhat.com, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On Fri, Jul 19, 2019 at 07:30:32PM +0000, Luis Chamberlain wrote:
> [mcgrof: fixes kz#204223 ]

This patch can be ingored for now for stable. It does not actually
fix the issue, just delays it a bit. Once I stress test over 1000
runs with some other fixes I have I'll send a new set of stable
fixes.

  Luis
