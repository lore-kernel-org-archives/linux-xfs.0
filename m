Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D4BE87C8C
	for <xfs@oss.sgi.com>; Sat, 27 Feb 2016 23:32:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A0434304043
	for <xfs@oss.sgi.com>; Sat, 27 Feb 2016 21:32:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id R6tsHgN5HZ7guoZ9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 27 Feb 2016 21:32:01 -0800 (PST)
Date: Sun, 28 Feb 2016 13:31:58 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: generic/320 triggers "list_add attempted on force-poisoned
	entry" warning on XFS
Message-ID: <20160228053158.GK11419@eguan.usersys.redhat.com>
References: <20160227130256.GJ11419@eguan.usersys.redhat.com>
	<CAPcyv4gZKzUsch2RQm-QQWuUHtmtQerz2fstCwbwaMjyzYvwrA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gZKzUsch2RQm-QQWuUHtmtQerz2fstCwbwaMjyzYvwrA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, XFS Developers <xfs@oss.sgi.com>

On Sat, Feb 27, 2016 at 12:10:51PM -0800, Dan Williams wrote:
> On Sat, Feb 27, 2016 at 5:02 AM, Eryu Guan <eguan@redhat.com> wrote:
> > Hi,
> >
> > Starting from 4.5-rc1 kernel, I sometimes see generic/320 triggers
> > "list_add attempted on force-poisoned entry" warnings on XFS, test hosts
> > are arm64/ppc64/ppc64le, haven't seen it on x86_64 hosts.
> 
> Hmm, this triggers when a list_head has ->next or ->prev pointing at
> the address of force_poison which is only defined in lib/list_debug.c.
> The only call site that uses list_force_poison() is in
> devm_memremap_pages().  That currently depends on CONFIG_ZONE_DEVICE
> which in turn depends on X86_64.
> 
> So, this appears to be a false positive and the address of
> force_poison is somehow ending up on the stack by accident as that is
> the random value being passed in from __down_common:
> 
>     struct semaphore_waiter waiter;
> 
>     list_add_tail(&waiter.list, &sem->wait_list);
> 
> So, I think we need a more unique poison value that should never
> appear on the stack:

Unfortunately I can still see the warning after applying this test patch.

Then I added debug code to print the pointer value and re-ran the test.
All five failures printed the same pointer value, failed in the same
pattern:

list_add attempted on force-poisoned entry(0000000000000500), new->next = c00000000136bc00, new->prev = 0000000000000500

Thanks,
Eryu

> 
> diff --git a/include/linux/poison.h b/include/linux/poison.h
> index 4a27153574e2..0604806c2f52 100644
> --- a/include/linux/poison.h
> +++ b/include/linux/poison.h
> @@ -21,6 +21,7 @@
>  */
> #define LIST_POISON1  ((void *) 0x100 + POISON_POINTER_DELTA)
> #define LIST_POISON2  ((void *) 0x200 + POISON_POINTER_DELTA)
> +#define LIST_POISON3  ((void *) 0x500 + POISON_POINTER_DELTA)
> 
> /********** include/linux/timer.h **********/
> /*
> diff --git a/lib/list_debug.c b/lib/list_debug.c
> index 3345a089ef7b..318bf1c181b2 100644
> --- a/lib/list_debug.c
> +++ b/lib/list_debug.c
> @@ -12,11 +12,10 @@
> #include <linux/kernel.h>
> #include <linux/rculist.h>
> 
> -static struct list_head force_poison;
> void list_force_poison(struct list_head *entry)
> {
> -       entry->next = &force_poison;
> -       entry->prev = &force_poison;
> +       entry->next = LIST_POISON3;
> +       entry->prev = LIST_POISON3;
> }
> 
> /*
> @@ -30,7 +29,7 @@ void __list_add(struct list_head *new,
>                              struct list_head *prev,
>                              struct list_head *next)
> {
> -       WARN(new->next == &force_poison || new->prev == &force_poison,
> +       WARN(new->next == LIST_POISON3 || new->prev == LIST_POISON3,
>                "list_add attempted on force-poisoned entry\n");
>        WARN(next->prev != prev,
>                "list_add corruption. next->prev should be "

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
