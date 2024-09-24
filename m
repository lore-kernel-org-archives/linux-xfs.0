Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A337558A5
	for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 04:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727153074; cv=none; b=QVnAXNHm++jjbRR2/KP3R7JWFbGzJqpbELtC6LKdpcBK3u2p20fSQS3l0Wk5fa4+cNP4qgt684qhqtvvYXRHdtEeqXVgUfe/rZxeU/u5PamYKCER6ksj9GsV5vZYTN4BDqqavY/JGgDcRFPDdQ5N8j2cUOEDD+xD/CC5nkU7uBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727153074; c=relaxed/simple;
	bh=RbSbfLbRY7+jH529c9BN8RmF0JoVlm3RjUvS5Mi/u1g=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=dZHtNLR3rTusQIr2VKmsx7VStJdos4hhroAYf2KCnVCZXWTJWRUWH8ffvgexOAJxYicy+vJc0XbwUDlLQPBusGDGFp9TZER/aFMzs/KkrnI5Ma9OV/JlZMhbMYJGyKXdM1F0L45hECU6XBNkQv60LLluF1aYBt7JtUYtWX2Y+pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kksibiEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kksibiEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EDEC4CEC4;
	Tue, 24 Sep 2024 04:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727153073;
	bh=RbSbfLbRY7+jH529c9BN8RmF0JoVlm3RjUvS5Mi/u1g=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=kksibiEnfQojLAsABBgGC5SdH07B9kWI2PLuWzifc0B5oL5eFOTiyik4RmoPWPtQM
	 kXkS+cKJWAibn88wKjnj9eqmmQYX6bytVKfBoxfhJcJbPf19rx1VOM6ClmOl7gonBD
	 BmNSXnSp6NsX2ig92mZzuPElUZ+K9ZoQ5iXnhOFJ4H5KXbb8MQG3IqwXc5ykFbS2lh
	 f2e/DrEfJD3aqf0PcnrxyjSkiyLvV3rmK41TSlZPtc02rBqtqhtpDEsxmeIukjqauh
	 3z5DIVWxuIKTrKr66cl9GhVbTOpJND6YEihe906IBO8nrTzCpJId+rUSAyietOC7kw
	 bX/3a7erztHnw==
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Leah Rumancik <leah.rumancik@gmail.com>
Cc: linux-xfs@vger.kernel.org, amir73il@gmail.com
Subject: Re: [PATCH 6.1 CANDIDATE 00/26] xfs backports to catch 6.1.y up to 6.6
Date: Tue, 24 Sep 2024 10:13:10 +0530
In-reply-to: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Message-ID: <87ed598xua.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Sep 05, 2024 at 11:21:17 AM -0700, Leah Rumancik wrote:
> Hello again,
>
> Here is the next set of XFS backports, this set is for 6.1.y and I will
> be following up with a set for 5.15.y later. There were some good
> suggestions made at LSF to survey test coverage to cut back on
> testing but I've been a bit swamped and a backport set was overdue.
> So for this set, I have run the auto group 3 x 8 configs with no
> regressions seen. Let me know if you spot any issues.

The list of patches look good to me.

Acked-by: Chandan Babu R <chandanbabu@kernel.org>

-- 
Chandan
