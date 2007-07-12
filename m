Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 17:15:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6C0FMbm021904
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 17:15:24 -0700
Date: Thu, 12 Jul 2007 10:19:11 +1000
Subject: Re: REVIEW: zero existing secondary superblocks with mkfs.xfs -f
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.tvamambx3jf8g2@pc-bnaujok.melbourne.sgi.com> <46951C0A.4080505@sandeen.net>
Message-ID: <op.tvbsh9z43jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <46951C0A.4080505@sandeen.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Thu, 12 Jul 2007 04:06:02 +1000, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Barry Naujok wrote:
>> The attached patch zeros all the secondary superblocks if
>> overwriting an existing XFS filesystem.
>>
>> This allows xfs_repair to detect the correct secondary block
>> if the primary is destroyed (like XFS QA test 030).
>
> Seems good to me (after filtering out all of the quilt-induced
> whitespace changes ;-) )

Doh, forgot to prune that.

> +	/*
> +	 * perform same basic superblock validation to make sure we
> +	 * actually zero secondary blocks
> +	 */
> +	if (sb.sb_magicnum != XFS_SB_MAGIC || sb.sb_blocksize == 0)
> +		goto done;
>
> Is there any chance we'd be here if the first test weren't already true?
>  *shrug* harmless though I guess.

It's quite easy to get there if you run mkfs.xfs -f on non-XFS
filesystem.

> If something goes wrong and the old found SB is full of junk, this is
> non-fatal, right.

Yep. Worst that will happen is the pwrite loop fails, and if so, it
stops and exits. Maybe one subtle enhancement is to make sure the
pwrite loop doesn't extend beyond the new filesystem size.

> Out of curiosity, why not just call verify_sb for the sanity checks
> instead of recreating a subset of them in zero_old_xfs_structures?

Because that code is in xfs_repair and not mkfs. With mkfs.xfs, we
don't really care if anything else in the SB is bad.

Barry.
