Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B3A127B5C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421151; cv=none; b=D3WfvkHorlFuIkCO7PCVlrt6A08WZwjb6wo0QZw5KkwFGMHxZYKkPDMgCjnMwFC/uzd5EWtyVyb+d4k38SWDkMh39jIwsXT3fJJJyXEJ9vccp91h0z8wKWeQLkyLNo0kZFQzVgBzFNeHq64jdb5BPYHz52nqRpZ2op3uV3ydzaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421151; c=relaxed/simple;
	bh=3lo4W4Zq1yX6g4wMBryx0YPgGIiN1zSUQsvlgqM7uTk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DbGdxjERAx4SIAb1WLjYgv9Uyxz1VcnchIzsvrcP6+LCFwNkyhG6lFpdI1kj8yQNZRCZyAYb4QK7q3NyPpxuq2n39souMvUIe4rB/8yaOwaYfso83MqgugQTDL2UMaA+XL6mEC+QP1ooUXBTYTsFhF3jBU03XNsTnk01zsiDFrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tNBby6TG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tNBby6TG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783BBC433C7;
	Tue, 26 Mar 2024 02:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421150;
	bh=3lo4W4Zq1yX6g4wMBryx0YPgGIiN1zSUQsvlgqM7uTk=;
	h=Date:From:To:Cc:Subject:From;
	b=tNBby6TGpdW8/rTN0+rV0nksBqZPEbify6p7AEUwUxwmawEIQ+yRA5Q+BN6eEePkw
	 XrJFUL5eufNVbF1RRH6WbR1zl0mpDn2rDzvW/yhJDBD73vok3dXW4fEsKfPVyOIpD+
	 1HLKfx2uAcfrcd3Xz2cljRC9TbLsHRHjmjZfpXSAc0a0Y94deoECYWisxMNLouz79v
	 pJ6kQDemMSU3fCyUbEzALJ24+QRVYNZAWLTEE3o/9ihhJvdWVuqCUoaP6hvtzm0L80
	 RJ+tacV5bRtkmDlayOsTdGc9pa3zXlmVR8orddwTBWiZfHXTNCiUWElisnW0b5VKO6
	 yY7o1PNY9Uuvw==
Date: Mon, 25 Mar 2024 19:45:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB v2] xfsprogs: everything headed towards 6.9
Message-ID: <20240326024549.GE6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

Now that 6.9-rc1 is out, here's v2 of my earlier patchbomb to help us
get xfsprogs caught up to 6.8.  There are four new bugfixes for a 6.8
release, and I've added my libxfs-6.9-sync branch + all the 6.9 changes
that I've queued up so far.

Sorry about the giant patchset tho. :(

--D

