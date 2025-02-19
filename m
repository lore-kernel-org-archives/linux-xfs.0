Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F1CF4F1;
	Wed, 19 Feb 2025 00:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926094; cv=none; b=cTMiU6kTbFX/xa711A96bZRYUjrDgCy3yQVRC3LqIeYRq/brvjx34qsxuc4HwUDZtTKG2YRoJLQfGnYZbvqh46CpvYkIVzI2NAxqpGRO9xNP/z8gMskyj9CNSRaYAeXGFfO2TT7aKbqTOm/BBlZAu1gnNxKJT3+3e243uf/I1wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926094; c=relaxed/simple;
	bh=I3oGJn8Ijd60Yhqk88ST0Si2gVHTkFDck99xUJf7gBE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZ52MyQbGRFzJVikHf5l8atEVv+AzFAluAbFqkJXAt5HeyZaogoIs2nzF9Ww9DfuQa41YzgK+6V6+FUKt1E2Y2+ZHswzYJgOjDo81WgVpro4vMMQ2+3VOdHOGI64NUV5xMYQyBjViIis8jd5w0ikDEe9cPaDJAs2GR5OYE5cW6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UnuJ1Ddc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UnuJ1Ddc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FB9C4CEEF;
	Wed, 19 Feb 2025 00:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926093;
	bh=I3oGJn8Ijd60Yhqk88ST0Si2gVHTkFDck99xUJf7gBE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UnuJ1DdcWxRnk4MG2Z3w7wRJWeQ9HDDjNoNji6yD3aSpQM5l9pUq71jfNIj9q1V4T
	 OlqwaKLBL6bH4Md8YnqcFYZ6tiXPOlb7nt3Nt77aG/MhdueT0JbBBxWAsEQ3nO594O
	 CEWAzzD++Lxea7tHqh2nxf2rEm5tDsN7LF6UkZHrZcq99E7Zk8LtqKxQaLqu/oKXQx
	 FW8zEv6V/5AX4NWqVl0NsghEg90EJmoedUo+gC3cDfBjjDZm9tDrF9voz0T++kEUSy
	 WcVkGswVDe0SlFSl3y8VlQD0Fr49tm7WiA4FxhzVTAoeRUk3Kmbl3PP51eVHfpoKBd
	 wNufevmAgEgEA==
Date: Tue, 18 Feb 2025 16:48:13 -0800
Subject: [PATCHSET 09/12] fstests: check new 6.14 behaviors
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992590656.4080455.15086949489894120802.stgit@frogsfrogsfrogs>
In-Reply-To: <20250219004353.GM21799@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Adjust fstests to check for new behaviors introduced in 6.14.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=linux-6.14-sync
---
Commits in this patchset:
 * common: test statfs reporting with project quota
---
 tests/generic/1955     |  114 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1955.out |   13 +++++
 2 files changed, 127 insertions(+)
 create mode 100755 tests/generic/1955
 create mode 100644 tests/generic/1955.out

