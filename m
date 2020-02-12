Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33478C352A4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 23:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E42A206B6
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 23:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbgBLXvU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 18:51:20 -0500
Received: from sandeen.net ([63.231.237.45]:50540 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbgBLXvU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Feb 2020 18:51:20 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B9B3A22C5;
        Wed, 12 Feb 2020 17:51:13 -0600 (CST)
Subject: Re: [PATCH 03/14] xfs: refactor quota exceeded test
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784108138.1364230.6221331077843589601.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 mQINBE6x99QBEADMR+yNFBc1Y5avoUhzI/sdR9ANwznsNpiCtZlaO4pIWvqQJCjBzp96cpCs
 nQZV32nqJBYnDpBDITBqTa/EF+IrHx8gKq8TaSBLHUq2ju2gJJLfBoL7V3807PQcI18YzkF+
 WL05ODFQ2cemDhx5uLghHEeOxuGj+1AI+kh/FCzMedHc6k87Yu2ZuaWF+Gh1W2ix6hikRJmQ
 vj5BEeAx7xKkyBhzdbNIbbjV/iGi9b26B/dNcyd5w2My2gxMtxaiP7q5b6GM2rsQklHP8FtW
 ZiYO7jsg/qIppR1C6Zr5jK1GQlMUIclYFeBbKggJ9mSwXJH7MIftilGQ8KDvNuV5AbkronGC
 sEEHj2khs7GfVv4pmUUHf1MRIvV0x3WJkpmhuZaYg8AdJlyGKgp+TQ7B+wCjNTdVqMI1vDk2
 BS6Rg851ay7AypbCPx2w4d8jIkQEgNjACHVDU89PNKAjScK1aTnW+HNUqg9BliCvuX5g4z2j
 gJBs57loTWAGe2Ve3cMy3VoQ40Wt3yKK0Eno8jfgzgb48wyycINZgnseMRhxc2c8hd51tftK
 LKhPj4c7uqjnBjrgOVaVBupGUmvLiePlnW56zJZ51BR5igWnILeOJ1ZIcf7KsaHyE6B1mG+X
 dmYtjDhjf3NAcoBWJuj8euxMB6TcQN2MrSXy5wSKaw40evooGwARAQABtCVFcmljIFIuIFNh
 bmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+iQI7BBMBAgAlAhsDBgsJCAcDAgYVCAIJCgsE
 FgIDAQIeAQIXgAUCUzMzbAIZAQAKCRAgrhaS4T3e4Fr7D/wO+fenqVvHjq21SCjDCrt8HdVj
 aJ28B1SqSU2toxyg5I160GllAxEHpLFGdbFAhQfBtnmlY9eMjwmJb0sCIrkrB6XNPSPA/B2B
 UPISh0z2odJv35/euJF71qIFgWzp2czJHkHWwVZaZpMWWNvsLIroXoR+uA9c2V1hQFVAJZyk
 EE4xzfm1+oVtjIC12B9tTCuS00pY3AUy21yzNowT6SSk7HAzmtG/PJ/uSB5wEkwldB6jVs2A
 sjOg1wMwVvh/JHilsQg4HSmDfObmZj1d0RWlMWcUE7csRnCE0ZWBMp/ttTn+oosioGa09HAS
 9jAnauznmYg43oQ5Akd8iQRxz5I58F/+JsdKvWiyrPDfYZtFS+UIgWD7x+mHBZ53Qjazszox
 gjwO9ehZpwUQxBm4I0lPDAKw3HJA+GwwiubTSlq5PS3P7QoCjaV8llH1bNFZMz2o8wPANiDx
 5FHgpRVgwLHakoCU1Gc+LXHXBzDXt7Cj02WYHdFzMm2hXaslRdhNGowLo1SXZFXa41KGTlNe
 4di53y9CK5ynV0z+YUa+5LR6RdHrHtgywdKnjeWdqhoVpsWIeORtwWGX8evNOiKJ7j0RsHha
 WrePTubr5nuYTDsQqgc2r4aBIOpeSRR2brlT/UE3wGgy9LY78L4EwPR0MzzecfE1Ws60iSqw
 Pu3vhb7h3bkCDQROsffUARAA0DrUifTrXQzqxO8aiQOC5p9Tz25Np/Tfpv1rofOwL8VPBMvJ
 X4P5l1V2yd70MZRUVgjmCydEyxLJ6G2YyHO2IZTEajUY0Up+b3ErOpLpZwhvgWatjifpj6bB
 SKuDXeThqFdkphF5kAmgfVAIkan5SxWK3+S0V2F/oxstIViBhMhDwI6XsRlnVBoLLYcEilxA
 2FlRUS7MOZGmRJkRtdGD5koVZSM6xVZQSmfEBaYQ/WJBGJQdPy94nnlAVn3lH3+N7pXvNUuC
 GV+t4YUt3tLcRuIpYBCOWlc7bpgeCps5Xa0dIZgJ8Louu6OBJ5vVXjPxTlkFdT0S0/uerCG5
 1u8p6sGRLnUeAUGkQfIUqGUjW2rHaXgWNvzOV6i3tf9YaiXKl3avFaNW1kKBs0T5M1cnlWZU
 Utl6k04lz5OjoNY9J/bGyV3DSlkblXRMK87iLYQSrcV6cFz9PRl4vW1LGff3xRQHngeN5fPx
 ze8X5NE3hb+SSwyMSEqJxhVTXJVfQWWW0dQxP7HNwqmOWYF/6m+1gK/Y2gY3jAQnsWTru4RV
 TZGnKwEPmOCpSUvsTRXsVHgsWJ70qd0yOSjWuiv4b8vmD3+QFgyvCBxPMdP3xsxN5etheLMO
 gRwWpLn6yNFq/xtgs+ECgG+gR78yXQyA7iCs5tFs2OrMqV5juSMGmn0kxJUAEQEAAYkCHwQY
 AQIACQUCTrH31AIbDAAKCRAgrhaS4T3e4BKwD/0ZOOmUNOZCSOLAMjZx3mtYtjYgfUNKi0ki
 YPveGoRWTqbis8UitPtNrG4XxgzLOijSdOEzQwkdOIp/QnZhGNssMejCnsluK0GQd+RkFVWN
 mcQT78hBeGcnEMAXZKq7bkIKzvc06GFmkMbX/gAl6DiNGv0UNAX+5FYh+ucCJZSyAp3sA+9/
 LKjxnTedX0aygXA6rkpX0Y0FvN/9dfm47+LGq7WAqBOyYTU3E6/+Z72bZoG/cG7ANLxcPool
 LOrU43oqFnD8QwcN56y4VfFj3/jDF2MX3xu4v2OjglVjMEYHTCxP3mpxesGHuqOit/FR+mF0
 MP9JGfj6x+bj/9JMBtCW1bY/aPeMdPGTJvXjGtOVYblGZrSjXRn5++Uuy36CvkcrjuziSDG+
 JEexGxczWwN4mrOQWhMT5Jyb+18CO+CWxJfHaYXiLEW7dI1AynL4jjn4W0MSiXpWDUw+fsBO
 Pk6ah10C4+R1Jc7dyUsKksMfvvhRX1hTIXhth85H16706bneTayZBhlZ/hK18uqTX+s0onG/
 m1F3vYvdlE4p2ts1mmixMF7KajN9/E5RQtiSArvKTbfsB6Two4MthIuLuf+M0mI4gPl9SPlf
 fWCYVPhaU9o83y1KFbD/+lh1pjP7bEu/YudBvz7F2Myjh4/9GUAijrCTNeDTDAgvIJDjXuLX pA==
Message-ID: <b979d33d-361b-88cd-699c-7e5f1c621698@sandeen.net>
Date:   Wed, 12 Feb 2020 17:51:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <157784108138.1364230.6221331077843589601.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/31/19 7:11 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the open-coded test for whether or not we're over quota.

Ooh, nice.  This was horrible.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c |   61 +++++++++++++++++++++-------------------------------
>  1 file changed, 25 insertions(+), 36 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index e50c75d9d788..54e7fdcd1d4d 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -99,6 +99,17 @@ xfs_qm_adjust_dqlimits(
>  		xfs_dquot_set_prealloc_limits(dq);
>  }
>  
> +static inline bool
> +xfs_quota_exceeded(
> +	const __be64		*count,
> +	const __be64		*softlimit,
> +	const __be64		*hardlimit) {

why pass these all as pointers?

> +
> +	if (*softlimit && be64_to_cpup(count) > be64_to_cpup(softlimit))
> +		return true;
> +	return *hardlimit && be64_to_cpup(count) > be64_to_cpup(hardlimit);

The asymmetry bothers me a little but maybe that's just me.  Is

> +	if ((*softlimit && be64_to_cpup(count) > be64_to_cpup(softlimit)) ||
> +	    (*hardlimit && be64_to_cpup(count) > be64_to_cpup(hardlimit)))
> +		return true;
> +	return false;

any better? *shrug*

> +}
> +
>  /*
>   * Check the limits and timers of a dquot and start or reset timers
>   * if necessary.
> @@ -117,6 +128,8 @@ xfs_qm_adjust_dqtimers(
>  	struct xfs_mount	*mp,
>  	struct xfs_disk_dquot	*d)
>  {
> +	bool			over;
> +
>  	ASSERT(d->d_id);
>  
>  #ifdef DEBUG
> @@ -131,71 +144,47 @@ xfs_qm_adjust_dqtimers(
>  		       be64_to_cpu(d->d_rtb_hardlimit));
>  #endif
>  
> +	over = xfs_quota_exceeded(&d->d_bcount, &d->d_blk_softlimit,
> +			&d->d_blk_hardlimit);
>  	if (!d->d_btimer) {
> -		if ((d->d_blk_softlimit && (be64_to_cpu(d->d_bcount) > be64_to_cpu(d->d_blk_softlimit))) ||
> -		    (d->d_blk_hardlimit && (be64_to_cpu(d->d_bcount) > be64_to_cpu(d->d_blk_hardlimit)))) {
> +		if (over) {

I wonder why we check the hard limit.  Isn't exceeding the soft limit
enough to start the timer?  Unrelated to the refactoring tho.

>  			d->d_btimer = cpu_to_be32(get_seconds() +
>  					mp->m_quotainfo->qi_btimelimit);
>  		} else {
>  			d->d_bwarns = 0;
>  		}
>  	} else {
> -		if ((!d->d_blk_softlimit || (be64_to_cpu(d->d_bcount) <= be64_to_cpu(d->d_blk_softlimit))) &&
> -		    (!d->d_blk_hardlimit || (be64_to_cpu(d->d_bcount) <= be64_to_cpu(d->d_blk_hardlimit)))) {
> +		if (!over) {
>  			d->d_btimer = 0;
>  		}

I guess that could be

>  	} else if (!over) {
>  		d->d_btimer = 0;
>  	}

? but again *shrug* and that's beyond refactoring, isn't it.

