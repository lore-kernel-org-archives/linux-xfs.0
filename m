Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034057AbcIWB6R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Sep 2016 21:58:17 -0400
Date: Fri, 23 Sep 2016 09:58:14 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] fstests: make some xfs project quota tests generic
Message-ID: <20160923015814.GS27776@eguan.usersys.redhat.com>
References: <ffeed0c4-7e77-a7a0-1426-0890bf38a52f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffeed0c4-7e77-a7a0-1426-0890bf38a52f@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu, Sep 22, 2016 at 05:51:03PM -0500, Eric Sandeen wrote:
> This patch makes some xfs project quota tests generic,
> so that there is at least some coverage on ext4 for this
> (semi-)new feature.
> 
> It requires bleeding edge xfsprogs, so that xfs_quota and 
> xfs_io's chproj command can operate on "foreign" filesystems,
> and requires relatively new e2fsprogs to enable the project
> quota feature on-disk.
> 
> The mechanism for enabling project quota on ext4 is a bit
> arcane, but hopefully I've encapsulated it reasonably well here.
> 
> Changes:
> 
> * look for "project" feature in _require_prjquota
> * look for accounting not enforcement (-P) in _require_prjquota
> * add a _scratch_enable_pquota to turn on project quota feature
> * s/pquota/quota/ in _qmount_option for ext4
> * add helper to test for xfs_io chproj on foreign filesystems
> * switch from block to inode quota in xfs/133 because empty
>   ext4 dirs consume one block
> * cosmetic/generic changes for mkfs, require tests, etc.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Eryu, would you like to do the move-to-generic/ since you'll need
> to renumber them anyway? :)

Yeah, sure, I can do that :)

> 
> Note -
> This requires the previous patch I sent to the fstests list,
> 
> [PATCH 2/3 V2] modify xfs/ quota tests to work on generic filesystems

Thanks!

Eryu
