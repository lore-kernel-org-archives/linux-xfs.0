Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.184]:58564 "EHLO
        smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934192AbeALPsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 10:48:42 -0500
From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 04/36] usercopy: Prepare for usercopy whitelisting
Date: Fri, 12 Jan 2018 15:10:42 +0000
Message-ID: <b8c3f85827ca493e9f4517f646ac97da@AcuMS.aculab.com>
References: <1515531365-37423-1-git-send-email-keescook@chromium.org>
 <1515531365-37423-5-git-send-email-keescook@chromium.org>
 <alpine.DEB.2.20.1801101219390.7926@nuc-kabylake>
In-Reply-To: <alpine.DEB.2.20.1801101219390.7926@nuc-kabylake>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: 'Christopher Lameter' <cl@linux.com>, Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Windsor <dave@nullcore.net>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@infradead.org>, "David S. Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>, Matthew Garrett <mjg59@google.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>

From: Christopher Lameter
> Sent: 10 January 2018 18:28
> On Tue, 9 Jan 2018, Kees Cook wrote:
> 
> > +struct kmem_cache *kmem_cache_create_usercopy(const char *name,
> > +			size_t size, size_t align, slab_flags_t flags,
> > +			size_t useroffset, size_t usersize,
> > +			void (*ctor)(void *));
> 
> Hmmm... At some point we should switch kmem_cache_create to pass a struct
> containing all the parameters. Otherwise the API will blow up with
> additional functions.

Or add an extra function to 'configure' the kmem_cache with the
extra parameters.

	David

