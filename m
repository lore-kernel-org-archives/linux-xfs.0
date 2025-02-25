Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B222AF1E
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 17:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504085; cv=none; b=XMd7usMy3ZFDH/svFV/s3ADK4uO4fWDvWqD5jwcQf/8byrvj2jzLYrgtmbHkd+3VKR/N0ZEODwfusjjq9joTfy9FaauQyVon2d+DH7ROGSpPkacO6e7xQJ14uI9fCFys4cp6I4Id2OksWs822mIIfP8FRCHz7PJia9NwdaYHfmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504085; c=relaxed/simple;
	bh=8idVY59QsEiRplbgSkMe3u8jw6naPzYgBUBLktpKiBA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Eu5h7gInhqs0dSM1hhNEd10ucOE3lTP8W8lGt9iA5zUuv9HWzZhwfQDtuk5BGUqAvP1WSlpO+WADui4LvbPKwW0I/tvn7E2H9JGFZvSz55dmnftiV47hmRDEriZhIrgMw3aDYY8QtHKsNR+T9+0oy2yYkg5suT6+yvMPOm7axDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvXnZfHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvXnZfHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D69C4CEDD;
	Tue, 25 Feb 2025 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504084;
	bh=8idVY59QsEiRplbgSkMe3u8jw6naPzYgBUBLktpKiBA=;
	h=Date:From:To:Cc:Subject:From;
	b=FvXnZfHRwXP7gf7guWggplX7hUC5qzds5WvzRhj7kAwMNb+lh1picWvZ/5DHi9zBg
	 8ThhfHczDg4M2lSXZRJL7YCtY+wtx+fAsNWgTxO/qxDflpvWljIuVLqU2z/awuP7Lm
	 GHos0lVR0PhR9Q0rk1p/thDuU7qvs6SJ2h5+kaT5h8CAcVqKSmv60qhjnPv5yc/z80
	 EWI31UgWa1pY46vCLBrJmrD5N7CtvEJRd4p1JRQkD0blUEom/Gzley6wtcbtu+G0Rc
	 orgfOsY5EW4sSX5NS0+aG68T82we/mNXnUcSfwz5k4DOkTRvYlgoQeB4d1jWmOCTMU
	 wmgwHxai1O0ng==
Date: Tue, 25 Feb 2025 09:21:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, hch@lst.de
Subject: [GIT PULLBOMB]: xfsprogs: everything I have for 6.14
Message-ID: <20250225172123.GB6242@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey,

Please pull all this new code for xfsprogs 6.14.  The big highlights
here are adding rt rmap and reflink support to the userspace tooling,
a new xfs_db command to extract directory trees from a dead/unsupported
filesystem, and various xfs_scrub fixes.

--D
