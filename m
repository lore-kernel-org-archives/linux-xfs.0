Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751771AbdAMPtN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 10:49:13 -0500
Date: Fri, 13 Jan 2017 10:49:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_logprint: handle the log split of inode item
 correctly
Message-ID: <20170113154911.GF22013@bfoster.bfoster>
References: <1484141938-4195-1-git-send-email-houtao1@huawei.com>
 <20170112133411.GC14085@bfoster.bfoster>
 <50e8cc9c-a941-4e16-449c-2b667f282eed@sandeen.net>
 <cd390269-7e43-72e6-05f1-6d90b5022639@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd390269-7e43-72e6-05f1-6d90b5022639@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Fri, Jan 13, 2017 at 11:28:34AM +0800, Hou Tao wrote:
> 
> On 2017/1/12 22:38, Eric Sandeen wrote:
> >> So what is the problem with the existing code? You need to describe the
> >> problematic log state and the existing code flow in more detail (i.e.,
> >> which op record covering the inode format is split across a log record?
> >> what is the observed logprint behavior?) in the commit log description,
> >> particularly since this is likely not a state easily tested/reproduced.
> > 
> > I agree - I hadn't reviewed this yet because xfs_logprint is
> > very confusing and complicated anyway, and I wasn't quite
> > clear on the problem or the resolution here.
> Sorry for the confusion. Thanks for Brian's review.
> 
> >> So it appears the inode item can have 2-4 op records: the format, core
> >> inode and optionally the data and attr forks. Up to this point, we've
> >> printed the format and core, which is two ops. If we hit the end of the
> >> log record, we need to return the number of remaining ops in the format
> >> so the subsequent record iteration can skip them and find the first new
> >> transaction...
> >> ... which afaict, the above check does. E.g., If we've printed two ops
> >> out of three and hit the record op count, return 1 op to skip.
> >>
> >> So what are we trying to fix here? Is the problem that i isn't bumped
> >> before we return, or that we're missing some information that should be
> >> printed by the hunk that follows this check? Or am I missing something
> >> else..?
> > A testcase would help us understand.  :)
> If the data/attr fork log operation of an inode log item are splitted to the
> next log record, xfs_logprint doesn't check the remaining log operations in
> current log record and still tries to print these log operations which don't
> exist in the log record. The content of these log operations will be incorrect,
> or worse xfs_logprint will trigger an segment-fault and exit.
> 
> xfs_logprint also doesn't calculate the count of the splitted log operations
> correctly. It just returns 1 when the current log operation is splitted to
> the next log record. xfs_logprint needs to consider the log operations behind.
> 

Ok, though I'm still unclear on where this applies to the code...

> As we can see from the following example, there are only 243 operations in
> the first log record, but xfs_logprint shows the 244th operation and the length
> of the operation is invalid.
> 
> The first operation of the second log record comes from the split, but
> xfs_logprint doesn't show something likes "Left over region from split log item"
> to clarify it.
> 

Thank you for the example. This helps clarify the problem.

> ============================================================================
> cycle: 120  version: 2      lsn: 120,11014  tail_lsn: 120,427
> length of Log Record: 32256 prev offset: 10984      num ops: 243
> ......
> h_size: 32768
> ----------------------------------------------------------------------------
> Oper (0): tid: 2db4353b  len: 0  clientid: TRANS  flags: START
> ......
> ----------------------------------------------------------------------------
> Oper (240): tid: 2db4353b  len: 56  clientid: TRANS  flags: none

So we have the 243 op count record and get to this 4 op count inode
transaction. The 4th op header happens to be split off into the next log
record...

> INODE: #regs: 4   ino: 0x200a4bf  flags: 0x45   dsize: 64
>         blkno: 10506832  len: 16  boff: 7936
> Oper (241): tid: 2db4353b  len: 96  clientid: TRANS  flags: none
> INODE CORE
> ......
> Oper (242): tid: 2db4353b  len: 64  clientid: TRANS  flags: none
> EXTENTS inode data

The first 3 op headers (240-242) appear to print fine, but there is no
num_ops validation against '*i' between the 3rd and 4th ops. We just
blindly increment i to 243, print and carry on as if nothing was
skipped.

Could you update the commit log description to be very specific with
regard to the problem here? For example, point out that if an inode item
happens to have 4 op headers and the 4th exists after a log record
boundary, we don't handle the op count correctly and print invalid data.

Also for reference (and since this is difficult to test/verify), could
you also reply with the new output for this situation with the patched
logprint? Thanks.

Brian

> Oper (243): tid: 150000  len: 83886080  clientid: ERROR  flags: none
> LOCAL attr data
> ============================================================================
> cycle: 120  version: 2      lsn: 120,11078  tail_lsn: 120,427
> length of Log Record: 3584  prev offset: 11014      num ops: 44
> ......
> ----------------------------------------------------------------------------
> Oper (0): tid: 2db4353b  len: 52  clientid: TRANS  flags: none
> ----------------------------------------------------------------------------
> 
> >> Now we set op_head and add the checks below to see if we can increment
> >> to another op header. If not, return the skip count.
> >>
> >> So I think the logic here is Ok, but the existing code is confusing and
> >> so it's not totally clear what you are trying to fix. Also, what I would
> >> suggest is to do something like 'skip_count = f->ilf_size' once near the
> >> top of the function, decrement it at each point as appropriate as we
> >> step through the op headers, then update all of the return points to
> >> just 'return skip_count;'. Thoughts?
> "skip_count" is better than the "printed_ops" one.
> 
> >>
> >>>      if (f->ilf_fields & XFS_ILOG_DFORK) {
> >>> +		if (*i == num_ops-1)
> >>> +		return f->ilf_size-printed_ops;
> >>
> >> I'm not really sure what we want to do here with regard to indentation
> >> inconsistency with existing code. The existing code uses 4 spaces vs.
> >> this patch using tabs. Perhaps that's a question for Eric..
> > 
> > Yeah, I'd say try to follow the surrounding code style, but regardless,
> > code under conditionals should be indented in /some/ way.
> The existing code mixes the usage of 4 spaces and tab, and there is no
> indentation for the statement under conditionals.
> 
> If the above explanation is OK, I will send a V2 patch.
> 
> Regards.
> 
> Tao
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
