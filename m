Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A8B37F4C
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 08:41:58 -0500 (CDT)
Message-ID: <51923F42.6040801@sgi.com>
Date: Tue, 14 May 2013 08:42:26 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: automatically add -F to xfs_io on non-xfs
References: <51850BED.6050109@redhat.com> <5189B9DA.7010807@sandeen.net>
In-Reply-To: <5189B9DA.7010807@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, xfs-oss <xfs@oss.sgi.com>

On 05/07/2013 09:35 PM, Eric Sandeen wrote:
> The -F flag to xfs_io originally enabled it to operate on non-xfs
> filesystems.  This restriction was removed upstream in favor of
> gracefully failing on the handful of operations that actually
> required xfs, and the option was deprecated.
>

This has been committed:

commit 96fce07867cdd55f1731663a0014b418d8b0ed6c
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue May 14 08:33:44 2013 -0500

     xfstests: automatically add -F to xfs_io on non-xfs

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
