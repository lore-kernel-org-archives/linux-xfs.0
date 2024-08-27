Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B5A1D1F7C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 21:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724793091; cv=none; b=QGuKSniibykHj/VJvSQYqzZIK3aqrjWHSRbBB+L4PP3VTdjpwUu3HE1bJsDfKsaiS69T5oc6zf6mp02WEAe9GJALdzXmhbro2v7Ziai7VdHQz8LNl3a7nh+1eY/Rg39OYGvsdAjEOUPC32DvdyL1Xp2/mUCqobSb8FALRkptmZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724793091; c=relaxed/simple;
	bh=L97G6MMVh+QkvpJzN+yBqKDGIzVmJ2tDObKwNj7S7+s=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:MIME-Version:
	 Content-Type; b=bwIDeLU5vFWZQXeITOcpY0fUFoez5eQ6EB6sXk2pA6589i7OrvrR1kq8JdQYF4UIt2TI79inS7e6Xkz3++3iNO1M/LO1prrwrqXEZuSOUZeaRN/otzug8NL3SwUefRkmm2AbJteIsqA+mOewCpdw7P9ncVuHxTKm7ipiGasTw7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: sam@gentoo.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfsprogs-6.10 breaks C++ compilation
In-Reply-To: <8734mpd65q.fsf@gentoo.org>
Organization: Gentoo
Date: Tue, 27 Aug 2024 22:11:26 +0100
Message-ID: <87wmk1bri9.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

nevermind, I see Matt's filed it at
https://bugzilla.kernel.org/show_bug.cgi?id=219203.
