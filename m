Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6402931DD;
	Fri, 17 Jul 2026 23:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784329202; cv=none; b=InPk19Z8K+x19T7ZulZ7HgjLq1BoOwTsP0AAXTgET9jqkzbbB7hzIDC+SfkzKUV/pOhVfBK880NneVNKDcfoF5Vb8Gcn3snh5Yx6IVELlu5wZfuyo52PyzF46FFAMiVb+ES0l+32ec7RGPVh3yOe7vdLIAK9C4or5BsULMh4oxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784329202; c=relaxed/simple;
	bh=2u8ALFZ6YE6ZKMGvyN98/boU9rltogw4pNgvfzojeSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rk3UYfGgnXmf1qjdUBcNTVXltmLjMHTVKABc+pTo0MEh4IyaQ56eyhejiIfWd418/vL4XfX495b/6nEV7pXSqqN54knrXWP1bepjC+u4nBgRFtLyz1/w7fld2VcmWuK9FTh7Ji23vwxiRmH0UuQNei9FJOFiaI10n+pQcC+TkZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J3Ey7Fmh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J3Ey7Fmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8ED1F000E9;
	Fri, 17 Jul 2026 22:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784329200;
	bh=2TKTDb1tGYOIXQyLJo5z2yiksi1AjNS98RCd6jfO48E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J3Ey7FmhUZNg+wu9milBhD4kHZSymM9cTlITSozkZpRPDlwDBVtYfePe9/J4/sFlE
	 t8Z8AL7pMfU4NhmvFP4B48Ans1gVIn9NwwzWTIdFPvLWzfk/7N06OwJDlExVnYR/lS
	 GLvfIt74aaN8mLWNewdx/t5ALucew3zTxjH7JtPcU7zSDschrHiEE+YoEZ0VT5T+RF
	 IBM1qmGWfTLTTzF+DgvOXNk0ijPE/oqzqs4A89lXN/poPItnvpiOqMUyQ45E9quV8h
	 XX4gKa51DiM8SG+K3IMx/t9L4rjgie5HHimwamxsYEDgoCkWRJHZ+eZly4+ybe/lfy
	 Mh5T0bPMYdFdQ==
Date: Sat, 18 Jul 2026 08:59:51 +1000
From: Dave Chinner <dgc@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, xmei5@asu.edu
Subject: Re: [PATCH v2 1/2] xfs: reject log items with missing regions during
 recovery
Message-ID: <alqz56ytl_69qJ8I@dread>
References: <20260717192408.109168-1-bestswngs@gmail.com>
 <20260717192408.109168-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260717192408.109168-2-bestswngs@gmail.com>

