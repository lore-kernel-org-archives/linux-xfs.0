Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52226 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933009AbdAHXIf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 18:08:35 -0500
Subject: Re: [PATCH] remove irix support
References: <1483869052-10621-1-git-send-email-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3814138b-53a4-4c1f-3bd3-aac9c982a154@sandeen.net>
Date: Sun, 8 Jan 2017 17:08:33 -0600
MIME-Version: 1.0
In-Reply-To: <1483869052-10621-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On 1/8/17 3:50 AM, Christoph Hellwig wrote:
> The port of the opensource xfsprogs to IRIX always was secondary to the
> "real" tools in the IRIX tree.  IRIX has effectively been EOLed, and
> dropping support for it will allow cleaning up various things in the XFS
> tree where IRIX was oddly different from the other ports.  E.g. that the
> xfsctl function needs a path and a fd, something we could replace with
> just documenting to use ioctl in the future, or various ifdefs in the
> headers shared with the kernel for structures provided by native headers
> in IRIX.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems pretty reasonable at this point.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

-Eric

