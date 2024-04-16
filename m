Received: from a27-27.smtp-out.us-west-2.amazonses.com (a27-27.smtp-out.us-west-2.amazonses.com [54.240.27.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39382375B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 23:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.27.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713309869; cv=none; b=muhvVELtGJJX+oyXr06gL7UBMbm9gyqHB4p4MYOGuBfMpk3ilShtXYjL1sKKZhq1DNKs6Y57c7MKOJ+ObhYlvq44cTaTr5yTHLp8U7WSHIaiRMh7AqrPx0Qb0rJc8YPlon6e5LP+0pb8A/f/kRrld/68mrkHmbHAEBCPUFcqT98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713309869; c=relaxed/simple;
	bh=yzy9XW/ojgvt/DEM7cBxE7+m/R2NxwN/YlzLqP9rqp4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=V92ERiVdlWlqliKiV9vmhY5HZ0v72QTiOhSTCexknmHSluheEwmu00lT6svMlsQQb9LWDAk1fjnZ6zG3IYMtDXqZJQaVb22VLLQnKU0s2b0OBOz/ysgtNbZU7QHcnoRwNIeZ6RfIu6T30KRyYkdnZayUoKwgFWmixuD7t0fjMEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rutile.org; spf=pass smtp.mailfrom=us-west-2.amazonses.com; dkim=pass (1024-bit key) header.d=rutile.org header.i=@rutile.org header.b=QdhU1BcG; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=ea2GWGmZ; arc=none smtp.client-ip=54.240.27.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rutile.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=us-west-2.amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rutile.org header.i=@rutile.org header.b="QdhU1BcG";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ea2GWGmZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=cd6jqasjwj7rkm4pcqvzv2v4wr47yxhv; d=rutile.org; t=1713309867;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:Content-Transfer-Encoding;
	bh=yzy9XW/ojgvt/DEM7cBxE7+m/R2NxwN/YlzLqP9rqp4=;
	b=QdhU1BcGemzkyRSfqkQhDC3rtVAnt7wimGfqvtctt/mW/XGRFQoC7RKfctn+mq57
	n46HOBgMgM6znJI+mfChMACSzXeWQhf2ldiIe+jZCMN2mOHvEU7oCKrMauwpwXPtdg4
	jauvfeo59d0d227rjhtavsSsNdNg6Z3eJkIiiDiw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=7v7vs6w47njt4pimodk5mmttbegzsi6n; d=amazonses.com; t=1713309867;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:Content-Transfer-Encoding:Feedback-ID;
	bh=yzy9XW/ojgvt/DEM7cBxE7+m/R2NxwN/YlzLqP9rqp4=;
	b=ea2GWGmZo0LrKHv2AARZpl7m2IBDkey14F+8Us6i6/98BI08+rq5V/CAdIeedJjl
	ZCtb4Mb4pRIV6mgDbtjHz7go94t7MRllIJbI2CQO4Y6O8AntyPkeMq/FbVPOaqv8M/O
	yVPji+CZbQ4WKRpPcg+euMAh7gcObqPMbyIGMj8k=
Message-ID: <0101018ee939dd0d-f4f89d16-04ff-44ae-97f6-541a30117a4d-000000@us-west-2.amazonses.com>
Date: Tue, 16 Apr 2024 23:24:27 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-xfs@vger.kernel.org
Content-Language: en-US
From: linux-xfs.ykg@rutile.org
Subject: Question about using reflink and realtime features on the same
 filesystem
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Feedback-ID: 1.us-west-2.IG/R7L46ohk7VXbk73xp5DybEdSON9tjwQLyIAtkjJo=:AmazonSES
X-SES-Outgoing: 2024.04.16-54.240.27.27

Greetings,

I was attempting to use mkfs.xfs on Linux Mint 21 (kernel 6.5.0, xfsprogs 5.13.0) and ran into an 
error trying to use realtime and reflink features on the same filesystem. Is there anything I'm 
doing wrong, or is this combination simply not supported on the same filesystem?

The exact command I ran was:
mkfs.xfs -N -r rtdev=/dev/sda1,extsize=1048576 -m reflink=1 /dev/sda2

Which returned with:
reflink not supported with realtime devices

Just to be clear - I didn't expect to be able to use reflinking on realtime files (*), but I did 
expect to be able to have realtime files and reflinked non-realtime files supported on the same 
filesystem. With my limited knowledge of the inner workings of XFS, those two features _seem_ like 
they could both work together as long as they are used on different inodes. Is this not the case?

Thanks,
Reed Wilson



(*) I noticed that there were recent commits for reflinking realtime files, but that's not really 
what I was looking for

