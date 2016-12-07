Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:50776 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753449AbcLGTok (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2016 14:44:40 -0500
Date: Thu, 8 Dec 2016 06:44:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
Message-ID: <20161207194402.GJ4326@dastard>
References: <20161204235059.GO31101@dastard>
 <A9F9389E-0CD8-4A85-BA08-C5503B781679@nuagenetworks.net>
 <20161205012243.GQ31101@dastard>
 <C07DD929-5600-4934-A6B0-C0A7D83D7247@nuagenetworks.net>
 <20161205074645.GB4326@dastard>
 <07D60BAA-A340-4AB0-9F22-D962A0478891@nuagenetworks.net>
 <20161205214557.GC4219@dastard>
 <C257E648-B5F6-473D-B659-74434CF0FB51@nuagenetworks.net>
 <473936408.4772.1481091425441@itfw6.prod.google.com>
 <8176484246282250577@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8176484246282250577@unknownmsgid>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cyril PEPONNET <cyril.peponnet@nuagenetworks.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Wed, Dec 07, 2016 at 07:16:55AM -0800, Cyril PEPONNET wrote:
> Our snapshots are deleted / recreated quite often. If I apply the extent
> size hint to the root folder of an existing tree, does it will still apply
> for new created files ?

Only for new files/directories created in the root directory. THe
hint is not retro-actively applied. You'd need to walk the tree
setting the hint on all directories to get it to apply to all new
files created.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
