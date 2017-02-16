Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:27077 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932224AbdBPPmy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Feb 2017 10:42:54 -0500
Subject: Re: [PATCH] mm,x86: fix SMP x86 32bit build for native_pud_clear()
References: <148719066814.31111.3239231168815337012.stgit@djiang5-desk3.ch.intel.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <68216ac2-e194-30fa-9dcb-2020e8953bf5@linux.intel.com>
Date: Thu, 16 Feb 2017 07:42:34 -0800
MIME-Version: 1.0
In-Reply-To: <148719066814.31111.3239231168815337012.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>, akpm@linux-foundation.org
Cc: keescook@google.com, mawilcox@microsoft.com, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kirill.shutemov@linux.intel.com, jack@suse.com, dan.j.williams@intel.com, linux-ext4@vger.kernel.org, ross.zwisler@linux.intel.com, vbabka@suse.cz, alexander.kapshuk@gmail.com

On 02/15/2017 12:31 PM, Dave Jiang wrote:
> The fix introduced by e4decc90 to fix the UP case for 32bit x86, however
> that broke the SMP case that was working previously. Add ifdef so the dummy
> function only show up for 32bit UP case only.

Could you elaborate a bit on how it broke things?

> Fix: e4decc90 mm,x86: native_pud_clear missing on i386 build

Which tree is that in, btw?
