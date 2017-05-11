Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:33396 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932370AbdEKLnn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 07:43:43 -0400
Message-ID: <1494502838.6967.4.camel@linux.intel.com>
Subject: Re: [PATCH 05/16] uuid: add the v1 layout to uuid_t
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 11 May 2017 14:40:38 +0300
In-Reply-To: <20170510180214.16852-6-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
         <20170510180214.16852-6-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Wed, 2017-05-10 at 20:02 +0200, Christoph Hellwig wrote:
> Turn the content of uuid_t into a union and add the fields for the v1
> interpretation to it.

In the branch it has fix for UUID() wrt union change, but there missed
similar for GUID().

+#define UUID(a, _b, c, d0, d1, d2, d3, d4, d5, d6,
d7)                 \
+{ .b = { \

^^^ This should be done for GUID() as well.

While here, can we indent \ to be the same as of the rest lines in
macro(s) ?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
