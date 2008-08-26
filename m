Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 19:06:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7Q266B1013859
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 19:06:07 -0700
Date: Tue, 26 Aug 2008 12:08:27 +1000
Subject: Re: REVIEW: xfs_repair fixes for bad directories
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.udlsirmx3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <20080701081306.GA11135@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugg1kdqw3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080701081306.GA11135@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, 01 Jul 2008 18:13:06 +1000, Christoph Hellwig <hch@infradead.org>  
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
> This one looks good.
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
> For this one I'll need to read the surrounding code first to do
> a useful review, so it'll take some time.

Ping?
