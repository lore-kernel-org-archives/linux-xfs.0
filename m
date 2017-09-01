Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdIAIJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 04:09:04 -0400
Date: Fri, 1 Sep 2017 01:09:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fsmap: fix documentation of FMR_OF_LAST
Message-ID: <20170901080904.GA32746@infradead.org>
References: <20170831204918.GA7404@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831204918.GA7404@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-api@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Thu, Aug 31, 2017 at 01:49:18PM -0700, Darrick J. Wong wrote:
> The FMR_OF_LAST flag is set on the last fsmap record being returned for
> the dataset requested, contrary to what the header file says.  Fix the
> docs to reflect the behavior of all fsmap implementations.

Hmm.  What's the point of the flag then given that you can trivially
deduce the last entry from fmh_entries?
