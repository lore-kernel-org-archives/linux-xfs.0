Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44628 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbeLMW10 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Dec 2018 17:27:26 -0500
Subject: Re: [PATCH 0/3] iomap: 1 cleanup, 1 fix, 1 optimization
From: Eric Sandeen <sandeen@sandeen.net>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
Message-ID: <c9b9324d-9ec6-7d2b-360d-e462fa80c2bf@sandeen.net>
Date: Thu, 13 Dec 2018 16:27:25 -0600
MIME-Version: 1.0
In-Reply-To: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: hch@lst.de

On 12/13/18 4:25 PM, Eric Sandeen wrote:
> Patch 1 is trivial, to use the SECTOR_SIZE macro instead of open-coding.
> Patch 2 is the one that matters: iomap_is_partially_uptodate was doing invalid memory accesses past the end of the iomap_page->uptodate bitmap.
> Patch3 is a small optimization (?) based on what the non-iomap code does, i.e. don't bother checking each block if the "partial" range covers the whole page
> 
> These survived an xfstests -g auto run on 4k and 1k block size filesystems
> on x86_64.  Careful review for off by ones is appreciated in any case. ;)

Ugh, I fatfingered a cc (or maybe I'll blame guilt) - careful on reply-all,
sorry about that.

-Eric
