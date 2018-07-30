Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45576 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbeG3Rjk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 13:39:40 -0400
Subject: Re: [PATCH v2] xfs: add debian initramfs hook to package
References: <20180726215154.GI30972@magnolia>
 <20180728183636.GS30972@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8af61508-6a73-67a7-bb9d-b1c4b0c9b01a@sandeen.net>
Date: Mon, 30 Jul 2018 11:04:01 -0500
MIME-Version: 1.0
In-Reply-To: <20180728183636.GS30972@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, billodo@redhat.com



On 7/28/18 1:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In Debian bug 904086, the reporter complained that xfs_repair wasn't
> present in the initramfs, which prevented him from using shutdown -F to
> force a filesystem fsck after a reboot.  Add a hook to put the xfs
> utilities in the initramfs if xfs is the root filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

