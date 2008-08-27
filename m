Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 17:31:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7R0VnBa031355
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 17:31:50 -0700
Date: Wed, 27 Aug 2008 10:33:50 +1000
Subject: Re: REVIEW: xfs_repair fixes for bad directories
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.udlsirmx3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <20080826193205.GA31105@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugiruov13jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080826193205.GA31105@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, 27 Aug 2008 05:32:05 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Tue, Jul 01, 2008 at 06:00:17PM +1000, Barry Naujok wrote:
>> Two issues have been encounted with xfs_repair and badly corrupted
>> directories.
>>
>> 1. A huge size (inode di_size) can cause malloc which will fail.
>>    Patch dir_size_check.patch checks for a valid directory size
>>    and if it's bad, junks the directory. The di_size for a dir
>>    only counts the data blocks being used, not all the other
>>    associated metadata. This is limited to 32GB by the
>>    XFS_DIR2_LEAF_OFFSET value in XFS. Anything greater than this
>>    must be invalid.
>
> As menioned before this one is trivial nad makes sens.
>
>> 2. An update a while ago to xfs_repair attempts to fix invalid
>>    ".." entries for subdirectories where there is a valid parent
>>    with the appropriate entry. It was a partial fix that never
>>    did the full job, especially if the subdirectory was short-
>>    form or it has already been processed.
>>
>>    Patch fix_dir_rebuild_without_dotdot_entry.patch creates a
>>    post-processing queue after the main scan to update any
>>    directories with an invalid ".." entry.
>
> Where is the existing attemp?  I can't find code doing anything like
> that removed in the patch.  But the actual patch looks good, while
> I had this mess with the tons of different boolean flags in repair
> converting these to a more descriptive bitmask should be a different
> patch.
>
>> Both these patches sit on top of the dinode.patch that has been
>> posted out for review previously.
>
> But you didn't get a review for it, did you?  Looked over it briefly
> and it looks good to m.  Again the new code is much much mor readable.

Yeah, Chandan did a good review a while ago and has been checked in now.
