Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731354AbfGWWCy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jul 2019 18:02:54 -0400
Date: Tue, 23 Jul 2019 18:02:52 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 0/9] xfs: stable fixes for v4.19.y - circa ~ v4.19.58
Message-ID: <20190723220252.GI1607@sasha-vm>
References: <20190718230617.7439-1-mcgrof@kernel.org>
 <20190719192311.GP30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190719192311.GP30113@42.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, zlang@redhat.com

On Fri, Jul 19, 2019 at 07:23:11PM +0000, Luis Chamberlain wrote:
>On Thu, Jul 18, 2019 at 11:06:08PM +0000, Luis Chamberlain wrote:
>> There is a stable bug tracking this, kz#204223 [1], and a respective bug
>> also present on upstream via kz#204049 [2] which Zorro reported. But,
>> again, nothing changes from the baseline.
>
>The crash is fixed by Brian's commit 6958d11f77d ("xfs: don't trip over
>uninitialized buffer on extent read of corrupted inode") merged on v5.1.
>
>As such I'll extend this series to include one more patch.

I've queued this series up, thanks!

--
Thanks,
Sasha
