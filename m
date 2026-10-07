Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149C0374A15
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 15:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791385865; cv=none; b=OzeqKJzi5E6aoFRRubbYhRuloeyRwde8ei03262TEQKiEMUPun63x9MXmSC5ZPmvqNTGkCu1gP+2zHmuTmPeCjstN3PMitgaCYKem69Sjwsv3YuGvYuqeVGRCCO6gy6tvUPCu6uNXCfgQ/L3hn0mvMX7SWNTV4UP38MTYSNrFJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791385865; c=relaxed/simple;
	bh=uvSFn2JS1HicWYY4/MIIKTqM1ZBLG8YVtaX0kOZYXeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pyWqHP0Xa9OrePmzqTucusC/zZljrC2HrfIORebXqjubL1I2SwqjMDvs40p5Y+wMt+9O/3PSg2HV5qZGNd0F37e3m87clrXiiVJ0dLt0zKDjvb1UfrbCsWxgq4SQnCpp4m+gfw+VE+C7UHGOaqrE07LAq6CGj4h3DM5f+sA0CGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etKGh47S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etKGh47S"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4F3C91F000FF;
	Wed,  7 Oct 2026 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791385859;
	bh=oGGaQSv+lHjCCRI0AzA1GIESb9S8GKUFV5ASgpZX0zw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=etKGh47SUc0kvHf8GMY8/ilvmSQ5kIj8Xxzlwg+KStow/Qa9w1xUSYuP7qCWpWjEJ
	 FElqkGuY9inwiZ1OkG/kRyF7wz2FQzDt4V7UrWEmX5sbPI/JvZHIZrjkJMDnUGTm/B
	 BtCNErb62BqmcTlOCVxqtHBOhZoq55JjCmaiX/uAEfx9cOAnQ3qxlKFJsh+6bamYiZ
	 Bm4GDqwJN48hoA4gd/ASSnGgzYlFiXdSks5rJitLm0O3tit6Gx/bB21ZMyeWniwZBU
	 S8iQZbZKnkWNzuQCGNrnvprV/ugFF/CUEVtF1nygmmxWdjwUXt0fBx3eaGwYFfuI22
	 nSYqfBn7I3+Cg==
Date: Wed, 7 Oct 2026 08:10:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: bugzilla-daemon@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug 222081] xfs stops if link count is to high
Message-ID: <20261007151058.GA2705364@frogsfrogsfrogs>
References: <bug-222081-201763@https.bugzilla.kernel.org/>
 <bug-222081-201763-nJXHm42U34@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-222081-201763-nJXHm42U34@https.bugzilla.kernel.org/>

On Wed, Oct 07, 2026 at 07:50:37AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=222081
> 
> --- Comment #6 from sachse@gmx.net ---
> The crashed filesystem no longer exists because its a productive system which
> must be fixed fast.
> From the current running filesystem I can create it if you provide me the
> commands.

# xfs_metadump -a -g -o /dev/sdXX /tmp/brokenfs.metadump
# zstd -9 /tmp/brokenfs.metadump

--D

> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
