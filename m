Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40352 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbfGSTXO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jul 2019 15:23:14 -0400
Date: Fri, 19 Jul 2019 19:23:11 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 0/9] xfs: stable fixes for v4.19.y - circa ~ v4.19.58
Message-ID: <20190719192311.GP30113@42.do-not-panic.com>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, zlang@redhat.com

On Thu, Jul 18, 2019 at 11:06:08PM +0000, Luis Chamberlain wrote:
> There is a stable bug tracking this, kz#204223 [1], and a respective bug
> also present on upstream via kz#204049 [2] which Zorro reported. But,
> again, nothing changes from the baseline.

The crash is fixed by Brian's commit 6958d11f77d ("xfs: don't trip over
uninitialized buffer on extent read of corrupted inode") merged on v5.1.

As such I'll extend this series to include one more patch.

  Luis
