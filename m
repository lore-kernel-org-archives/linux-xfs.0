Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38514 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbdAMNVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2017 08:21:43 -0500
Date: Fri, 13 Jan 2017 05:21:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG v4.10-rc1] fzero returns EIO on DAX mount
Message-ID: <20170113132131.GA19088@infradead.org>
References: <20170106103239.GY1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170106103239.GY1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-block@vger.kernel.org, chaitanya.kulkarni@hgst.com, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

The problem is that brd return -EIO due to alignment, and the old
code waited for the bio and then ignored the error.  The new code
assumes if the submission is fine this is the method to pick and to
move on.  We could revert some of this for now, but I think the right
thing to do is to stop abusing REQ_OP_DISCARD for zeroing now.

I had planned to do this for 4.10 but it splitted, let's see if I
can get the series small enough for this time in the merge window.
