Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752198AbdAIKUp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Jan 2017 05:20:45 -0500
Date: Mon, 9 Jan 2017 18:20:44 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/7] common: add leading underscore to get_block_size
Message-ID: <20170109102044.GE1859@eguan.usersys.redhat.com>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
 <148357828858.7677.1046746692994559684.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148357828858.7677.1046746692994559684.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jan 04, 2017 at 05:04:48PM -0800, Darrick J. Wong wrote:
> Add a leading underscore to the get_block_size helper since it's a
> common function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

There's a new user of get_block_size, after latest fstests update,
btrfs/012. I can fold the btrfs/012 update to this patch.

Thanks for doing this!

Eryu
