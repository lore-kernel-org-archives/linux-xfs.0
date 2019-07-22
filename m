Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbfGVOfc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Jul 2019 10:35:32 -0400
Date: Mon, 22 Jul 2019 10:35:31 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] xfs: don't trip over uninitialized buffer on extent read
 of corrupted inode
Message-ID: <20190722143531.GG1607@sasha-vm>
References: <20190718230617.7439-1-mcgrof>
 <20190719193032.11096-1-mcgrof@kernel.org>
 <20190719212300.GQ30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190719212300.GQ30113@42.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, zlang@redhat.com, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On Fri, Jul 19, 2019 at 09:23:00PM +0000, Luis Chamberlain wrote:
>On Fri, Jul 19, 2019 at 07:30:32PM +0000, Luis Chamberlain wrote:
>> From: Brian Foster <bfoster@redhat.com>
>> [mcgrof: fixes kz#204223 ]
>
>Sorry, spoke too soon, although it helps... it actually still does not
>fix that exact issue. Fixing this will require a bit more work. You can
>ignore this patch for stable for now.

What about the other 9 patch series?

--
Thanks,
Sasha
