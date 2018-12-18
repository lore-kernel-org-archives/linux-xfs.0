Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40846 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbeLRRZm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 12:25:42 -0500
Subject: Re: [PATCH 4/6] xfs: move XFS_INODE_FORMAT_STR mappings to libxfs
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
 <154344775711.4341.699323732443443292.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <541758f7-3af9-1eb5-db21-a0c8de9a808f@sandeen.net>
Date: Tue, 18 Dec 2018 11:25:41 -0600
MIME-Version: 1.0
In-Reply-To: <154344775711.4341.699323732443443292.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/18 5:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move XFS_INODE_FORMAT_STR to libxfs so that we don't forget to keep it
> updated, and add necessary TRACE_DEFINE_ENUM.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

...

> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 3f57002ca660..94e289aca220 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1901,11 +1901,11 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
>  	{ 0,	"target" }, \
>  	{ 1,	"temp" }

^^^^ that context makes me wonder if we shouldn't move that #define
as well, and give 0 & 1 some meaningful macro names.  Patch 7/6? :)

-Eric
