Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45689 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdCGGif (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 01:38:35 -0500
Date: Mon, 6 Mar 2017 21:01:40 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: report crtime and attribute flags to statx
Message-ID: <20170307050140.GA12946@infradead.org>
References: <20170307000609.GG5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170307000609.GG5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dhowells@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 06, 2017 at 04:06:09PM -0800, Darrick J. Wong wrote:
> statx has the ability to report inode creation times and inode flags, so
> hook up di_crtime and di_flags to that functionality.

This would be great to have in 4.11 together with the initial statx
implementation.  But until I see documentation and testcases for statx
I don't really feel comfortable reviewing anything related to it.
