Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753549AbdLOIlO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Dec 2017 03:41:14 -0500
Date: Fri, 15 Dec 2017 16:41:12 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v7] generic: initial fiemap range query test
Message-ID: <20171215084112.GK2749@eguan.usersys.redhat.com>
References: <1512057927-15022-1-git-send-email-nborisov@suse.com>
 <e0093be7-fbbc-de22-4dd1-429e9f1734d0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0093be7-fbbc-de22-4dd1-429e9f1734d0@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, sandeen@sandeen.net

On Fri, Dec 15, 2017 at 10:33:16AM +0200, Nikolay Borisov wrote:
> 
> 
> On 30.11.2017 18:05, Nikolay Borisov wrote:
> > Fiemap gained support for passing in optional offset len
> > which denote the range requested, so this patch adds
> > testcases for this functionality. Aditionally, a special "ranged"
> > argument is added to the require_xfs_io_command which checks
> > for the presence of fiemap range support.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> SO what's the final verdit, even though to be honest I got a bit annoyed
> at the way the whole situation with fiemap untangled and dunno if I have
> the willpower to make any more adjustments to this test.

I tend to take the patch as-is for now, and let it fail on XFS with the
hope that the failure will drive further discussions and fixes on the
test or kernel when we have a final conclusion.

Please let me know if I should drop the patch.

Thanks,
Eryu
