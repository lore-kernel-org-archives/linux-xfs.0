Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA23B7F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 10:37:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A60E18F804C
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 08:37:14 -0800 (PST)
Received: from mail-qg0-f66.google.com (mail-qg0-f66.google.com
	[209.85.192.66]) by cuda.sgi.com with ESMTP id QFJgAyfpmydqElJD
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 08:37:12 -0800 (PST)
Received: by mail-qg0-f66.google.com with SMTP id 94so3192257qgt.1
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 08:37:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451886892-15548-4-git-send-email-david@fromorbit.com>
References: <1451886892-15548-1-git-send-email-david@fromorbit.com>
	<1451886892-15548-4-git-send-email-david@fromorbit.com>
Date: Thu, 21 Jan 2016 08:37:11 -0800
Message-ID: <CAA9_cmdAYzf3DpjPRZWikNgmJT_sdDACXa_znz6j0oqmmRdLOA@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: introduce per-inode DAX enablement
From: Dan Williams <dan.j.williams@intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, ext4@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jan 3, 2016 at 9:54 PM, Dave Chinner <david@fromorbit.com> wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Rather than just being able to turn DAX on and off via a mount
> option, some applications may only want to enable DAX for certain
> performance critical files in a filesystem.
>
> This patch introduces a new inode flag to enable DAX in the v3 inode
> di_flags2 field. It adds support for setting and clearing flags in
> the di_flags2 field via the XFS_IOC_FSSETXATTR ioctl, and sets the
> S_DAX inode flag appropriately when it is seen.
>
> When this flag is set on a directory, it acts as an "inherit flag".
> That is, inodes created in the directory will automatically inherit
> the on-disk inode DAX flag, enabling administrators to set up
> directory heirarchies that automatically use DAX. Setting this flag
> on an empty root directory will make the entire filesystem use DAX
> by default.

When switching from page-cache to DAX, don't we need to flush existing
page cache mappings and remap directly?  Or, is the thought that
userspace needs to comprehend the presence of mixed mappings after
changing S_DAX?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
