Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55467 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751112AbdJVGka (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Oct 2017 02:40:30 -0400
Subject: Re: [PATCH 2/2] slab, slub, slob: convert slab_flags_t to 32-bit
References: <20171021100225.GA22428@avx2> <20171021100635.GA8287@avx2>
From: Pekka Enberg <penberg@iki.fi>
Message-ID: <ed694fcb-c1b8-849f-dc5d-145aa8872ad2@iki.fi>
Date: Sun, 22 Oct 2017 09:40:27 +0300
MIME-Version: 1.0
In-Reply-To: <20171021100635.GA8287@avx2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, ecryptfs@vger.kernel.org, linux-xfs@vger.kernel.org, kasan-dev@googlegroups.com, netdev@vger.kernel.org



On 21/10/2017 13.06, Alexey Dobriyan wrote:
> struct kmem_cache::flags is "unsigned long" which is unnecessary on
> 64-bit as no flags are defined in the higher bits.
> 
> Switch the field to 32-bit and save some space on x86_64 until such
> flags appear:
> 
> 	add/remove: 0/0 grow/shrink: 0/107 up/down: 0/-657 (-657)
> 	function                                     old     new   delta
> 	sysfs_slab_add                               720     719      -1
> 				...
> 	check_object                                 699     676     -23
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
