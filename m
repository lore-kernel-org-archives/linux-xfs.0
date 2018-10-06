Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60890 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeJFRQm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:16:42 -0400
Date: Sat, 6 Oct 2018 03:14:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/15] xfsprogs: include headers for extern variables
Message-ID: <20181006101400.GK28114@infradead.org>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-12-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538712196-13625-12-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 04, 2018 at 11:03:12PM -0500, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Include headers which export functions so that they don't appear to be
> static to the sparse checker.
> 
> Remove redundant extern declarations in c code which are no longer needed.
> 
> Fixes sparse warnings about this.

I think this really wants to be split out into a few patches describing
what gets moved/included for specific case.
