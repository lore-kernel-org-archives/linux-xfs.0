Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44506 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752928AbdDLQJl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 12:09:41 -0400
Subject: Re: [PATCH v2] fstests/xfs: xfs_repair should junk empty attribute
 leaf blocks
References: <1492011577-13436-1-git-send-email-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ccc51674-794f-5ff5-0f94-0cfbc953e492@sandeen.net>
Date: Wed, 12 Apr 2017 11:09:35 -0500
MIME-Version: 1.0
In-Reply-To: <1492011577-13436-1-git-send-email-zlang@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org



On 4/12/17 10:39 AM, Zorro Lang wrote:
> +# This repair should junk above leaf attribute and fix this XFS, then
> +# SCRATCH_DEV shouldn't be corrupted after this case done.
> +_repair_scratch_fs >> $seqres.full
> +
> +echo "Silence is golden"
> +

as mentioned on IRC, I don't think you have any validation here.

If you are running with an xfs_repair that does not find the corruption,
then neither the repair above nor the post-test xfs_repair -n will
find any problems, and the test will incorrectly pass.

-Eric
