Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51869 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752009AbdCAPCi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 10:02:38 -0500
Date: Wed, 1 Mar 2017 16:02:35 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: invalidate page caches should be after
        iomap_dio_complete() in direct write
Message-ID: <20170301150235.GC12248@lst.de>
References: <20170228173626.27640-1-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228173626.27640-1-guaneryu@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de, Eryu Guan <eguan@redhat.com>

This looks fine to me, but instead of the global res variable
please use local variables in the if blocks (and maybe give them
a better name like err).
