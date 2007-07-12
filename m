Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 19:35:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6C2Zkbm022841
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 19:35:47 -0700
Message-ID: <46959382.5060309@sandeen.net>
Date: Wed, 11 Jul 2007 21:35:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: REVIEW: zero existing secondary superblocks with mkfs.xfs -f
References: <op.tvamambx3jf8g2@pc-bnaujok.melbourne.sgi.com> <46951C0A.4080505@sandeen.net> <op.tvbsh9z43jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.tvbsh9z43jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:
> On Thu, 12 Jul 2007 04:06:02 +1000, Eric Sandeen <sandeen@sandeen.net>  
> wrote:

>> +	if (sb.sb_magicnum != XFS_SB_MAGIC || sb.sb_blocksize == 0)
>> +		goto done;
>>
>> Is there any chance we'd be here if the first test weren't already true?
>>  *shrug* harmless though I guess.
> 
> It's quite easy to get there if you run mkfs.xfs -f on non-XFS
> filesystem.

Oh, duh.  Of course.

>> If something goes wrong and the old found SB is full of junk, this is
>> non-fatal, right.
> 
> Yep. Worst that will happen is the pwrite loop fails, and if so, it
> stops and exits. Maybe one subtle enhancement is to make sure the
> pwrite loop doesn't extend beyond the new filesystem size.
> 
>> Out of curiosity, why not just call verify_sb for the sanity checks
>> instead of recreating a subset of them in zero_old_xfs_structures?
> 
> Because that code is in xfs_repair and not mkfs. With mkfs.xfs, we
> don't really care if anything else in the SB is bad.

Maybe a libxfs candidate?  But, ok.  Just a thought.  :)

-Eric

> Barry.
> 
