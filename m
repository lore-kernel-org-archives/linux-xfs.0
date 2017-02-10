Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751377AbdBJHPZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Feb 2017 02:15:25 -0500
Date: Fri, 10 Feb 2017 15:15:19 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/3] xfs: restore and enhance xfs indlen test
Message-ID: <20170210071519.GB21408@eguan.usersys.redhat.com>
References: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Feb 09, 2017 at 02:43:41PM -0500, Brian Foster wrote:
> Hi all,
> 
> This series is associated with the "buffered write and indlen fixes"
> series recently posted to the XFS list. These patches move the original
> test to the XFS directory as it now depends on an XFS-specific
> mechanism, restore the effectiveness of the original test, and finally
> enhance the test to reproduce the newly identified problems fixed by the
> kernel patches. Thoughts, reviews, flames appreciated.

I think it's still worth keeping the original fzero tests in generic, as
a generic function/regression test, though it's not effective to
reproduce the original bug. And maybe it's still working and effective
on some distro kernels? How about just adding a new test for XFS?

Thanks,
Eryu
