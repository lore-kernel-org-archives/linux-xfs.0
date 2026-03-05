Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875AB366803
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 15:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772726206; cv=none; b=lNAXKUlPTyP1BXjlxP3HFbiQp6SQFYyE0XJDTsBJQtlD5ie+1BvAFSJSLn5DPC8EdPt7cMqhhXiOC22wc+dDeE9Hyh3xyTeOesIRx9RctY6yzltEBGw8dY5iLf5U0jkdAAE7v6XjgXl9jdB/n4Ljduur5IAtAaRjPHpecDEINFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772726206; c=relaxed/simple;
	bh=VvMMsTIpNr7swlgIpVlzgwXVqLQwZD0H4GHKHGgBdY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bm9bGtCUMl92+y0raUGh5bGh4MhmVMz4ODdyB2N0YleZJWgpRmJsS5Zmb5l2qlJoAnVkMNWsUe09hlNUhTsH5nnKxu1Tt11xOIXyeVSp2N/5iV2vacxq6PQXePMyt9fCTfRyDi0YSHi54gdaNHQxrm6LX0zi9n3Nx4zgKOdqEZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qTf0ztwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qTf0ztwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07834C19423;
	Thu,  5 Mar 2026 15:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772726206;
	bh=VvMMsTIpNr7swlgIpVlzgwXVqLQwZD0H4GHKHGgBdY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qTf0ztwCMWGv0b7lC7Xi0oc54sciRphR0LjXe62DHZAIkbt5SPYHcM1g30C0uXahg
	 KkRpA1NHNR8MK/vlD/WClG1tc68P6GDTRZpROmjr4SRwfH/dZPyKzzlqNyjWlBiC4w
	 sCu1WiUh9PBNxBeJvjoIeia0FrlS00dFY48jkqc6xYPUx+GwNqGH6eiUp3bo8yAafb
	 2cCNdn6uVaND+/tpPP7EvAHFLzBBl8I61v2XIThPNHZULORHz+YC7RbdmXuM1Qvseg
	 JRpcpOTIY6jczc6jcci1B6DFNxVUSJ879VZ/3O3kLbhhskCbhSGmk7DH0roT+LC390
	 dCdi3N0fk476w==
Date: Thu, 5 Mar 2026 07:56:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] libxfs: fix data corruption bug in libxfs_file_write
Message-ID: <20260305155645.GE57948@frogsfrogsfrogs>
References: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
 <177268457046.1999857.4333152615677714192.stgit@frogsfrogsfrogs>
 <95b8493c-4e56-03b2-0d9f-7a8ce1675a07@applied-asynchrony.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95b8493c-4e56-03b2-0d9f-7a8ce1675a07@applied-asynchrony.com>

On Thu, Mar 05, 2026 at 08:46:35AM +0100, Holger Hoffstätte wrote:
> On 2026-03-05 05:24, Darrick J. Wong wrote:
> > Cc: <linux-xfs@vger.kernel.org> # v6.13.0
>        ^^^^^^^^^
> 
> I guess meant stable@ here and in the other patches?

No, these are userspace bugfixes and stable@ is only for kernel code.

Nowadays I like to annotate bugfixes for the benefit of anyone
backporting bugfixes to stable QA setups / xfsprogs packages (me), but
the awkward thing is that xfsprogs doesn't have a separate stable
backports list.  Unfortunately, the autobackporting tools all settled on
greg/sasha's shortsighted choice of tag format, so stuffing in an email
address for no good reason is what we're stuck with until someone else
screws up the courage to coordinate a flag day.

e.g.

Fixes: xfsprogs v6.13.0 73fb78e5ee8940 ("mkfs: support copying in large or sparse files")
Fixes: linux v5.8 b707fffda6a3e1 ("xfs: abort consistently on dquot flush failure")

or any such variant would have been clearer about where you're supposed
to apply it, at least in terms of repo and tag.

--D
