Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44555 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932168AbdAIUgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 15:36:45 -0500
Date: Mon, 9 Jan 2017 12:36:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/7] dedupe: fix consistent error message prefixes for
 dedupe tests
Message-ID: <20170109203641.GC14033@birch.djwong.org>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
 <148357831442.7677.16850160926032292098.stgit@birch.djwong.org>
 <20170109092600.GB1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170109092600.GB1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Jan 09, 2017 at 05:26:00PM +0800, Eryu Guan wrote:
> On Wed, Jan 04, 2017 at 05:05:14PM -0800, Darrick J. Wong wrote:
> > Since we're fixing the xfs_io dedupe command to consistently
> > print the dedupe ioctl name on error, fix the tests too.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Seems you need to rebase against current master, I just pushed my patch
> out on Sunday with your Reviewed-by :)
> 
> 1300cbc generic/158,304: filter dedupe error message
> 
> And take use the new _filter_dedupe_error()? So both old and new version
> of xfs_io pass the tests.

Ok, will do.

--D

> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
