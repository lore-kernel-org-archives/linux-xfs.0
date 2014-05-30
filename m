Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5D2607F59
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 14:10:33 -0500 (CDT)
Message-ID: <5388D7A8.5040906@sgi.com>
Date: Fri, 30 May 2014 14:10:32 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 2/10] xfs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
References: <001e01cf7b0f$ba43dfd0$2ecb9f70$@samsung.com>
	<20140530140551.GC6226@bfoster.bfoster>
In-Reply-To: <20140530140551.GC6226@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>, linux-fsdevel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com

On 05/30/14 09:05, Brian Foster wrote:
> On Thu, May 29, 2014 at 04:29:29PM +0900, Namjae Jeon wrote:
>> >  This patch implements fallocate's FALLOC_FL_INSERT_RANGE for XFS.
>> >
>> >  1) Make sure that both offset and len are block size aligned.
>> >  2) Update the i_size of inode by len bytes.
>> >  3) Compute the file's logical block number against offset. If the computed
>> >      block number is not the starting block of the extent, split the extent
>> >      such that the block number is the starting block of the extent.
>> >  4) Shift all the extents which are lying bewteen [offset, last allocated extent]
>> >      towards right by len bytes. This step will make a hole of len bytes
>> >      at offset.
>> >  5) Allocate unwritten extents for the hole created in step 4.
>> >
>> >  Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
>> >  Signed-off-by: Ashish Sangwan<a.sangwan@samsung.com>
>> >  Reviewed-by: Brian Foster<bfoster@redhat.com>
>> >  ---
>> >
>> >  Changelog
>> >  v4:
>> >    - set cur->bc_private.b.allocated to zero before calling xfs_btree_del_cursor.
>> >
> Other issues not withstanding (sounds like Mark still has a lingering,
> potential corruption case), this fixes the warnings I was seeing. I ran
> through an xfstest cycle without problem. Thanks for fixing this.
>
> The cursor allocated flag appears to be used to carry bmbt block
> allocations over to delayed allocation extent conversions (such that
> these allocations are accounted from previous delalloc extent index
> block reservations). This is all within the bmbt code, so clearing the
> flag seems reasonable as well.
>
> Though I wonder why it falls on the caller to clear the flag as opposed
> to fixing up the flag automatically when it becomes accounted for. I
> guess that would enable a warning with semantics of "something might
> have been unaccounted for" vs. "somebody forgot to reset a flag." That
> said, it's likely there are circumstances involved with this mechanism
> that I'm not yet familiar with.;)
>
> Brian
>

I did not have this patch included in my tests just the code from Linux 
3.15-rc5. I will add and see if it still asserts.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
