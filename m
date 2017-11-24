Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdKXFNy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Nov 2017 00:13:54 -0500
Date: Fri, 24 Nov 2017 13:13:52 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v6] generic: initial fiemap range query test
Message-ID: <20171124051352.GZ2749@eguan.usersys.redhat.com>
References: <1511439214-8400-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511439214-8400-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, sandeen@sandeen.net

On Thu, Nov 23, 2017 at 02:13:34PM +0200, Nikolay Borisov wrote:
> Fiemap gained support for passing in optional offset len
> which denote the range requested, so this patch adds
> testcases for this functionality. Aditionally, a special "ranged"
> argument is added to the require_xfs_io_command which checks
> for the presence of fiemap range support.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> --- 
>  V6:
>  * Moved to generic tests and successfully ran against ext4/btrfs
>  * Use pwrite to create the holes to make it even more generic
>  467 auto quick exportfs
...
>  468 shutdown auto quick metadata
>  469 auto quick
> +900

I added 'auto quick' group to it. Otherwise test looks good to me, it
currently fails with xfs and passes with ext3/4/btrfs.

Thanks,
Eryu
