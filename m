Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:55850 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750957AbdB1XNz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 18:13:55 -0500
Date: Wed, 1 Mar 2017 09:46:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: lockdep splat in today's master in generic/070
Message-ID: <20170228224645.GG17542@dastard>
References: <0e8e52ac-36e4-c8f9-99c7-88e2c9bcb782@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e8e52ac-36e4-c8f9-99c7-88e2c9bcb782@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 28, 2017 at 04:56:01PM +0200, Nikolay Borisov wrote:
> Hello, 
> 
> I've been running xfstest and I can reliably reproduce the following lockdep splat: 

vm_map_ram() has hard coded GFP_KERNEL allocations, it's being
called in GFP_NOFS context, and lockdep doesn't know about
memalloc_noio_save() used by _xfs_buf_map_pages() to work around
the problems in vm_map_ram(). See the comment in
_xfs_buf_map_pages().

-Dave.
-- 
Dave Chinner
david@fromorbit.com
