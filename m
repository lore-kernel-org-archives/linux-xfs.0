Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44964 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdAWUy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2017 15:54:56 -0500
Date: Mon, 23 Jan 2017 12:54:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS warning at fs/iomap.c:768 iomap_dio_actor
Message-ID: <20170123205455.GA29669@infradead.org>
References: <20170120115517.GW1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170120115517.GW1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 20, 2017 at 07:55:17PM +0800, Eryu Guan wrote:
> Hi all,
> 
> I've seen the warning in subject a few times while testing XFS with
> xfstests, with different test configs, different arches, and multiple
> tests could trigger the warning, e.g. generic/269 generic/388 xfs/297.
> 
> Today I reproduced it manually by running xfs/297 in a loop on one of my
> test hosts, the warning usueally fires within 30 iterations for me.

That probaly means we managed to get a delayed allocation still in
place when doing direct I/O, which implies the flushing code is racy.

I'll try to find some time to debug this further.
