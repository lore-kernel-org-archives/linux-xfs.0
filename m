Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50860 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbeJOAt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Oct 2018 20:49:59 -0400
Date: Sun, 14 Oct 2018 10:08:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfsprogs: enable sparse checking with make C=1
Message-ID: <20181014170818.GA30673@infradead.org>
References: <5b155482-78db-b58d-13d3-a478f79b1558@redhat.com>
 <97a4f428-9c9c-7bd7-7d6f-f2bf3a39b9ac@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a4f428-9c9c-7bd7-7d6f-f2bf3a39b9ac@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 11, 2018 at 11:12:52AM -0500, Eric Sandeen wrote:
> Enable "make C=1" sparse checking when files get rebuilt.  To check
> all files, run "make clean" first.
> 
> This is a bit simpler than redefining CC for the whole build, which
> requires extra commandline definitions and apparently is enough of a
> barrier that nobody's doing sparse checking.
> 
> Note, this requires unreleased sparse after v0.5, which enables the
> CHAR_BIT definition; otherwise it chokes.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
