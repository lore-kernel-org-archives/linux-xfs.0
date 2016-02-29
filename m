Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 598DF7CA0
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 12:22:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 182588F8040
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 10:22:08 -0800 (PST)
Received: from mail-ob0-f170.google.com (mail-ob0-f170.google.com
	[209.85.214.170]) by cuda.sgi.com with ESMTP id
	AXubrLICZcVaErJg (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Feb 2016 10:22:07 -0800 (PST)
Received: by mail-ob0-f170.google.com with SMTP id fz5so10886579obc.0
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 10:22:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160228053158.GK11419@eguan.usersys.redhat.com>
References: <20160227130256.GJ11419@eguan.usersys.redhat.com>
	<CAPcyv4gZKzUsch2RQm-QQWuUHtmtQerz2fstCwbwaMjyzYvwrA@mail.gmail.com>
	<20160228053158.GK11419@eguan.usersys.redhat.com>
Date: Mon, 29 Feb 2016 10:22:06 -0800
Message-ID: <CAPcyv4jNhCkStvwtS54FjJVWAfvMv-gEDjHWq3V7_YTOmk+W2g@mail.gmail.com>
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

On Sat, Feb 27, 2016 at 9:31 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Sat, Feb 27, 2016 at 12:10:51PM -0800, Dan Williams wrote:
>> On Sat, Feb 27, 2016 at 5:02 AM, Eryu Guan <eguan@redhat.com> wrote:
>> > Hi,
>> >
>> > Starting from 4.5-rc1 kernel, I sometimes see generic/320 triggers
>> > "list_add attempted on force-poisoned entry" warnings on XFS, test hosts
>> > are arm64/ppc64/ppc64le, haven't seen it on x86_64 hosts.
>>
>> Hmm, this triggers when a list_head has ->next or ->prev pointing at
>> the address of force_poison which is only defined in lib/list_debug.c.
>> The only call site that uses list_force_poison() is in
>> devm_memremap_pages().  That currently depends on CONFIG_ZONE_DEVICE
>> which in turn depends on X86_64.
>>
>> So, this appears to be a false positive and the address of
>> force_poison is somehow ending up on the stack by accident as that is
>> the random value being passed in from __down_common:
>>
>>     struct semaphore_waiter waiter;
>>
>>     list_add_tail(&waiter.list, &sem->wait_list);
>>
>> So, I think we need a more unique poison value that should never
>> appear on the stack:
>
> Unfortunately I can still see the warning after applying this test patch.
>
> Then I added debug code to print the pointer value and re-ran the test.
> All five failures printed the same pointer value, failed in the same
> pattern:
>
> list_add attempted on force-poisoned entry(0000000000000500), new->next = c00000000136bc00, new->prev = 0000000000000500
>

I think this means that no matter what we do the stack will pick up
these poison values unless the list_head is explicitly initialized.
Something like the following:

diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
index b8120abe594b..39929b4e6fbb 100644
--- a/kernel/locking/semaphore.c
+++ b/kernel/locking/semaphore.c
@@ -205,7 +205,9 @@ static inline int __sched __down_common(struct
semaphore *sem, long state,
                                                               long timeout)
{
       struct task_struct *task = current;
-       struct semaphore_waiter waiter;
+       struct semaphore_waiter waiter = {
+               .list = LIST_HEAD_INIT(waiter.list),
+       };

       list_add_tail(&waiter.list, &sem->wait_list);
       waiter.task = task;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
