Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbdK2T53 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 14:57:29 -0500
Date: Wed, 29 Nov 2017 11:57:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Don't trim file extents during iomap
Message-ID: <20171129195725.GA15157@infradead.org>
References: <1511437203-4329-1-git-send-email-nborisov@suse.com>
 <20171127174434.GB19379@magnolia>
 <20171128014746.GC21412@magnolia>
 <154aef58-7f5a-9e69-f33c-2cff22efb009@suse.com>
 <20171129023034.GF21412@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171129023034.GF21412@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org, hch@infradead.org, sandeen@redhat.com

On Tue, Nov 28, 2017 at 06:30:34PM -0800, Darrick J. Wong wrote:
> Hey Christoph, what are the rules about ->iomap_begin passing back an
> extent that extends outside the range that was requested?  Mr. Borisov
> wants XFS fiemap to return the raw extent without trimming (apparently
> to follow the ext4 fiemap behavior), but enabling XFS_BMAPI_ENTIRE
> unconditionally causes xfstests regressions, which we cannot have.

No rules yet as you see.  But I think the best plan in the long run
is that the iomap.c code will trim any mapping if needed instead of having
duplicate instance of the trimming code in the file systems.
