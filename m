Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbeJOAuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Oct 2018 20:50:44 -0400
Date: Sun, 14 Oct 2018 10:09:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH 2/2] xfsprogs: enable sparse checking with "make C=2"
Message-ID: <20181014170903.GB30673@infradead.org>
References: <5b155482-78db-b58d-13d3-a478f79b1558@redhat.com>
 <086806d2-c2e5-bca0-1ade-fb7e5995c7d4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <086806d2-c2e5-bca0-1ade-fb7e5995c7d4@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 11, 2018 at 11:14:14AM -0500, Eric Sandeen wrote:
> Enable "make C=2" sparse checking of all files without rebuilding them.
> 
> This is a bit simpler than redefining CC for the whole build, which
> requires extra commandline definitions and apparently is enough of a
> barrier that nobody's doing sparse checking.
> 
> Note, this requires unreleased sparse after v0.5, which enables the
> CHAR_BIT definition; otherwise it chokes.

This seems to duplicate much of the previous commit message..

Except for that it looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
