Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47582 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbdALOis (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:38:48 -0500
Subject: Re: [PATCH] xfs_logprint: handle the log split of inode item
 correctly
References: <1484141938-4195-1-git-send-email-houtao1@huawei.com>
 <20170112133411.GC14085@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <50e8cc9c-a941-4e16-449c-2b667f282eed@sandeen.net>
Date: Thu, 12 Jan 2017 08:38:46 -0600
MIME-Version: 1.0
In-Reply-To: <20170112133411.GC14085@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org

On 1/12/17 7:34 AM, Brian Foster wrote:
> On Wed, Jan 11, 2017 at 09:38:58PM +0800, Hou Tao wrote:
>> It is possible that the data fork or the attribute fork
>> of an inode will be splitted to the next log record, so
>> we need to check the count of available operations
>> in the log record and calculate the count of skipped
>> operations properly.
>>
> 
> So what is the problem with the existing code? You need to describe the
> problematic log state and the existing code flow in more detail (i.e.,
> which op record covering the inode format is split across a log record?
> what is the observed logprint behavior?) in the commit log description,
> particularly since this is likely not a state easily tested/reproduced.

I agree - I hadn't reviewed this yet because xfs_logprint is
very confusing and complicated anyway, and I wasn't quite
clear on the problem or the resolution here.

>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>  logprint/log_misc.c | 21 ++++++++++++---------
>>  1 file changed, 12 insertions(+), 9 deletions(-)
>>
>> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
>> index a0f1766..20f0f89 100644
>> --- a/logprint/log_misc.c
>> +++ b/logprint/log_misc.c
>> @@ -524,6 +524,7 @@ xlog_print_trans_inode(
>>      xfs_inode_log_format_t *f;
>>      int			   mode;
>>      int			   size;
>> +    int			   printed_ops;
>>  
>>      /*
>>       * print inode type header region
>> @@ -572,13 +573,6 @@ xlog_print_trans_inode(
>>      xlog_print_trans_inode_core(&dino);
>>      *ptr += xfs_log_dinode_size(dino.di_version);
>>  
> 
> So it appears the inode item can have 2-4 op records: the format, core
> inode and optionally the data and attr forks. Up to this point, we've
> printed the format and core, which is two ops. If we hit the end of the
> log record, we need to return the number of remaining ops in the format
> so the subsequent record iteration can skip them and find the first new
> transaction...
> 
>> -    if (*i == num_ops-1 && f->ilf_size == 3)  {
>> -	return 1;
>> -    }
>> -
> 
> ... which afaict, the above check does. E.g., If we've printed two ops
> out of three and hit the record op count, return 1 op to skip.
> 
> So what are we trying to fix here? Is the problem that i isn't bumped
> before we return, or that we're missing some information that should be
> printed by the hunk that follows this check? Or am I missing something
> else..?

A testcase would help us understand.  :)

>> -    /* does anything come next */
>> -    op_head = (xlog_op_header_t *)*ptr;
>> -
> 
> So then op_head is set, may not necessarily be valid, but it isn't
> actually used in this hunk so we can safely proceed without this
> assignment (I'm starting to wonder if this code is intentionally obtuse
> or just by accident :P).

xfs_logprint is a mess :(

>>      switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
>>      case XFS_ILOG_DEV:
>>  	printf(_("DEV inode: no extra region\n"));
>> @@ -595,7 +589,13 @@ xlog_print_trans_inode(
>>      ASSERT(f->ilf_size <= 4);
>>      ASSERT((f->ilf_size == 3) || (f->ilf_fields & XFS_ILOG_AFORK));
>>  
>> +    /* does anything come next */
>> +    printed_ops = 2;
>> +    op_head = (xlog_op_header_t *)*ptr;
>> +
> 
> Now we set op_head and add the checks below to see if we can increment
> to another op header. If not, return the skip count.
> 
> So I think the logic here is Ok, but the existing code is confusing and
> so it's not totally clear what you are trying to fix. Also, what I would
> suggest is to do something like 'skip_count = f->ilf_size' once near the
> top of the function, decrement it at each point as appropriate as we
> step through the op headers, then update all of the return points to
> just 'return skip_count;'. Thoughts?
> 
>>      if (f->ilf_fields & XFS_ILOG_DFORK) {
>> +		if (*i == num_ops-1)
>> +		return f->ilf_size-printed_ops;
> 
> I'm not really sure what we want to do here with regard to indentation
> inconsistency with existing code. The existing code uses 4 spaces vs.
> this patch using tabs. Perhaps that's a question for Eric..

Yeah, I'd say try to follow the surrounding code style, but regardless,
code under conditionals should be indented in /some/ way.

Thanks,
-Eric

> Either way, the indentation of the 'if ()' itself is broken here...
> 
>>  	    (*i)++;
>>  	    xlog_print_op_header(op_head, *i, ptr);
>>  
>> @@ -618,11 +618,14 @@ xlog_print_trans_inode(
>>  
>>  	    *ptr += be32_to_cpu(op_head->oh_len);
>>  	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
>> -		return 1;
>> +		return f->ilf_size-printed_ops;
>>  	    op_head = (xlog_op_header_t *)*ptr;
>> +		printed_ops++;
>>      }
>>  
>>      if (f->ilf_fields & XFS_ILOG_AFORK) {
>> +		if (*i == num_ops-1)
>> +		return f->ilf_size-printed_ops;
> 
> ... and the same thing here.
> 
> Brian
> 
>>  	    (*i)++;
>>  	    xlog_print_op_header(op_head, *i, ptr);
>>  
>> @@ -644,7 +647,7 @@ xlog_print_trans_inode(
>>  	    }
>>  	    *ptr += be32_to_cpu(op_head->oh_len);
>>  	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
>> -		return 1;
>> +		return f->ilf_size-printed_ops;
>>      }
>>  
>>      return 0;
>> -- 
>> 2.5.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
