Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:46598 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdFBSjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 14:39:14 -0400
Date: Fri, 02 Jun 2017 14:39:06 -0400 (EDT)
Message-Id: <20170602.143906.818489457650113258.davem@davemloft.net>
Subject: Re: crypto: Work around deallocated stack frame reference gcc bug
 on sparc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170602180808.GB5636@birch.djwong.org>
References: <20170602.112854.571030442583332811.davem@davemloft.net>
        <20170602180808.GB5636@birch.djwong.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, matorola@gmail.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 2 Jun 2017 11:08:08 -0700

> ext4/jbd2's crc32c implementations will also need a fix like this for
> {ext4,jbd2}_chksum.  Note that both of these modules call the crypto api
> directly to avoid a static dependence on libcrc32c; this was done to
> reduce kernel footprint for applications that don't need it.  (ext2,
> ext3, and ext4 before the metadata_csum feature existed).

Good catch.  I even looked at that code the other day so should
have spotted it as well.

I'll integrate fixes for those into my patch when I get a chance,
thanks!

