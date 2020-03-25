Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F922C54FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 13:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F30052078D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 13:12:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A2FGKjLq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgCYNMO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:12:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgCYNMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 09:12:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IwlNyebXrHC8EcWHv/fXy0HG1aaxEBB+Q8CFiP98G+4=; b=A2FGKjLqZwX9273ZS41A4h9x4z
        /5aXgaCnpAiVYH6Wi0uRlXOXX32JUzY6XFbplvjSrH9r2PZjUIL7eVJ00b1dnwlwK5BrchBaUWozM
        MfzoOID2ym+KlTE7SFgC6jzaD/cwVwetVZbQEZuQ1MO7uztYGoGPMf08Y7+YwCgaqQk2ME9JsZWxs
        jgWhT9nS3X3rQ6NJHVfH9t0qBWSQ516oWQeCOLi3DyLm5+Jms87iUvcdiwIEwWB0ZtVLWQGCjVXlK
        qFdzK2CQIKS95+cLAWXsms0RufUwA3d3JN8s6Qs7k+S50LJKP+5iLkZylwsjAOhWLE5eSvvei3CYF
        fFsAHnGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH5pN-0006UN-Ut; Wed, 25 Mar 2020 13:12:13 +0000
Date:   Wed, 25 Mar 2020 06:12:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        chandan@linux.ibm.com
Subject: Re: [PATCH] common/xfs: Execute _xfs_check only for block size <= 4k
Message-ID: <20200325131213.GA22350@infradead.org>
References: <20200324034729.32678-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324034729.32678-1-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 09:17:29AM +0530, Chandan Rajendra wrote:
> fsstress when executed as part of some of the tests (e.g. generic/270)
> invokes chown() syscall many times by passing random integers as value
> for the uid argument. For each such syscall invocation for which there
> is no on-disk quota block, xfs invokes xfs_dquot_disk_alloc() which
> allocates a new block and instantiates all the quota structures mapped
> by the newly allocated block. For a single 64k block, the number of
> on-disk quota structures thus created will be 16 times more than that
> for a 4k block.
> 
> xfs_db's check command (executed after test script finishes execution)
> will read in all of the on-disk quota structures into memory. This
> causes the OOM event to be triggered when reading from filesystems with
> 64k block size. For machines with sufficiently large amount of system
> memory, this causes the test to execute for a very long time.
> 
> Due to the above stated reasons, this commit disables execution of
> xfs_db's check command when working on 64k blocksized filesystem.

Due to all the scalability issues in the xfs_db check command I think
it finally is time to just not run it by default at all.
