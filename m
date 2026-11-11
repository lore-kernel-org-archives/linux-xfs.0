Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.139.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794372855;
	b=l4BGkTJqgvUeins1m/3IMdtdJOudlzKgqu5xyf66TFO5oC4CsKh35uUJG55cYSq2R/1F
	 ENo0j5zQ26KC2KTUzSHoxg5zy7+b/FSIczRVHvNkmFkGhdabCZVi2qGtcEC28SmmBGdNN
	 JOvMPHioFgHcj9n9y6OAVTidjAJYCLqC3xj5uk7Cgf9VLE+TjpaZ2O4iL1CnJBog9L9WY
	 Ix8e3UuVpF1exui4U2K2tXzS9ShmbkofIhodPvBPjHUsN0a3OYlKmr+VecpD/jN6CSaTV
	 dWNqsl1zhTnlyPupVNY8YInKcA0tdhvKg0MgtipqCios2097dmw1VpP8aTQt74J3FlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794372855;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=NtAaZR2KETUPEE3Is5MRv41jGaiQEz+irF5G1JKk/ec=;
	b=FqlNdOEscYamNZ8I9lUEnDtvVtPFWKLMPFX6XsCcRPMRWkYc8f4Xr/om5c/f/6YxOHCF
	 RRrQM1xe3h8fAR6CTNdln1+yuYPvk+Qit38DSISFVu8OxJaAsunW65lF8cpy+BYY5iejl
	 yW+kgCwij1wx/V1F7fW4Hv/N4nu3yEaSgkZfSr+QoDzY9ziVxiRvmtP7CnJD0gyjk+GHf
	 u6RffKelfLYLH9zIeB6eIcLD8DqtVg3ysaQlTUDOLvd6lmwooxQaRjakiuHC7PvaazgsC
	 imbvD/hIIWlKcNY7JY08cBv1+tw4iRhiVPg20hoQT1h2N2GeiDLopZFaXGuYRmYw/TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=FeWaRpX0;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=DDIgG29a;
	arc=none smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FAD606A321
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 04:54:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7FAD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=FeWaRpX0;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=DDIgG29a
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB3ZUkh3222607
	for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2026 23:54:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=NtAa
	ZR2KETUPEE3Is5MRv41jGaiQEz+irF5G1JKk/ec=; b=FeWaRpX0JFJDqtJwU4br
	PaM4+1C15DtKoY/DjVy4KXDvPyfn+XruGroIDSNDyivz3zErdljr5btTtBNzLpTI
	ZxUlFjl8LhJZgbup0ow0vs76gL0HebhujdS8F9zVGr6xi7disWPs5Jw9Rr9jURaV
	64m7PBpFNjUk/wFc71DZ+QWMSjDLhz44ttgjmZRxdOi+gLJxclT8PQDbc3ScCSLT
	LRpAV/z6kaszEuHAItSZ5lEF/924KuNSvk0juChL9Fk3VNoe/h52JNdLMERXquTD
	3hq3X8b1GGpa73mmPxPNnZykEq8zWZRqCIe76YYzB+lREDhZdRyMIkppFg+lI3R9
	xQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvdhn9260-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2026 23:54:13 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-550b1d1d239so49295071cf.0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2026 20:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794372853; x=1794977653; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NtAaZR2KETUPEE3Is5MRv41jGaiQEz+irF5G1JKk/ec=;
        b=DDIgG29awOKMhYcYIs4QIXvig+LhNHeRIot2PHx5iCbjeSgTADb72R/6hE2a+Sa4zT
         3nktoqVZI5nNGcz1Gk5YAjqWKBvDMRoOf+fWKPM3bodg2SkzfEc/CXO8g2LpoE441KrH
         fXP3aYnFmq8pN3CBDMe6dYD4cuBEJsINtERvMPpysWsZA5OGNWVGG5YOj+NfHsxYi4fN
         2UKZS3uQ8N3zAqtbXNGjFCGgOZmWGFrTGlYLhKqATWE/Vx4nBm2cmh0Pqzwa1380ZDyz
         fQNAepN0ZRRbXwDfmIlHBJh4YTISDeaVjaNkI7HO5KWtEkpW/K4xA8sOa+ct+0AXkvA0
         C0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794372853; x=1794977653;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NtAaZR2KETUPEE3Is5MRv41jGaiQEz+irF5G1JKk/ec=;
        b=mt6nb4Fr7C4VfsH0fBB6cdj68rMFw46dU05DmqyesHU75UuDy+8lvWdsV+L9R1atxQ
         hLZ85hndeTuRJiu3+l0EYPKgesboBS3GgGNbTPjMFgIFvLCmKsOYHPmwzeWyZrxZdMB6
         LmMd82IjLqB/gTaLsOvUmqOtFm3nrq9Di/Y6QIIWq/XNTI77EQpQyLVo5/eLr67FUR+l
         hXQHFRpkKoTsgoSBman/nqGZJq3kdqu7bYn5Dg0d1bYwF3NZ2TC8s1uoQPRd94EcvSUV
         Q5euX7vTjWv/EDelL0ZIzpOZYmVIbPSywGWA6psdHpt7jIBeRH0GShkzEF57NgEIMWdm
         zPVA==
