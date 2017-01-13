Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53550 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbdAMHdK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 02:33:10 -0500
Date: Fri, 13 Jan 2017 08:25:04 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 1/6] xfs: make the ASSERT() condition likely
Message-ID: <20170113072504.GA25416@lst.de>
References: <1484123050-11064-1-git-send-email-amir73il@gmail.com> <1484123050-11064-2-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484123050-11064-2-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 10:24:05AM +0200, Amir Goldstein wrote:
> The ASSERT() condition is the normal case, not the exception,
> so testing the condition should be likely(), not unlikely().

Btw, I think at least this one is 4.10-rc material, although the others
in this series might be candidates as well.
