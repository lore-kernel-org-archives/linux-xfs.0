Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60960 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbeJFRTh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:19:37 -0400
Date: Sat, 6 Oct 2018 03:16:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/15] xfsprogs: eliminate shadow variables
Message-ID: <20181006101655.GN28114@infradead.org>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-15-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538712196-13625-15-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 04, 2018 at 11:03:15PM -0500, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> None of these seem activel harmful, but to avoid confusion, remove all
> shadow variables by just renaming them in their local scope.
> 
> Fixes sparse warnings about this.

I'd feel much more comforable reviewing this with one patch per
function that explains why the transformation is safe, especially
as the patch itself contradicts the explanation above - some variables
are removed instead of renamed for example.
