Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 90F077CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 17:36:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 179EBAC003
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 15:36:31 -0700 (PDT)
Received: from mail-qe0-f47.google.com (mail-qe0-f47.google.com
	[209.85.128.47]) by cuda.sgi.com with ESMTP id svzw4HiQ1ggxWAQj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Jul 2013 15:36:29 -0700 (PDT)
Received: by mail-qe0-f47.google.com with SMTP id b10so2008131qen.34
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 15:36:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51F7BB2A.2090803@redhat.com>
References: <1375178347-29037-1-git-send-email-zwu.kernel@gmail.com>
	<51F7BB2A.2090803@redhat.com>
Date: Wed, 31 Jul 2013 06:36:13 +0800
Message-ID: <CAEH94LgDG9iaHYsh0t=oq+AXfMGw_7WywzVeDsRHMbBEYrrZtQ@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: introduce object readahead to log recovery
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>

On Tue, Jul 30, 2013 at 9:10 PM, Brian Foster <bfoster@redhat.com> wrote:
> On 07/30/2013 05:59 AM, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   It can take a long time to run log recovery operation because it is
>> single threaded and is bound by read latency. We can find that it took
>> most of the time to wait for the read IO to occur, so if one object
>> readahead is introduced to log recovery, it will obviously reduce the
>> log recovery time.
>>
>> Log recovery time stat:
>>
>>           w/o this patch        w/ this patch
>>
>> real:        0m15.023s             0m7.802s
>> user:        0m0.001s              0m0.001s
>> sys:         0m0.246s              0m0.107s
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>
> Cool patch. I'm not terribly familiar with the log recovery code so take
> my comments with a grain of salt, but a couple things I noticed on a
> quick skim...
>
>>  fs/xfs/xfs_log_recover.c | 162 +++++++++++++++++++++++++++++++++++++++++++++--
>>  fs/xfs/xfs_log_recover.h |   2 +
>>  2 files changed, 159 insertions(+), 5 deletions(-)
>>
> ...
>>
>> +STATIC int
>> +xlog_recover_items_pass2(
>> +     struct xlog                     *log,
>> +     struct xlog_recover             *trans,
>> +     struct list_head                *buffer_list,
>> +     struct list_head                *ra_list)
>
> A nit, but technically this function doesn't have to be involved with
> readahead. Perhaps rename ra_list to item_list..?
ok, applied.
>
>> +{
>> +     int                     error = 0;
>> +     xlog_recover_item_t     *item;
>> +
>> +     list_for_each_entry(item, ra_list, ri_list) {
>> +             error = xlog_recover_commit_pass2(log, trans,
>> +                                       buffer_list, item);
>> +             if (error)
>> +                     return error;
>> +     }
>> +
>> +     return error;
>> +}
>> +
>>  /*
>>   * Perform the transaction.
>>   *
>> @@ -3189,9 +3314,11 @@ xlog_recover_commit_trans(
>>       struct xlog_recover     *trans,
>>       int                     pass)
>>  {
>> -     int                     error = 0, error2;
>> -     xlog_recover_item_t     *item;
>> +     int                     error = 0, error2, ra_qdepth = 0;
>> +     xlog_recover_item_t     *item, *next;
>>       LIST_HEAD               (buffer_list);
>> +     LIST_HEAD               (ra_list);
>> +     LIST_HEAD               (all_ra_list);
>>
>>       hlist_del(&trans->r_list);
>>
>> @@ -3199,14 +3326,21 @@ xlog_recover_commit_trans(
>>       if (error)
>>               return error;
>>
>> -     list_for_each_entry(item, &trans->r_itemq, ri_list) {
>> +     list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
>>               switch (pass) {
>>               case XLOG_RECOVER_PASS1:
>>                       error = xlog_recover_commit_pass1(log, trans, item);
>>                       break;
>>               case XLOG_RECOVER_PASS2:
>> -                     error = xlog_recover_commit_pass2(log, trans,
>> -                                                       &buffer_list, item);
>> +                     if (ra_qdepth++ >= XLOG_RECOVER_MAX_QDEPTH) {
>
> The counting mechanism looks strange and easy to break with future
> changes. Why not increment ra_qdepth in the else bracket where it is
> explicitly tied to the operation it tracks?
ok.
>
>> +                             error = xlog_recover_items_pass2(log, trans,
>> +                                             &buffer_list, &ra_list);
>> +                             list_splice_tail_init(&ra_list, &all_ra_list);
>> +                             ra_qdepth = 0;
>
> So now we've queued up a bunch of items we've issued readahead on in
> ra_list and we've executed the recovery on the list. What happens to the
> current item?
Good catch, the current item was missed. Done.
>
> Brian
>
>> +                     } else {
>> +                             xlog_recover_ra_pass2(log, item);
>> +                             list_move_tail(&item->ri_list, &ra_list);
>> +                     }
>>                       break;
>>               default:
>>                       ASSERT(0);
>> @@ -3216,9 +3350,27 @@ xlog_recover_commit_trans(
>>                       goto out;
>>       }
>>
>> +     if (!list_empty(&ra_list)) {
>> +             error = xlog_recover_items_pass2(log, trans,
>> +                             &buffer_list, &ra_list);
>> +             if (error)
>> +                     goto out;
>> +
>> +             list_splice_tail_init(&ra_list, &all_ra_list);
>> +     }
>> +
>> +     if (!list_empty(&all_ra_list))
>> +             list_splice_init(&all_ra_list, &trans->r_itemq);
>> +
>>       xlog_recover_free_trans(trans);
>>
>>  out:
>> +     if (!list_empty(&ra_list))
>> +             list_splice_tail_init(&ra_list, &all_ra_list);
>> +
>> +     if (!list_empty(&all_ra_list))
>> +             list_splice_init(&all_ra_list, &trans->r_itemq);
>> +
>>       error2 = xfs_buf_delwri_submit(&buffer_list);
>>       return error ? error : error2;
>>  }
>> diff --git a/fs/xfs/xfs_log_recover.h b/fs/xfs/xfs_log_recover.h
>> index 1c55ccb..16322f6 100644
>> --- a/fs/xfs/xfs_log_recover.h
>> +++ b/fs/xfs/xfs_log_recover.h
>> @@ -63,4 +63,6 @@ typedef struct xlog_recover {
>>  #define      XLOG_RECOVER_PASS1      1
>>  #define      XLOG_RECOVER_PASS2      2
>>
>> +#define XLOG_RECOVER_MAX_QDEPTH 100
>> +
>>  #endif       /* __XFS_LOG_RECOVER_H__ */
>>
>



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
