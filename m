Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Nov 2006 15:04:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kACN3taG025962
	for <xfs@oss.sgi.com>; Sun, 12 Nov 2006 15:03:57 -0800
Message-ID: <4557A823.6070609@sgi.com>
Date: Mon, 13 Nov 2006 10:02:59 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS Update for 2.6.19 - take 2
References: <E3D44718E107CCFE3EE40746@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <E3D44718E107CCFE3EE40746@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-dev <xfs-dev@corp.sgi.com>, xfs@oss.sgi.com

I don't know what I have done wrong but some of the patches bellow signed
by me a actually patches from the comunity that I just have verified and
checked in our XFS source management system. I guess, I didn't clearly 
identified
the real authors of the fixes (although I think I put their names when I 
checked in
the patch).

Vlad

Timothy Shimmin wrote:
>
>
> commit 93c189c1148a5e39bcc8f62568f42a77f93477c5
> Author: Vlad Apostolov <vapo@sgi.com>
> Date: Sat Nov 11 18:03:49 2006 +1100
>
> [XFS] 956618: Linux crashes on boot with XFS-DMAPI filesystem when
> CONFIG_XFS_TRACE is on
>
> SGI-PV: 956618
> SGI-Modid: xfs-linux-melb:xfs-kern:27196a
>
> Signed-off-by: Vlad Apostolov <vapo@sgi.com>
> Signed-off-by: Tim Shimmin <tes@sgi.com>
>
>
> commit 439b8434792d0b62e32ab1416f214a18a640cc03
> Author: Tim Shimmin <tes@sgi.com>
> Date: Sat Nov 11 18:04:34 2006 +1100
>
> [XFS] Keep lockdep happy.
>
> SGI-PV: 956964
> SGI-Modid: xfs-linux-melb:xfs-kern:27200a
>
> Signed-off-by: Tim Shimmin <tes@sgi.com>
> Signed-off-by: David Chinner <dgc@sgi.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>
>
> commit 70a505285f9859f77e07f7c12371b0d29ecf3d82
> Author: Vlad Apostolov <vapo@sgi.com>
> Date: Sat Nov 11 18:04:41 2006 +1100
>
> [XFS] rename uio_read() to xfs_uio_read()
>
> SGI-PV: 957004
> SGI-Modid: xfs-linux-melb:xfs-kern:27231a
>
> Signed-off-by: Vlad Apostolov <vapo@sgi.com>
> Signed-off-by: Tim Shimmin <tes@sgi.com>
>
>
> commit 2e2e7bb1fd857b9fc83b0cd77b6b647ebb423301
> Author: Vlad Apostolov <vapo@sgi.com>
> Date: Sat Nov 11 18:04:47 2006 +1100
>
> [XFS] 956664: dm_read_invis() changes i_atime
>
> SGI-PV: 956664
> SGI-Modid: xfs-linux-melb:xfs-kern:27315a
>
> Signed-off-by: Vlad Apostolov <vapo@sgi.com>
> Signed-off-by: Sam Vaughan <sjv@sgi.com>
> Signed-off-by: Tim Shimmin <tes@sgi.com>
>
>
> commit 7a18c386078eaf17ae54595f66c0d64d9c1cb29c
> Author: David Chinner <dgc@sgi.com>
> Date: Sat Nov 11 18:04:54 2006 +1100
>
> [XFS] Clean up i_flags and i_flags_lock handling.
>
> SGI-PV: 956832
> SGI-Modid: xfs-linux-melb:xfs-kern:27358a
>
> Signed-off-by: David Chinner <dgc@sgi.com>
> Signed-off-by: Nathan Scott <nscott@aconex.com>
> Signed-off-by: Tim Shimmin <tes@sgi.com>
>
>
> commit 4c60658e0f4e253cf275f12b7c76bf128515a774
> Author: David Chinner <dgc@sgi.com>
> Date: Sat Nov 11 18:05:00 2006 +1100
>
> [XFS] Prevent a deadlock when xfslogd unpins inodes.
>
> The previous fixes for the use after free in xfs_iunpin left a nasty log
> deadlock when xfslogd unpinned the inode and dropped the last 
> reference to
> the inode. the ->clear_inode() method can issue transactions, and if the
> log was full, the transaction could push on the log and get stuck trying
> to push the inode it was currently unpinning.
>
> To fix this, we provide xfs_iunpin a guarantee that it will always have a
> valid xfs_inode <-> linux inode link or a particular flag will be set on
> the inode. We then use log forces during lookup to ensure transactions 
> are
> completed before we recycle the inode. This ensures that xfs_iunpin will
> never use the linux inode after it is being freed, and any lookup on an
> inode on the reclaim list will wait until it is safe to attach a new 
> linux
> inode to the xfs inode.
>
> SGI-PV: 956832
> SGI-Modid: xfs-linux-melb:xfs-kern:27359a
>
> Signed-off-by: David Chinner <dgc@sgi.com>
> Signed-off-by: Shailendra Tripathi <stripathi@agami.com>
> Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
> Signed-off-by: Tim Shimmin <tes@sgi.com>
>
>
> commit 050e714eb2bc662e9df6bf048ce86b4fbdd9bcd3
> Author: David Chinner <dgc@sgi.com>
> Date: Sat Nov 11 18:05:06 2006 +1100
>
> [XFS] Remove KERNEL_VERSION macros from xfs_dmapi.h
>
> SGI-PV: 957005
> SGI-Modid: xfs-linux-melb:xfs-kern:27398a
>
> Signed-off-by: David Chinner <dgc@sgi.com>
> Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Signed-off-by: Tim Shimmin <tes@sgi.com>
>
> --Tim
>
>