X-Forwarded-Encrypted: i=1; AL+hErE7JdYZ+K230HKKmrtAET46c+/go2wa4m+eSDC0OOPKTaczC9W/Ok4WJE8Ny3UiSAeg1ijewHAUGZU=@vger.kernel.org
X-Gm-Message-State: APuU4Z/R23MsxauF4RienoBJRvG0as8oF56sPUH6nsnlVS2fbHUvuYiy
	nG8j3KnZua087ydmUs6I28wKqoD8ZlkbCT8sIeQtNgssxNm/xHf/lxACfpgoFRNV0TEXWmcpllo
	mgp9odLRHeOp92aMTi1sY0ZXtXU3UWVkGf7wwLmJ2J5Bo0tovMFHED7Ezwg==
X-Gm-Gg: AYBFou2ltaK+/6ckN9g7UwaRl41pqWi9saVIxtt96i9AXKvUYlsdLfCaqD41Xo/lBse
	cTvSUr575WX0VzXCaS+CP2kkFB7BN4f7d4ycPwxo2Se/xPnXRs4+KPY3/WwZVKtzWMcGPdRN7Cf
	PZH/+JAQp4JFAlm/v68e/2Po+b6bmxbeest+SptJ8OEINpBcg/KoakLu2IkJIiV4hiwBdxsGDqF
	syH4UiOakqXQCg93hSRaYdVz4WnMyyJVTqS7gAOCW9zSUsB9+OEvn56Q6wOYs7nIHU+OIQiL8DN
	kQYBICVy+ee9t/pA5p3YYQ5y+Wc3uK8Q8uUEc4H24CcSwzDDdV7FTCr3aqQ296dikU6/hn6bobM
	xIR9MWAqUOfsLX+yZosegtdjxlVyJcL7tHQvYoxDKUP3dg7ghBAVsvyYmwCMqz2rzunE7TDPUVZ
	ddrb7tw14BHnsJgkoUa3KRWA==
X-Received: by 2002:a05:622a:506:b0:535:1d5b:a7fa with SMTP id d75a77b69052e-556c08d6ce1mr16074661cf.14.1794372852726;
        Tue, 10 Nov 2026 20:54:12 -0800 (PST)
X-Received: by 2002:a05:622a:506:b0:535:1d5b:a7fa with SMTP id d75a77b69052e-556c08d6ce1mr16074451cf.14.1794372852302;
        Tue, 10 Nov 2026 20:54:12 -0800 (PST)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550af60493sm41888591cf.4.2026.11.10.20.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 20:54:11 -0800 (PST)
Message-ID: <a2ba8655-eaa0-40cd-ac3d-d768b18192c6@columbia.edu>
Date: Tue, 10 Nov 2026 23:54:10 -0500
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/11] fs: validate atomic writes after O_APPEND and
 limits
To: Chris Mason <mason@kernel.org>, tytso@mit.edu, cem@kernel.org,
        david@fromorbit.com, jack@suse.cz, djwong@kernel.org,
        josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        brauner@kernel.org
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-7-mason@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20261110190417.32650-7-mason@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 1TQPou8icP4mzLRBmf_PP1A_2K3fX4Xh
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAxOSBTYWx0ZWRfX8JxM+RWdSbE3
 ywj4lQs6I6j1GRTm5dDEQkWlu6XqepKoyfoRvUr+9nB19rbaIAhp7mD0h6f0d919DEQ9ELEA1Bg
 JkNtncRWsbKktOhz0bl7x9pFaUez1p7EWVPXU4NxxFy1WepkGgFi
X-Proofpoint-ORIG-GUID: 1TQPou8icP4mzLRBmf_PP1A_2K3fX4Xh
X-Authority-Analysis: v=2.4 cv=X5bHu2Te c=1 sm=1 tr=0 ts=6af3f4f5 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=VwQbUJbxAAAA:8 a=mm-HGR4lrNp9vsEGGOYA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAxOSBTYWx0ZWRfX99mthdJAGKo+
 YEE0aptPP3s+0ZkthfZfoWsgodxd/FNoyBZKqwXRGrEVyeHkuWwoY+kZFawYMEr+U25ye73Msnv
 RBYiRaHtm52MTkkXkykfqJyxB0AB9hQ7uGI23yDmjdepYSDI5kDDYZbPNi5ZyYsC67OTm09quKA
 lbr6ntxE265Tv0azPH91NEG+srzWth1tt2yGlMIpmFKEGn8A0qkGzgDoqoz/92kVz5Fj6ZuvMMI
 k9y8+5MGCgJA4iAgrSKB7BC8htSFTMeMYSWH2lODLW5qTT2ej1aPYyXvYfTixxMgVo2k07ocH4V
 3wZen3Y3nupEKHcFv4ZEgS4T4UJhdzi5t/aK2s4pvrUCHebWkaZwJRTZBvQ94LSkxINaZ/YslmF
 pNgpJpBcst9vOg2sWmVoX49qti9rAYimntSfKu61XZktqyAKk9kq8+ool7RSrOwZM9+zS0JFCHK
 91+YGhjkqiqOgWDEXdA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11962
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 impostorscore=10
 priorityscore=1501 spamscore=0 bulkscore=10 phishscore=0 clxscore=1015
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110019

