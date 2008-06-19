Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 01:36:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5J8aDT8008846
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:36:14 -0700
Date: Thu, 19 Jun 2008 18:39:55 +1000
Subject: Re: [PATCH] XFS: Fix returning case-preserved name with CI node form directories
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ucxszl2d3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080619083243.GA8821@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.uczmctru3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080619083243.GA8821@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, 19 Jun 2008 18:32:43 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Wed, Jun 18, 2008 at 07:07:59PM +1000, Barry Naujok wrote:
>> xfs_dir2_node_lookup() calls xfs_da_node_lookup_int() which iterates
>> through leaf blocks containing the matching hash value for the name
>> being looked up. Inside xfs_da_node_lookup_int(), it calls the
>> xfs_dir2_leafn_lookup_for_entry() for each leaf block.
>> xfs_dir2_leafn_lookup_for_entry() iterates through each matching
>> hash/offset pair doing a name comparison to find the matching
>> dirent.
>>
>> For CI mode, the state->extrablk retains the details of the block
>> that has the CI match so xfs_dir2_node_lookup() can return the
>> case-preserved name.
>>
>> The original implementation didn't retain the xfs_da_buf_t properly,
>> so the lookup was returning a bogus name to be stored in the dentry.
>>
>> In the case of unlink, the bad name was passed and in debug mode,
>> ASSERTed when it can't find the entry.
>
> Looks good to me, although I don't really like how much of a mess
> xfs_dir2_leafn_lookup_for_entry has become. No idea for a nice why
> to write it, though.

Yeah, bit of a problem with that. I can un-optimise the original code
by not keeping the current block between calls to
xfs_dir2_leafn_lookup_for_entry() and always freeing it. That will
clean it up a lot.

> Btw, any chance we could get some CI tests in xfsqa?  Looks like you
> have quite a few testcases that found issues so far.

Yes, they are coming.

Barry.
