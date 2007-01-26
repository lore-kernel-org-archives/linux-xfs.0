Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Jan 2007 01:26:48 -0800 (PST)
Received: from smtp.osdl.org (smtp.osdl.org [65.172.181.24])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0Q9Qbqw016865
	for <xfs@oss.sgi.com>; Fri, 26 Jan 2007 01:26:38 -0800
Date: Fri, 26 Jan 2007 01:25:05 -0800
From: Andrew Morton <akpm@osdl.org>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba ->
 RAID5)
Message-Id: <20070126012505.d8cb07f2.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701241836590.2930@p34.internal.lan>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
	<45B5261B.1050104@redhat.com>
	<Pine.LNX.4.64.0701241836590.2930@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>

On Wed, 24 Jan 2007 18:37:15 -0500 (EST)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> > Without digging too deeply, I'd say you've hit the same bug Sami Farin and
> > others
> > have reported starting with 2.6.19: pages mapped with kmap_atomic() become
> > unmapped
> > during memcpy() or similar operations.  Try disabling preempt -- that seems to
> > be the
> > common factor.
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> After I run some other tests, I am going to re-run this test and see if it 
> OOPSes again with PREEMPT off.

Strange.  The below debug patch might catch it - please run with this
applied.  


--- a/arch/i386/mm/highmem.c~kmap_atomic-debugging
+++ a/arch/i386/mm/highmem.c
@@ -30,7 +30,43 @@ void *kmap_atomic(struct page *page, enu
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
+	static unsigned warn_count = 10;
 
+	if (unlikely(warn_count == 0))
+		goto skip;
+
+	if (unlikely(in_interrupt())) {
+		if (in_irq()) {
+			if (type != KM_IRQ0 && type != KM_IRQ1 &&
+			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
+			    type != KM_BOUNCE_READ) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		} else if (!irqs_disabled()) {	/* softirq */
+			if (type != KM_IRQ0 && type != KM_IRQ1 &&
+			    type != KM_SOFTIRQ0 && type != KM_SOFTIRQ1 &&
+			    type != KM_SKB_SUNRPC_DATA &&
+			    type != KM_SKB_DATA_SOFTIRQ &&
+			    type != KM_BOUNCE_READ) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		}
+	}
+
+	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ) {
+		if (!irqs_disabled()) {
+			WARN_ON(1);
+			warn_count--;
+		}
+	} else if (type == KM_SOFTIRQ0 || type == KM_SOFTIRQ1) {
+		if (irq_count() == 0 && !irqs_disabled()) {
+			WARN_ON(1);
+			warn_count--;
+		}
+	}
+skip:
 	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
 	pagefault_disable();
 	if (!PageHighMem(page))
_
