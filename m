Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26645 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750918AbcKFWWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Nov 2016 17:22:42 -0500
Date: Mon, 7 Nov 2016 09:22:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: don't call xfs_sb_quota_from_disk twice
Message-ID: <20161106222239.GO14023@dastard>
References: <147828429514.31793.3070284385118900515.stgit@birch.djwong.org>
 <147828433466.31793.7424646031402565530.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147828433466.31793.7424646031402565530.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>

On Fri, Nov 04, 2016 at 11:32:14AM -0700, Eric Sandeen wrote:
> >From ee3754254e8c186c99b6cdd4d59f741759d04acb Mon Sep 17 00:00:00 2001
> 
> kernel commit 5ef828c4
> xfs: avoid false quotacheck after unclean shutdown
> 
> made xfs_sb_from_disk() also call xfs_sb_quota_from_disk
> by default.

This is another of those confusing commit messages. It references
kernel commits, but does not make it clear that this is a fix first
applied to the userspace and is not being synced back to the kernel....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
