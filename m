Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfGQF0g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 01:26:36 -0400
Date: Tue, 16 Jul 2019 22:26:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/9] iomap: start moving code to fs/iomap/
Message-ID: <20190717052613.GA7093@magnolia>
References: <156321356040.148361.7463881761568794395.stgit@magnolia>
 <156321356685.148361.4004787941003993925.stgit@magnolia>
 <20190717045901.GA7113@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717045901.GA7113@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

On Tue, Jul 16, 2019 at 09:59:01PM -0700, Christoph Hellwig wrote:
> On Mon, Jul 15, 2019 at 10:59:26AM -0700, Darrick J. Wong wrote:
> > @@ -0,0 +1,7 @@
> > +# SPDX-License-Identifier: GPL-2.0-or-newer
> > +#
> > +# Copyright (c) 2019 Oracle.
> > +# All Rights Reserved.
> > +#
> > +
> > +ccflags-y += -I $(srctree)/$(src)/..
> 
> Is this for the fs/internal.h include?  Can't we just include that
> using #include "../internal.h" ?

Er... yes, it would seem so.

--D
