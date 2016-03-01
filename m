Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BF3B7CBB
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 10:28:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3BC648F8035
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 08:28:04 -0800 (PST)
Received: from mail-oi0-f53.google.com (mail-oi0-f53.google.com
	[209.85.218.53]) by cuda.sgi.com with ESMTP id 9MGEIHHrYQycqXvr
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Mar 2016 08:27:59 -0800 (PST)
Received: by mail-oi0-f53.google.com with SMTP id d205so49899270oia.0
	for <xfs@oss.sgi.com>; Tue, 01 Mar 2016 08:27:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160301080057.GL11419@eguan.usersys.redhat.com>
References: <20160227130256.GJ11419@eguan.usersys.redhat.com>
	<CAPcyv4gZKzUsch2RQm-QQWuUHtmtQerz2fstCwbwaMjyzYvwrA@mail.gmail.com>
	<20160228053158.GK11419@eguan.usersys.redhat.com>
	<CAPcyv4jNhCkStvwtS54FjJVWAfvMv-gEDjHWq3V7_YTOmk+W2g@mail.gmail.com>
	<20160301080057.GL11419@eguan.usersys.redhat.com>
Date: Tue, 1 Mar 2016 08:27:58 -0800
Message-ID: <CAPcyv4hLqJQ6xQ+ifhi4q=wdEP=AJGLZ0Ep-KoEvq20EiP5EbQ@mail.gmail.com>
Subject: Re: generic/320 triggers "list_add attempted on force-poisoned entry"
	warning on XFS
From: Dan Williams <dan.j.williams@intel.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, XFS Developers <xfs@oss.sgi.com>

On Tue, Mar 1, 2016 at 12:00 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Mon, Feb 29, 2016 at 10:22:06AM -0800, Dan Williams wrote:
>> On Sat, Feb 27, 2016 at 9:31 PM, Eryu Guan <eguan@redhat.com> wrote:
>> > On Sat, Feb 27, 2016 at 12:10:51PM -0800, Dan Williams wrote:
>> >> On Sat, Feb 27, 2016 at 5:02 AM, Eryu Guan <eguan@redhat.com> wrote:
>> >> > Hi,
>> >> >
>> >> > Starting from 4.5-rc1 kernel, I sometimes see generic/320 triggers
>> >> > "list_add attempted on force-poisoned entry" warnings on XFS, test hosts
>> >> > are arm64/ppc64/ppc64le, haven't seen it on x86_64 hosts.
>> >>
>> >> Hmm, this triggers when a list_head has ->next or ->prev pointing at
>> >> the address of force_poison which is only defined in lib/list_debug.c.
>> >> The only call site that uses list_force_poison() is in
>> >> devm_memremap_pages().  That currently depends on CONFIG_ZONE_DEVICE
>> >> which in turn depends on X86_64.
>> >>
>> >> So, this appears to be a false positive and the address of
>> >> force_poison is somehow ending up on the stack by accident as that is
>> >> the random value being passed in from __down_common:
>> >>
>> >>     struct semaphore_waiter waiter;
>> >>
>> >>     list_add_tail(&waiter.list, &sem->wait_list);
>> >>
>> >> So, I think we need a more unique poison value that should never
>> >> appear on the stack:
>> >
>> > Unfortunately I can still see the warning after applying this test patch.
>> >
>> > Then I added debug code to print the pointer value and re-ran the test.
>> > All five failures printed the same pointer value, failed in the same
>> > pattern:
>> >
>> > list_add attempted on force-poisoned entry(0000000000000500), new->next = c00000000136bc00, new->prev = 0000000000000500
>> >
>>
>> I think this means that no matter what we do the stack will pick up
>> these poison values unless the list_head is explicitly initialized.
>> Something like the following:
>
> Umm, it's still reproducible... but seems harder than before, it took me
> 200+ iterations to hit (less than 10 iterations in previous runs)

Similar fix, just in rwsem_down_read_failed() this time:

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index a4d4de05b2d1..68678a20da52 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -214,8 +214,10 @@ __visible
struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
{
       long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
-       struct rwsem_waiter waiter;
       struct task_struct *tsk = current;
+       struct rwsem_waiter waiter = {
+               .list = LIST_HEAD_INIT(waiter.list),
+       };

       /* set up my own style of waitqueue */
       waiter.task = tsk;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
