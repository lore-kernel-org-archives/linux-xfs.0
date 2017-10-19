Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52381 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751592AbdJSHSn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:18:43 -0400
Date: Thu, 19 Oct 2017 00:18:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] generic/45[34]: force UTF-8 codeset to enable utf-8
 namer checks in xfs_scrub
Message-ID: <20171019071842.GA28970@infradead.org>
References: <150836985024.27213.3715197937819365388.stgit@magnolia>
 <150836987529.27213.1335818370452284585.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150836987529.27213.1335818370452284585.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Oct 18, 2017 at 04:37:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The upcoming xfs_scrub tool will have the ability to warn about
> suspicious UTF-8 normalization collisions.  We want generic/45[34] to be
> able to test this functionality, but to do that we have to forcibly set
> the codeset to UTF-8 via LC_ALL since the rest of xfstests only uses
> LC_ALL=C.

Wait.  Where do you want to validate UTF-8 normalization?  There is
absolutely no guarantee that someone uses UTF-8, so any reliance on
the character set in the file system is bogus.
