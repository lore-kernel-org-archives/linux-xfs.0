Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C065C5F554
	for <linux-xfs@vger.kernel.org>; Sat,  3 Feb 2024 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706982647; cv=none; b=uXk8xCw6Edu2tAkqhEEjY3eHBCsOtvw0X2MIwo4Xuvu0Fjz9UEmVzYmyeihsm8kSFknE51ALytw9qUvwJX9g4FaPgd3nbVD4qWib7SAcQmrC22Abg6RrGym476dRT3n6r3fidk3LGiYjWaeloJk85juVxj/GicG5qt3NOJX6G3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706982647; c=relaxed/simple;
	bh=HHpw5Zw3or9ouWyrSV0ZFl6OkbBN2NgPyXBanM3o0Wk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=oa2I5muvOIMYi3q+jWndBlov+orlHdg2GIELXJdTaE0tJ93tAEKfm3eWSuwbEgxTsZQqOaxUJq8iUb464MwSxk5Zo9WPBjpq9WIgfLVyYRYmxYgv36wJqF1RBYE3CPnrqCFOKyrgG6PtJBV/AVmU9fTbnL4Red37JK1IC+PHjIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.1.122] (ip5b4280bd.dynamic.kabel-deutschland.de [91.66.128.189])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2C91861E5FE01;
	Sat,  3 Feb 2024 18:50:32 +0100 (CET)
Message-ID: <1b0bde1a-4bde-493c-9772-ad821b5c20db@molgen.mpg.de>
Date: Sat, 3 Feb 2024 18:50:31 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Donald Buczek <buczek@molgen.mpg.de>
Subject: [QUESTION] zig build systems fails on XFS V4 volumes
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Experts,

I'm encountering consistent build failures with the Zig language from source on certain systems, and I'm seeking insights into the issue.

Issue Summary:

     Build fails on XFS volumes with V4 format (crc=0).
     Build succeeds on XFS volumes with V5 format (crc=1), regardless of bigtime value.

Observations:

     The failure occurs silently during Zig's native build process.
     The build system relies on timestamps for dependencies and employs parallelism.
     Debugging is challenging without debug support at this stage, and strace output hasn't been illuminating.

Speculation:

     The issue may be related to timestamp handling, although I'm not aware of significant differences between V4 and V5 formats in this regard.

Questions:

     Why might a dependency build system behave differently on XFS V4 vs. V5 volumes? Could this be a race condition, despite consistent failure on V4 and success on V5 in repeated tests?

Any guidance or suggestions would be greatly appreciated.

Thank you for your time and expertise.

Please let me know if you need any further information or clarification.

Best regards,

   Donald

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
