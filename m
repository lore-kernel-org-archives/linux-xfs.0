Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 57E6E7F4E
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 12:42:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02ABAAC001
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 10:42:35 -0800 (PST)
Received: from mail-ig0-f177.google.com (mail-ig0-f177.google.com
	[209.85.213.177]) by cuda.sgi.com with ESMTP id
	zKNz0X6vONyLlnD6 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 10:42:30 -0800 (PST)
Received: by igjz20 with SMTP id z20so11735648igj.4
	for <xfs@oss.sgi.com>; Sat, 07 Mar 2015 10:42:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFwSQgrYqfXPr6RPvQ+8OJfexXJRY_GVEKg5QtB2t38cWA@mail.gmail.com>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-4-git-send-email-mgorman@suse.de>
	<CA+55aFwSQgrYqfXPr6RPvQ+8OJfexXJRY_GVEKg5QtB2t38cWA@mail.gmail.com>
Date: Sat, 7 Mar 2015 10:42:29 -0800
Message-ID: <CA+55aFxwmysVRCkBKFA88m_h0Byb0-2QvWn0_2rb_QNb8Eeedg@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: numa: Mark huge PTEs young when clearing NUMA
	hinting faults
From: Linus Torvalds <torvalds@linux-foundation.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@kernel.org>

On Sat, Mar 7, 2015 at 10:33 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>             Completely untested, but that "just
> or in the new protection bits" is what pnf_pte() does just a few lines
> above this.

Hmm. Looking at this, we do *not* want to set _PAGE_ACCESSED when we
turn a page into PROT_NONE or mark it for numa faulting. Nor do we
want to set it for mprotect for random pages that we haven't actually
accessed, just changed the protections for.

So my patch was obviously wrong, and I should feel bad for suggesting
it. I'm a moron, and my expectations that "pte_modify()" would just
take the accessed bit from the vm_page_prot field was stupid and
wrong.

Mel's patch is the right thing to do.

                                Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
