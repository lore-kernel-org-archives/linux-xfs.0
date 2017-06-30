Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751696AbdF3DoH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 23:44:07 -0400
Date: Fri, 30 Jun 2017 11:44:05 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] tests/xfs: test for log recovery failure after tail
 overwrite
Message-ID: <20170630034405.GX23360@eguan.usersys.redhat.com>
References: <1497631473-14278-1-git-send-email-bfoster@redhat.com>
 <1497631579-14454-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497631579-14454-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi Brian,

On Fri, Jun 16, 2017 at 12:46:19PM -0400, Brian Foster wrote:
> XFS is susceptible to log recovery problems if the fs crashes under
> certain circumstances. If the tail has been pinned for long enough
> to the log to fill and the next batch of log buffer submissions
> happen to fail, the filesystem shutsdown having potentially
> overwritten part of the range between the last good tail->head range
> in the log. This causes log recovery to fail with crc mismatch or
> invalid log record errors.
> 
> This problem is not yet fixed and thus known/expected to fail. At
> this time, this test serves as a reminder that the problem exists
> and a reproducer for future verification purposes. Note that this
> problem is currently only reproducible with larger (non-default) log
> buffer sizes (i.e., '-o logbsize=256k') or smaller block sizes (1k).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This patch uses the XFS debug kernel mechanism recently posted for
> review[1] to reproduce an XFS log recovery problem. Note that this test
> depends on the aforementioned patch and thus should not be merged
> until/unless the corresponding kernel patch is merged.

Any decision made on the kernel side patch? Sorry, I'm a bit lost on the
kernel side discussions.

Thanks,
Eryu
