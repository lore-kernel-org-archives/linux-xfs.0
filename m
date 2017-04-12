Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754940AbdDLQYi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 12:24:38 -0400
Date: Thu, 13 Apr 2017 00:24:25 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH v2] fstests/xfs: xfs_repair should junk empty attribute
 leaf blocks
Message-ID: <20170412162425.GB5081@dhcp12-143.nay.redhat.com>
References: <1492011577-13436-1-git-send-email-zlang@redhat.com>
 <ccc51674-794f-5ff5-0f94-0cfbc953e492@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccc51674-794f-5ff5-0f94-0cfbc953e492@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 11:09:35AM -0500, Eric Sandeen wrote:
> 
> 
> On 4/12/17 10:39 AM, Zorro Lang wrote:
> > +# This repair should junk above leaf attribute and fix this XFS, then
> > +# SCRATCH_DEV shouldn't be corrupted after this case done.
> > +_repair_scratch_fs >> $seqres.full
> > +
> > +echo "Silence is golden"
> > +
> 
> as mentioned on IRC, I don't think you have any validation here.
> 
> If you are running with an xfs_repair that does not find the corruption,
> then neither the repair above nor the post-test xfs_repair -n will
> find any problems, and the test will incorrectly pass.

Sure, you're right, I shouldn't validate the xfs_repair by xfs_repair.
I'll change that.

Thanks,
Zorro

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
