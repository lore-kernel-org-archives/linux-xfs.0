Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936695AbcJVItg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Oct 2016 04:49:36 -0400
Date: Sat, 22 Oct 2016 01:49:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: don't skip cow forks w/ delalloc blocks in
 cowblocks scan
Message-ID: <20161022084936.GC7734@infradead.org>
References: <1477070533-59327-1-git-send-email-bfoster@redhat.com>
 <1477070533-59327-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477070533-59327-4-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

IFF we want to kill the delalloc blocks as well I'd suggest to kill
the helper and open code the two checks.
