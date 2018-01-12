Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:49908 "EHLO
        resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964802AbeALP40 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 10:56:26 -0500
Date: Fri, 12 Jan 2018 09:56:21 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
Subject: RE: [PATCH 04/36] usercopy: Prepare for usercopy whitelisting
In-Reply-To: <b8c3f85827ca493e9f4517f646ac97da@AcuMS.aculab.com>
Message-ID: <alpine.DEB.2.20.1801120955540.12791@nuc-kabylake>
References: <1515531365-37423-1-git-send-email-keescook@chromium.org> <1515531365-37423-5-git-send-email-keescook@chromium.org> <alpine.DEB.2.20.1801101219390.7926@nuc-kabylake> <b8c3f85827ca493e9f4517f646ac97da@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Laight <David.Laight@ACULAB.COM>
Cc: Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Windsor <dave@nullcore.net>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@infradead.org>, "David S. Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>, Matthew Garrett <mjg59@google.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>

On Fri, 12 Jan 2018, David Laight wrote:

> > Hmmm... At some point we should switch kmem_cache_create to pass a struct
> > containing all the parameters. Otherwise the API will blow up with
> > additional functions.
>
> Or add an extra function to 'configure' the kmem_cache with the
> extra parameters.

We probably need even more configurability if we add callbacks for object
reclaim / moving.

