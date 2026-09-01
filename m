Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941412F260C;
	Tue,  1 Sep 2026 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788277373; cv=none; b=HGQUSnp3SZ6oyrYyXhE8EhcsKVECHw+g7qGaXjZmwNjB2kiibEBL+qUKRGMszPVrWOICjFRhCnbPhAdssDoO799PkMPYTwc4fdlV1aXJbIctx/EO2JRPbxZ4OkgQm9tvdck/2XxwraQi71PEYncv8F69VWFSdLQ4nqYEDdrUUQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788277373; c=relaxed/simple;
	bh=Lwda+vNFe4ut/8+vl2HRP1Ndz6kdapXQrACpCrKr0FI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWVqsW27X1RHIpK90d91nNfm2A+RAPkrno8IRZl7yZGHWolLtqqsb1SpJDtI57nbGHzjqJgLO2CPmJbgcs0rGOtODjZfujvUBXJx2Nyy8EuCQiYbk3LV2c4+aqTGAjgUpYJUESsYGFPK6Ri+EfTgjUNDJsCDtTsESztcHJEre4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UgXsbapB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgXsbapB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10AB1F000E9;
	Tue,  1 Sep 2026 15:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788277372;
	bh=kwmt/CmpLnrqG0C6TaQUHP9mSrd7dijmNhSSbrv5QBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UgXsbapBP/AAW22n9gu40jvjps/Dn8xLvmhlVFxPW85tSuKc/4PPWkZZtJXWH7whC
	 hnndx/4KyLdzhTeEaOYYljBALNvtYoGK8UlX3S3m6JriAXo9ajiTFPHCr2PaOmU4Oh
	 pblvDFLEEAZQRB/QL5/3VNqi5uDwYrsVc/pC0vfy5kj/87Ihd6qVT9Bn/xpAIbNsl/
	 Jifs33I6hnycFp4GjcQsSZEVlS1X31fOdiWnBs2rWRWdX2TXKpB6T/KSU2FWpdhaVB
	 RlI5QaI/EJ9PAZLBUncPVGb/TLjWzGivV/t5fIdKth1kjQ6h3Ur2tYxsAidgTRbQBR
	 Wan2bv9loXLFg==
Date: Tue, 1 Sep 2026 23:42:44 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 04/13] fstests: add _require_fanotify_function
Message-ID: <apbxt_WcZOYfmfd9@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <d8fb7f5c0d67cf01249e8fc4807e963cc1a353d0.1784949155.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8fb7f5c0d67cf01249e8fc4807e963cc1a353d0.1784949155.git.asj@kernel.org>

On Sat, Jul 25, 2026 at 03:39:01PM +0800, Anand Jain wrote:
> fanotify support may not be compiled into the kernel. Add
> _require_fanotify_function to skip tests when fanotify is disabled.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 53e5d9d43af6..21b516accdf7 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6329,6 +6329,13 @@ _require_max_file_range_blocks()
>  	esac
>  }
>  
> +_require_fanotify_function()
> +{
> +        if $FSNOTIFYWAIT_PROG 2>&1 | grep -q "Function not implemented"; then
> +                _notrun "Need CONFIG_FANOTIFY and CONFIG_FANOTIFY_ACCESS_PERMISSIONS to be enabled"
> +        fi

What happens if $FSNOTIFYWAIT_PROG fails with an error other than
'Function not implemented'?

Thanks,
Zorro

> +}
> +
>  _require_fanotify_ioerrors()
>  {
>  	local x
> -- 
> 2.43.0
> 
