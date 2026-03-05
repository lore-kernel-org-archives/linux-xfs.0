Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33713346A0
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 07:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772697246; cv=none; b=RMdYfR+EWA3zjp2UcTg+h5bz7P34VoosmRNizcTceZSEhoW/Wm2PQR7abGa4SaU75hbTpsIkvuQfEqn0f0NFw7IFQGRXemiX9TQ7NFwTciFcvqPeZAhtdLna9/qxukoiXzcMiS9FVcs+ZpVwHShlTdUn32hsKp3Bir34uO2xOHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772697246; c=relaxed/simple;
	bh=N1X6WiLTKvcrzF5dL4XwTMRsPK8sxcLQQ8DO6gGReNk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=V4pmxKUre0IcKMm74MCG+ILqWcXOx+ZmvDK/I2hhOYqBK6y8NzsvEXwdsUwvKhBKwmTfo/lnL2pPZVpuA7Z3uga0MgSeZV8d0Rr9HgJ1ytnlFp9UDzM+ccDs+D7OeVT3vZqYzjM60IjaUQ11xZQP32eJ3Vc32orMFNmPob/nu0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5b07e7bf.dip0.t-ipconnect.de [91.7.231.191])
	by mail.itouring.de (Postfix) with ESMTPSA id 0859012942D;
	Thu, 05 Mar 2026 08:46:36 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id A944C601893B2;
	Thu, 05 Mar 2026 08:46:35 +0100 (CET)
Subject: Re: [PATCH 2/4] libxfs: fix data corruption bug in libxfs_file_write
To: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
References: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
 <177268457046.1999857.4333152615677714192.stgit@frogsfrogsfrogs>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <95b8493c-4e56-03b2-0d9f-7a8ce1675a07@applied-asynchrony.com>
Date: Thu, 5 Mar 2026 08:46:35 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <177268457046.1999857.4333152615677714192.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2026-03-05 05:24, Darrick J. Wong wrote:
> Cc: <linux-xfs@vger.kernel.org> # v6.13.0
        ^^^^^^^^^

I guess meant stable@ here and in the other patches?

-h
