Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51024 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753166AbdEJR3j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 13:29:39 -0400
Date: Wed, 10 May 2017 19:29:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v1 2/3] (to be folded into): uuid: hoist uuid_is_null()
        helper from libnvdimm
Message-ID: <20170510172937.GA4192@lst.de>
References: <20170510155612.55870-1-andriy.shevchenko@linux.intel.com> <20170510155612.55870-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170510155612.55870-2-andriy.shevchenko@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

>  static inline bool guid_is_null(guid_t *guid)
>  {
> -	return guid_equal(guid, &guid_null);
> +	return guid_equal(guid, &NULL_GUID);

Given that NULL_UUID/GUID are macros I wouldn't expect this to work,
and in fact the compiler throws pages of warnings at me with this
change..
