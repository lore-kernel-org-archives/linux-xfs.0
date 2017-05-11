Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53542 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754889AbdEKH41 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 03:56:27 -0400
Date: Thu, 11 May 2017 09:56:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v1 1/3] (to be split and folded into): uuid: rename
        uuid types
Message-ID: <20170511075625.GA19837@lst.de>
References: <20170510155612.55870-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170510155612.55870-1-andriy.shevchenko@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

I had to revert adding the NULL_UUID/GID defines due to too many
conflicts.  But in the end we shouldn't need them - we get uuid/guid_null
a little later so we should be just fine.
