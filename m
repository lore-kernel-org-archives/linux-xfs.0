Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB2D35C69A;
	Tue, 21 Jul 2026 23:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784676080; cv=none; b=RnJn92UerIazQwiHRves8Aqgd5m+wM+ERcOg/ZYu7qWh9fLtifLq2bGh+4hmkKyOcaT2FYvaAfY4W/99QEDcTz3oenS99AifFxmK5ux/5j8ePJf++EcqQi1R6bd1C/R7Ux12EosUSYa3RsyrWA7fMvlQ1StYq5mWLALmTS/rWs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784676080; c=relaxed/simple;
	bh=Epape1AZPmNPiDqSRRrDa6xUcdS+YMFPuT7Z66bYN5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pL1PevruiFQmcSQgB4zpbt9Q2Ny3Mu5xHWQr7g08TEMQq2uUxatzgKOSh7AGXH3xlCm+8AWK28WzuS2Km0R6u6ERo2iOeeLN+Q+l3WoC3grxr0h+cjjY/Mzu9cJCHuBtLkpr40DIJt8GVy5inFSmHjQHLVZ775PYhzAcpP5IahI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=If+xVjPS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="If+xVjPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785C31F000E9;
	Tue, 21 Jul 2026 23:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784676079;
	bh=73WfWUSvjW6xW9PAg9sUSImOvdQUpt4d8xftqMCXXKw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=If+xVjPSe8sYvTjtWw7yXmNRrFVTXLA1mqvOdcLJmbh6fRpE9UVxcw6BqYLQWpZFB
	 zllcimaBn5wDsxVCAD6fAlhKO4ImnJUipNtNLYCV+tZ4Mt0igW5QB965d+n/4LbjI4
	 DZeMyqxya6Z+iBLHdpXRjyXWWX27PvjqFdT4NyREjCO/RfrdFe4crnMNOD8o89juLp
	 YbOj2KaC1Qd95fGGwblRV8rNKYkmq/2I4pL9ksR/Cx+jxh6PeHIfzl/Eoq2SO3P7hi
	 cOUVKALJ8rk6KklJGW4FIdid17qd0opO1oHEaFNKNByX4Gw+prQp2uJixt1vXeYR0x
	 1FZOGjx4515zA==
Message-ID: <18d569b9-dbea-448c-8b3d-56de32c0d6ef@kernel.org>
Date: Wed, 22 Jul 2026 07:21:15 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/11] fstests: verify f_fsid for cloned filesystems
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, hch@infradead.org
References: <cover.1781694879.git.asj@kernel.org>
 <2ac5fb22fd6b51973d11082a1ee8fe354926c63c.1781694879.git.asj@kernel.org>
 <20260701173314.GH6517@frogsfrogsfrogs>
 <328de723-6f9c-4f09-a68a-da24d49300d5@kernel.org>
 <20260721225703.GZ7380@frogsfrogsfrogs>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260721225703.GZ7380@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



>>> just in case there *are* programs foolish enough to
>>> use (fsid,ino) as a uniqueness check.
>>
>> On the other hand, if a program needs a unique ID, do we currently have
>> any way to get one?
> 
> I don't think there is a way to get a globally unique identifier for a
> filesystem image except for the meta_uuid filesystems, and even then
> only if the volume manager resets the user-visible uuid every time it
> makes a clone and nobody runs a duplicator.

Yeah, interesting problem to solve though.
Do you have any further code review comments on this test case?

Thanks.