On Fri, Jul 17, 2026 at 12:24:07PM -0700, Weiming Shi wrote:
> Each recovered log item is assembled in xlog_recover_add_to_trans() into
> an ri_buf[] of ri_total (= the format's declared region count) slots, and
> the regions actually logged are counted in ri_cnt. Nothing checks that
> ri_cnt reached ri_total once the transaction is complete, so a crafted or
> truncated log can present an item whose format declares more regions than
> were logged. The trailing ri_buf[] slots are then NULL, and the reorder,
> readahead and replay code dereference them.
> 
> For example, an XFS_LI_INODE item declaring two regions but logging only
> the format region leaves ri_buf[1] NULL, and mount-time recovery faults
> dereferencing it as the log dinode:
> 
>  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>  RIP: xlog_recover_inode_commit_pass2 (fs/xfs/xfs_inode_item_recover.c:370)
>  Call Trace:
>   xlog_recover_items_pass2 (fs/xfs/xfs_log_recover.c:2011)
>   xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2078)
>   xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2328)
>   xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2502)
>   xlog_recover (fs/xfs/xfs_log_recover.c:3486)
>   xfs_log_mount (fs/xfs/xfs_log.c:667)
>   xfs_mountfs (fs/xfs/xfs_mount.c:1039)
>   xfs_fs_fill_super (fs/xfs/xfs_super.c:1965)
>   get_tree_bdev_flags (fs/super.c:1680)
>   __x64_sys_mount (fs/namespace.c:4433)
> 
> Whether an item logged all its declared regions is a generic log format
> property, not a per-item-type concern, so reject any item with a missing
> region in xlog_recover_commit_trans() before the item ops run.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  fs/xfs/xfs_log_recover.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 09e6678ca487..5250d512a392 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2039,6 +2039,17 @@ xlog_recover_commit_trans(
>  
>  	hlist_del_init(&trans->r_list);
>  
> +	/*
> +	 * Reject an item missing a region its format declared; the NULL slot
> +	 * would be dereferenced by the reorder and replay code.
> +	 */
> +	list_for_each_entry(item, &trans->r_itemq, ri_list) {
> +		if (XFS_IS_CORRUPT(log->l_mp,
> +				   item->ri_total == 0 ||
> +				   item->ri_cnt != item->ri_total))
> +			return -EFSCORRUPTED;
> +	}

Ok, that's a good start - you've identified roughly where to place
generic log item verification, and added a check that captures all
rebuild log items. We can build on this!

If you look in xlog_recover_add_to_trans(), you'll find that it
already a bunch of log item sanity checks when each region is
processed and added to the current item. We decide there when we are
not going to decode any more regions for the current item there, and
that's the point at which overall log item state and region layout
should be verified.

Even at this point, we should know what the log item type is (it is
the first 2 bytes of each log item being decoded, and we're already
using (and trusting the second 2 bytes of the region to tell us how
many regions there are in the log item. There needs to be much more
robust verification at this point, because we are already trusting
the information we read from disk to be correct for building the
structures we use for further verification and decoding later on.

There are some checks on the new item, but they are not
comprehensive, nor is it made clear that this is the layer that we
should be doing those comprehensive verification tests of the
recovered log item structure. There probably shouldbe two functions
called here - one to verify the finishing log item before we start
parsing the new one, and a function to comprehensively verify the
header in the new log item is valid. (e.g. does known type checks,
does bounds checks like checking the number of regions against known
type maximums, etc). For non-header regions, they should be checked
for size (because we know the type, we know the max size any region
in that item should be) and not having a known log item type in the
first two bytes (i.e. we hit a new log item header before we
expected it).

This is the sort of robust verification we need; it's not just
adding the one check the LLM discovered was missing, and then moving
all the existing checks to another function. It's about analysing
what the code is doing, what it is missing and then coming up with a
clean abstraction that captures all the issues in one go.

LLMs are already very capable of analysing these sorts of issues and
finding all the problems for you - you just have to point it in the
right direction. Once you do that, it will find more issues in the
code than anyone realised.

For example, I just pointed a 6 month old LLM model at
fs/xfs/xfs_log_recover.c and asked it to perform this very analysis.
This is not a current state-of-the-art frontier model, but it points
out just how good even older models are when driven with a little
bit of knowledge.

I've included the full output from it, this is entirely what the LLM
came up with from my prompt. You'll note that I haven't done any
trendy "treat the LLM like a dummy that needs micromanagement"
prompt engineering - I've just explained the situation like I would
to another subject matter expert, and asked it to provide analysis
and a plan for robust verification. I assume the LLM understands
what I am saying like any other experienced, knowledgable expert
would....

❯ ok, we're in a new branch, and we are looking at log recovery - go read fs/xfs/xfs_log_recover.c as preparation.

● Bash(git branch --show-current)
  ⎿  log-verification

  Read 1 file (ctrl+o to expand)

● I've read the entire file. Ready for your question about log recovery.

✻ Brewed for 24s

❯ ok, so when we are first decoding log items from the journal in xlog_recover_add_to_trans() to rebuild each log item from the individual
  ophdr regions in the journal, look at the first 4 bytes of the region to decode the number of regions in the time. We then process than
  number of regions adding them to the current item, then when the item is full, we start a new item and pull the number of regions that
  from the first 4 bytes of the region. These log items are later parsed as structures, so if this code gets anything wrong, we risk crashes
  and buffer overruns in later processing. If you assume that we cannot actually trust the data in each region being decoded to build the
  log items, perform analysis to determine the issues the existing code does not catch and propose a plan to robustly verify the ophdr-based
  region data we are decoding and using to build the log items.

● Let me trace through the code paths carefully, looking at every place we trust unverified data.

  Read 1 file (ctrl+o to expand)

● Now let me check what calls this and how dp/len are validated.

  Read 1 file (ctrl+o to expand)

● Now let me look at the continuation case and check what structures consume these regions later.

  Read 1 file (ctrl+o to expand)

● Now let me check how the log item ops consume these regions. Let me look at a couple of examples.

  Searched for 2 patterns, read 1 file (ctrl+o to expand)

● Now let me look at a few consumers to see how they trust the region data. Let me check the buffer item and inode item recovery.

  Searched for 4 patterns, read 1 file (ctrl+o to expand)

● Now let me check the ITEM_TYPE macro and how it's used to classify items.

  Searched for 1 pattern (ctrl+o to expand)

● Now let me check the ophdr flags and how split regions work with continuations.

  Searched for 1 pattern (ctrl+o to expand)

● Now let me check how the op header oh_len field is validated.

  Searched for 1 pattern (ctrl+o to expand)

● Now I have the full picture. Here's the analysis:

  ---
  Analysis: Untrusted data in log item region decoding

  Data flow

  1. xlog_recover_process_data() walks ophdr records from the log record data
  2. Each ophdr has oh_len, oh_flags, oh_tid, oh_clientid
  3. The ophdr data region (dp, len) is passed to xlog_recover_add_to_trans() or xlog_recover_add_to_cont_trans()
  4. add_to_trans() casts the first bytes of region data to struct xfs_inode_log_format and reads ilf_size to get the region count
  5. Regions are accumulated into ri_buf[] arrays
  6. Later, commit_pass1/commit_pass2 cast ri_buf[0].iov_base to format-specific structures and access fields to drive recovery (block
  numbers, inode numbers, data lengths, etc.)

  Issues identified

  1. No minimum length check on the region count field (line 2224-2235)

  When item->ri_total == 0 (first region of a new item), the code reads in_f->ilf_size from the data. But it only checks ilf_size == 0 and
  ilf_size > XLOG_MAX_REGIONS_IN_ITEM. It does NOT check that len >= sizeof(uint16_t) * 2 (the type and size fields). If len is very small
  (e.g. 4 bytes from a split region), ilf_size could be reading from valid but meaningless data. The comment at line 2157-2168 acknowledges
  this possibility ("it could be the first part of a new region") but the code doesn't validate that the data is large enough to contain the
  fields it reads.

  Actually, the ilf_size field is at offset 2 in the structure (after the 2-byte type field). If len < 4, we're reading off the end of the
  allocated ptr buffer — though xlog_kvmalloc may allocate more than requested due to slab rounding. Still, the value read would be garbage.

  2. No validation that ri_buf[0].iov_len is large enough for the format structure (ITEM_TYPE macro, line 120)

  ITEM_TYPE(i) does *(unsigned short *)(i)->ri_buf[0].iov_base. If ri_buf[0].iov_len < 2, this reads beyond the buffer. This is used in
  xlog_find_item_ops() (line 1837) and xlog_recover_reorder_trans() (line 1919) before any per-item validation occurs.

  3. No per-item-type validation of ri_cnt against expected region counts

  Each log item type expects a specific number of regions (e.g. inode items expect 2-4 regions, buffer items expect at least 2). But the
  region count comes from the first 4 bytes of untrusted data (ilf_size). If this value is wrong — say too large — we'll accumulate too many
  regions into the item, and when commit_pass2 accesses ri_buf[2] or ri_buf[3] they may contain data from a completely different log item's
  regions.

  4. Continuation regions (add_to_cont_trans) don't validate ri_cnt

  At line 2144, add_to_cont_trans() accesses item->ri_buf[item->ri_cnt-1] without checking that ri_cnt > 0. If the continuation arrives for
  an item with ri_cnt == 0, this is an underflow accessing ri_buf[-1].

  5. No validation that ri_buf is allocated before continuation

  If add_to_cont_trans() is called and the item has ri_total == 0 (no first region was ever added to set up the buf array), item->ri_buf is
  NULL. The access at line 2144 would be a NULL pointer dereference.

  6. The transaction header can be partially overwritten

  In add_to_trans() (line 2205), memcpy(&trans->r_theader, dp, len) writes len bytes. In add_to_cont_trans() (line 2134-2136), the
  continuation writes to r_theader + sizeof - len. But there's no tracking of how much of r_theader has been filled. If a corrupt log sends
  two partial headers that together exceed sizeof(xfs_trans_header), the second copy in add_to_cont_trans() calculates a negative offset and
  writes before the structure.

  Actually, line 2127-2128 checks len <= sizeof(struct xfs_trans_header) in the continuation case. But it doesn't check that len is exactly
  the remaining bytes. If the first call wrote 8 bytes and the continuation sends sizeof(xfs_trans_header) bytes, it would write past the
  structure.

  7. oh_len can be zero, skipping the region silently

  At line 2181, if (!len) return 0 silently ignores zero-length regions. But this means the ophdr's data is skipped without any accounting.
  If a corrupt ophdr has oh_len == 0 but oh_flags indicates it's a data continuation, the item's region assembly could get out of sync.

  8. No validation of region data against item type expectations in add_to_trans

  When adding the first region of a new item, we trust ilf_size to know how many regions to expect. But we don't verify that the item_type
  encoded in the first two bytes is a known type at this point. Unknown types with arbitrary ilf_size values could cause large allocations.
  The type check happens much later in xlog_recover_reorder_trans().

  9. Per-item-type commit handlers trust ri_buf lengths without validation

  Looking at the consumers:
  - Buffer recovery (line 1015): buf_f = item->ri_buf[0].iov_base — cast without checking ri_buf[0].iov_len >= sizeof(struct
  xfs_buf_log_format). Then reads buf_f->blf_blkno, buf_f->blf_len, buf_f->blf_flags which drive buffer reads from disk.
  - Inode recovery (line 369): ldip = item->ri_buf[1].iov_base — accesses ri_buf[1] without checking ri_cnt >= 2.
  - Inode recovery (line 503-504): accesses ri_buf[2] for data fork recovery without verifying ri_cnt >= 3.

  10. ophdr oh_len is not validated against alignment requirements

  The comment at line 2157-2160 says "all regions must be 32 bit aligned". But oh_len is not checked for 4-byte alignment in
  xlog_recover_process_ophdr() or xlog_recover_process_data(). A non-aligned oh_len would cause subsequent ophdr parsing to read from
  misaligned addresses.

  Proposed validation approach

  The fixes fall into two categories:

  A. Structural validation in the region assembly code (add_to_trans / add_to_cont_trans):
  - Validate len >= 4 before reading ilf_size (the type+size fields)
  - Validate ri_cnt > 0 and ri_buf != NULL before continuation
  - Track how much of r_theader has been filled to prevent overflow
  - Validate oh_len alignment in process_data/process_ophdr

  B. Per-item-type validation before commit handlers run:
  - Add a validate callback to xlog_recover_item_ops that each item type implements
  - Call it after item assembly is complete (in xlog_recover_reorder_trans or before commit_pass1/commit_pass2)
  - Each validate function checks ri_cnt matches expected region count for the item type, and ri_buf[N].iov_len >=
  sizeof(expected_format_struct) for each region
  - This is the robust approach: each item type knows its own format and can validate before any cast/access

✻ Worked for 2m 28s

-----

So, in under 5 minutes, I have a list of ~10 issues with this code,
they are roughly categorised into header vs item-type issues, and
the LLM has a good idea of how to cleanly separate the two different
layers of verification.

IOWs, the LLM has largely identified the issues I already have
mentioned, and it's even identified that there needs to be split
between generic log item region verification and type specific log
item structure verification.

LLMs simply very powerful pattern matching, statistical prediction
machines. They are very good at seeing the patterns in code that
humans have difficult seeing, and they are generally are able to
predict how to fix them fairly well.

I'd now go and discuss the details of the fixes, the verification
architecture, etc with the LLM as I would with any other peer, to
deepen my understanding of the problem and the potential solution
space. The LLM will understand what I am saying and help perform
deep analysis very quickly, but it won't solve all the problems for
me. I will still need to direct/design/architect the solution
myself, but eventually a solid plan will fall out of the process.
yourself. This would probably take me another 10 minutes.

Make use of this power - never work at "code level" with the LLM,
always work at a high level (architecture, design, analysis,
planning, etc) in your native language. Only both you and the LLM
understand the problem and the solution to the problem at the high
level should you break down the work into "coding".

When it's time to start "coding", I first get the LLM to break the
solution down into a series of single-change-per-patch
modifications. It effectively does the detailed design work for the
code at this point, and all I do is work with it so that the overall
patchset and the modification being done in each patch make sense.
This usually takes a couple of minutes.

Then I let it start generating code.  I review the code the LLM
generates hunk by hunk - always interactive, never let it just go
and do what it wants - and I fix problems immediately. I don't move
on until I'm happy with the code in each patch. The code ends up how
I would have wrote it, but it gets each patch written in a couple
minutes instead of tens of minutes or hours.

This overall process should be familiar to everyone - it's the
classic software engineering "waterfall" model applied to the LLM
domain. I've found it works -really well- for analysing and solving
complex problems with LLMs.

In the end, I've spend longer writing this email explaining how to
drive the LLM to understand and fix the underlying issue than I
would have taken using an LLM to generate the entire log item
verification patchset ready for test and review....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
