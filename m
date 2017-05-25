Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37217 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965793AbdEYNA3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 May 2017 09:00:29 -0400
Date: Thu, 25 May 2017 15:00:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
Message-ID: <20170525130027.GA30194@lst.de>
References: <20170518062705.25902-1-hch@lst.de> <20170518062705.25902-11-hch@lst.de> <1495478957.6967.69.camel@linux.intel.com> <20170523084956.GB20121@lst.de> <1495545099.6967.81.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495545099.6967.81.camel@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Tue, May 23, 2017 at 04:11:39PM +0300, Andy Shevchenko wrote:
> Since we introduced a union it's possible that we might access the
> member which wasn't last modified one. So, my comment is to give an
> attention on such possibility and avoid if there is an aliasing
> happened.

We do for AFS (and XFS for fs fsid).  My preference would be to
not have the v1 struct defintion but instead provide a few
helpers in uuid.h that use get_unaligned_be* if needed:

	uuid_v1_time_low()
	uuid_v1_time_mid()
	uuid_v1_time_time_hi_and_version()..

>From his previously reply it seems like Dave doesn't like that idea
too much, in which case I suspect moving struct uuid_v1 back into
afs and living with cast in it is the way to go.
