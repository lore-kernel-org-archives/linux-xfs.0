Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38086 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388069AbeKOU0l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 15:26:41 -0500
Date: Thu, 15 Nov 2018 02:19:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: change xfs_buf_ioapply_map to STATIC
Message-ID: <20181115101928.GD13913@infradead.org>
References: <20181107201055.25883-1-josef@toxicpanda.com>
 <20181107201055.25883-2-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107201055.25883-2-josef@toxicpanda.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-xfs@vger.kernel.org

On Wed, Nov 07, 2018 at 03:10:54PM -0500, Josef Bacik wrote:
> In order to make error injection triggering easier make
> xfs_buf_ioapply_map STATIC so it's noinline and can be kprobe'ed.

So per the whole STATIC discussion how about throwing in an explicit
noinline instead?

Then again if you really are about error injection we should probably
have a real tag here.  Either explicit error injection like we have
in many places in XFS, or a trace point which should give a really
nice hook, too.
