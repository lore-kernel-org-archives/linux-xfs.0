Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47990 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752620AbdARU6q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2017 15:58:46 -0500
Date: Wed, 18 Jan 2017 12:57:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v8 1/6] xfs: make the ASSERT() condition likely
Message-ID: <20170118205726.GB12985@birch.djwong.org>
References: <1484123050-11064-1-git-send-email-amir73il@gmail.com>
 <1484123050-11064-2-git-send-email-amir73il@gmail.com>
 <20170113072504.GA25416@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170113072504.GA25416@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Jan 13, 2017 at 08:25:04AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 11, 2017 at 10:24:05AM +0200, Amir Goldstein wrote:
> > The ASSERT() condition is the normal case, not the exception,
> > so testing the condition should be likely(), not unlikely().
> 
> Btw, I think at least this one is 4.10-rc material, although the others
> in this series might be candidates as well.

They are, I can crash the kernel with a zero-length directory, which
one of the patches in this series fixes.

Applied, soaking into for-next now.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
