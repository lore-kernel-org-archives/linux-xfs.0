Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:35176 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750917AbcLDVtx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 16:49:53 -0500
Date: Mon, 5 Dec 2016 08:49:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
Message-ID: <20161204214950.GL31101@dastard>
References: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
Cc: linux-xfs@vger.kernel.org

On Sat, Dec 03, 2016 at 11:08:58AM -0800, Cyril Peponnet wrote:
> Hi xfs community :),
> 
> We have a glusterfs setup running under centos7.2. We are using
> xfs as underlying storage for the bricks.  The volume is used to
> store vm snapshots that’s gets created dynamically from the
> hypervisors through glusterfs mount points.
> 
> While this is working fine we have some issues from time to time
> that make the mount points hang.
> 
> We have the famous XFS: possible memory allocation deadlock in
> kmem_alloc (mode:0x250) errors appearing from time to time on some
> of our gluster nodes.

And the complete output in dmesg is?

> Let me know if you need more information about our systems (like
> kernel version, underlying storage…)

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

-Dave.
-- 
Dave Chinner
david@fromorbit.com
