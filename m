Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58846 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726656AbeJKSDR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Oct 2018 14:03:17 -0400
Date: Thu, 11 Oct 2018 12:36:36 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] ext2, ext4, xfs: hard fail dax mount on unsupported
 devices
Message-ID: <20181011103636.GC9467@quack2.suse.cz>
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>

On Mon 08-10-18 14:32:46, Eric Sandeen wrote:
> In response to an earlier xfs patch to change how xfs reacts to
> dax incompatibilities, Dave said:
> 
> > I suspect we need to be more harsh are rejecting mounts with -o dax
> > on devices DAX isn't supported on. This mount option is going into
> > production systems - it's not just for "testing" as the comments all
> > claim. i Things will break in production systems if DAX isn't
> > enabled and they are expecting it to be enabled.
> 
> and I tend to agree, so proposing this change to hard-fail a dax mount if
> the device doesn't support it, instead of silently disabling the
> functionality.  Proposing for ext2, ext4, and xfs to keep behavior in
> sync.

Let me include Dan and Ross into the discussion since they were the ones
proposing the "silent fallback" behavior (ext4 actually did fail the mount
instead not so long ago - see 24f3478d664b "ext4: auto disable dax instead
of failing mount" from December). Guys, why did you choose the fallback
path instead of a failure?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
