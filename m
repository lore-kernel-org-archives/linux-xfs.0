Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47464 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760643AbdAIPx7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:53:59 -0500
Date: Mon, 9 Jan 2017 07:53:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 3/3] xfs: make the ASSERT() condition likely
Message-ID: <20170109155357.GC19396@infradead.org>
References: <1483967189-27313-1-git-send-email-amir73il@gmail.com>
 <1483967189-27313-4-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483967189-27313-4-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jan 09, 2017 at 03:06:29PM +0200, Amir Goldstein wrote:
> The ASSERT() condition is the normal case, not the exception,
> so testing the condition should be likely(), not unlikely().

Oh, wow.  That might have wrecked some branch prediction in
WARN or DEBUG builds..

Reviewed-by: Christoph Hellwig <hch@lst.de>
