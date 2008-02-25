Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 16:38:35 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1P0cS4t010320
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 16:38:31 -0800
Date: Mon, 25 Feb 2008 11:39:41 +1100
Subject: Re: [REVIEW] User-space support for bad_features2 patch
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t6w1h5f53jf8g2@pc-bnaujok.melbourne.sgi.com> <47BF0963.6020809@sandeen.net>
Message-ID: <op.t611gf1q3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <47BF0963.6020809@sandeen.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, 23 Feb 2008 04:41:55 +1100, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Barry Naujok wrote:
>> The attached patch fixes mkfs.xfs writing the bad features2 in the first
>> place (the change to xfs_sb.h does this).
>>
>> Next xfs_db support printing of this superblock field and xfs_check can
>> report the bad_features2 field is set.
>>
>> xfs_repair can correct the error in the same fashion that David  
>> Chinner's
>> mount code does it.
>>
>> This patch applies to the lazy-count xfs_repair conversion code that I
>> posted a short time before this patch.
>>
>> Barry.
>>
> +	 * Check bad_features2, if set and features2 is zero, copy
> +	 * bad_features2 to features2 and zero bad_features2.
> +	 */
> +	if (sb->sb_bad_features2 != 0) {
> +		if (sb->sb_features2 == 0)
> +			sb->sb_features2 = sb->sb_bad_features2;
> +		sb->sb_bad_features2 = 0;
> +		primary_sb_modified = 1;
> +		do_warn(_("superblock's features2 field is in the wrong "
> +			"location, correcting\n"));
> +	}
>
> My only thought here is that if you repair it, then use an older kernel
> w/o the fix, suddenly your fs behavior changes, whereas before you often
> got lucky, and both userspace & kernelspace swapped the same way, and
> you found the bits you were looking for out of luck :)  (same goes for
> the recent kernel fix too, I guess)

I believe the kernel code never tried to access "bad_features2" part
of the superblock, it always did the correct thing (correct me if I'm
wrong of course :).

But, as Dave pointed out, I should be OR'ing the two together before
zeroing the bad one.

> Should we flag the bad_features2 as "already copied to features2" but
> otherwise leave it?  Hmm I guess that would look like an unsupported
> feature flag to old kernels, wouldn't it.  Urgh.
>
> -Eric
>
>