On 11/10/26 2:04 PM, Chris Mason wrote:
> An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
> if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
> aligned.
> 
> XFS and ext4 call generic_atomic_write_valid() on the range that the
> caller passed. But generic_write_checks() changes the range later:
> O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
> then fill only a part of a new block, and still map the whole block into
> the file:
> 
>      block size 4096, i_size 512, O_APPEND
>      validated:        0 to 4095
>      written:          512 to 4607
>      new blocks:       0 to 8191
>      stale below EOF:  0 to 511
> 
> The fix used here is to validate an atomic write in
> generic_write_checks(), after its range is final, and to refuse one that
> was cut. XFS no longer picks the path of an atomic write by the
> alignment of the range that the caller passed.
> 
> Fixes: f096207d3276 ("xfs: Validate atomic writes")
> Fixes: 43c696f9d094 ("ext4: Check for atomic writes support in write iter")
> Signed-off-by: Chris Mason <mason@kernel.org>

Assuming my ext4 patches get picked up:

Reviewed-by: Tal Zussman <tz2294@columbia.edu>

> ---
> 
> Notes:
>      v6->v7:
>      - No change.
> 
>   fs/ext4/file.c    |  4 ----
>   fs/read_write.c   | 13 +++++++++++++
>   fs/xfs/xfs_file.c | 17 +++++++++++------
>   3 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 50d3c92709c8..e301d4faf1c3 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -802,10 +802,6 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   		if (len < EXT4_SB(inode->i_sb)->s_awu_min ||
>   		    len > EXT4_SB(inode->i_sb)->s_awu_max)
>   			return -EINVAL;
> -
> -		ret = generic_atomic_write_valid(iocb, from);
> -		if (ret)
> -			return ret;
>   	}
>   
>   	if (iocb->ki_flags & IOCB_DIRECT)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 676728310899..1b34b7382619 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1775,6 +1775,19 @@ ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
>   	if (ret)
>   		return ret;
>   
> +	/*
> +	 * O_APPEND has moved the position and the file size limits have
> +	 * shortened the write by now, so this is the range to validate.  An
> +	 * atomic write is all or nothing, so refuse it if it got shorter.
> +	 */
> +	if (iocb->ki_flags & IOCB_ATOMIC) {
> +		if (count != iov_iter_count(from))
> +			return -EINVAL;
> +		ret = generic_atomic_write_valid(iocb, from);
> +		if (ret)
> +			return ret;
> +	}
> +
>   	iov_iter_truncate(from, count);
>   	return iov_iter_count(from);
>   }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index be1f775128d1..153f53f964b9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -926,12 +926,21 @@ xfs_file_dio_write(
>   	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
>   		return -EINVAL;
>   
> +	/*
> +	 * An atomic write is at least one block long, and generic_write_checks()
> +	 * refuses it unless its final position is a multiple of its length.  So
> +	 * there is no unaligned case to handle for it.
> +	 */
> +	if (iocb->ki_flags & IOCB_ATOMIC) {
> +		if (xfs_is_zoned_inode(ip))
> +			return xfs_file_dio_write_zoned(ip, iocb, from);
> +		return xfs_file_dio_write_atomic(ip, iocb, from);
> +	}
> +
>   	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
>   		return xfs_file_dio_write_unaligned(ip, iocb, from);
>   	if (xfs_is_zoned_inode(ip))
>   		return xfs_file_dio_write_zoned(ip, iocb, from);
> -	if (iocb->ki_flags & IOCB_ATOMIC)
> -		return xfs_file_dio_write_atomic(ip, iocb, from);
>   	return xfs_file_dio_write_aligned(ip, iocb, from,
>   			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
>   }
> @@ -1128,10 +1137,6 @@ xfs_file_write_iter(
>   
>   		if (ocount > xfs_get_atomic_write_max(ip))
>   			return -EINVAL;
> -
> -		ret = generic_atomic_write_valid(iocb, from);
> -		if (ret)
> -			return ret;
>   	}
>   
>   	if (IS_DAX(inode))
> -- 
> 2.55.0
> 

