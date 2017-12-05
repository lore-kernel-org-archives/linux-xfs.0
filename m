Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752562AbdLEIYI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:24:08 -0500
Date: Tue, 5 Dec 2017 16:24:06 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v7] generic: initial fiemap range query test
Message-ID: <20171205082406.GK2749@eguan.usersys.redhat.com>
References: <1512057927-15022-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512057927-15022-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, sandeen@sandeen.net

On Thu, Nov 30, 2017 at 06:05:27PM +0200, Nikolay Borisov wrote:
> Fiemap gained support for passing in optional offset len
> which denote the range requested, so this patch adds
> testcases for this functionality. Aditionally, a special "ranged"
> argument is added to the require_xfs_io_command which checks
> for the presence of fiemap range support.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> For the time being this test is expected to fail on XFS. 
> 
> V7: 
>  * Adjusted for 64k block size filesystem
>  * Only use/require a test device and not a scratch device

v7 looks good to me, test passes on ppc64 hosts too, thanks!

But it seems that it's not decided yet whether xfs should trim the
ranged fiemap query request, I'd like to see the expected behavior
decided first. (BTW, v7 passes with latest RHEL7 kernel too, seems
extents are not trimmed there.)

Thanks,
Eryu
