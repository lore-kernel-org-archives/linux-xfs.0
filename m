Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:28534 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932421AbdBPQ1x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Feb 2017 11:27:53 -0500
Subject: Re: [PATCH] mm,x86: fix SMP x86 32bit build for native_pud_clear()
References: <148719066814.31111.3239231168815337012.stgit@djiang5-desk3.ch.intel.com>
 <68216ac2-e194-30fa-9dcb-2020e8953bf5@linux.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <7280edbc-ba2b-2b72-680a-9408a8e764b9@intel.com>
Date: Thu, 16 Feb 2017 09:27:52 -0700
MIME-Version: 1.0
In-Reply-To: <68216ac2-e194-30fa-9dcb-2020e8953bf5@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Hansen <dave.hansen@linux.intel.com>, akpm@linux-foundation.org
Cc: keescook@google.com, mawilcox@microsoft.com, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kirill.shutemov@linux.intel.com, jack@suse.com, dan.j.williams@intel.com, linux-ext4@vger.kernel.org, ross.zwisler@linux.intel.com, vbabka@suse.cz, alexander.kapshuk@gmail.com



On 02/16/2017 08:42 AM, Dave Hansen wrote:
> On 02/15/2017 12:31 PM, Dave Jiang wrote:
>> The fix introduced by e4decc90 to fix the UP case for 32bit x86, however
>> that broke the SMP case that was working previously. Add ifdef so the dummy
>> function only show up for 32bit UP case only.
> 
> Could you elaborate a bit on how it broke things?

So originally 0-day build found that commit a10a1701 (mm, x86: add
support for PUD-sized transparent hugepages) is breaking 32bit x86 UP
config because native_pud_clear() was missing to satisfy
arch/x86/include/asm/pgtable.h. I added a dummy function to satisfy that
with commit e4decc90 (mm,x86: native_pud_clear missing on i386 build).
However in the process of doing that, I broke the 32bit x86 SMP config
that was working before.

> 
>> Fix: e4decc90 mm,x86: native_pud_clear missing on i386 build
> 
> Which tree is that in, btw?
> 
linux-next-20170214 I believe
