Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD1D3812EC;
	Wed, 10 Jun 2026 06:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781074376; cv=none; b=Rr1yirrernep2l5HN/II1BEIUqdFreiejhwhlBjmtiIKg3Ss75gushpZ9W1bk4QeHLycFh7dNeZjfzyzQhkwFRLM6xjUcSlFTP+rjFKOHpwe9jKeLx4o8z0cgBAoIyaUVy2E9DERcTDE0QWDFts1c6qU9NoWU57TunpZKjZikYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781074376; c=relaxed/simple;
	bh=3p9Dd7GMpwwck1Uq6YJL9SRbCVpaEm9FJWEyGP9pJw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WoglHqrfIvGrXRKBxpLWSEWyVD3z5PVNqQNRUMFCzaIe62C3u3m25l7OJq6ZQGuNrqEJ8/E4+KUk7UJkT0AbKYGvoSesq7R+BidDB3YY/jNpsLkGcaAb/BhkKoPBTa0XbnAix+//Zy8si0I3jGqMH0OOQWc0QvunSqz22fA4nSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Hb1GVBTh; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Hb1GVBTh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781074363;
	bh=zVxlLmh+4iHbTGFSqeEZnJaRv5RPyLtw5BKJjQwnxiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=Hb1GVBThq6kWnx9ZctPOJMaZrNOVOBVDbaUm20djAFlnrUy4uqhsC+PkNs+h6cQ7v
	 LJDnl64h71QcXuXJTr4o2dBP80pWYuJ2R+K/CkKNRwnuqZGUffmHyHGzDUunn35pf4
	 kpgpT+N0CJqXF723D+d8TueY+JIqn7sO1fvEUe08=
X-QQ-mid: esmtpsz18t1781074355tdc876336
X-QQ-Originating-IP: gQcmQNmlA22RIrP6wIRf42eIb/sgXeVk/SUzdvbe7MI=
Received: from [10.10.73.104] ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 10 Jun 2026 14:52:33 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7191369297312506617
Message-ID: <0591D4C494338FF3+72bb0510-1249-43fb-8faf-5724514baf59@uniontech.com>
Date: Wed, 10 Jun 2026 14:52:33 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] xfs: fix inode leak and clean up attr intent
 recovery
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, linux-kernel@vger.kernel.org
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
 <20260610022028.79846-1-gaoyingjie@uniontech.com>
 <aikEYaj5E-JXHhBS@nidhogg.toxiclabs.cc>
From: Yingjie Gao <gaoyingjie@uniontech.com>
Reply-To: aikEYaj5E-JXHhBS@nidhogg.toxiclabs.cc
In-Reply-To: <aikEYaj5E-JXHhBS@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: NFNrK8KlcSCRXyli6d9GKpF95IpsfNh2ctz4l0WVbXjLYY9ygN8kf8Jg
	v6ZWdcOU6jsf73CbQoPoKLUioGRfAHTcNAtTjiMJR/y67ah5bZzMGayYcj6N+9w3cWgDFds
	IfB94gkGjBAW+IX5x3CgofRuWJpH9SFwvczBy8keFN1IsttZp8ESsbhbqBmW/GSafuGtwP3
	m6qd8zzqmcbNNfIsTBtVIZrzi1cRUGjKaazBv9NDmT1wIR/a7i207fRim7HfToIcwq2kUCp
	kiQP1krsPRnHKKCBg0SLfyFxJm+jWK76uZwUEHu3s4bdVtJ8dvVvHIb1agq/IPzusZmke2w
	AcCLFohjl3Crob2C+Sfqqwmx5hbzuL0z7gp8/r/Ptq6m7ApdyG73N0BZ6I0lR7XsM9q6AK1
	hbyTYWuFbd+41oh09CWdJvLTIZeO9oVxM3jtk2mDNJ1ayA9NJAeEM0T2tbacot05U9kYziw
	pUxXZvX8mmxBxE3PeIUQCtDm8A+8IFhqv7Z2Z65ybgyISULLc/N9lOh1xMTaiXwaGZd0zYS
	XWeL91i6bQjOyPt4yS2DwUkz528M7rtuDcZk9VemqEn9AebAy1jrWpr/WX50w6CrQKBEEFh
	u2EOnAOvxOslNFMh+4F3OPgbelkZJE3lv9lU7RnqwMZruepd7lpvMpz2FteXSOpHGlrIjkD
	grDPnDKvifGp2kHxZUIxWPSQA+hnl9+8oyoCMq1DRze3MVfN3lrEh8uReIbGMW0cvyVQ70h
	LNUTnl5YLzQRzZ/ohrXE/R5YSJ1IQ7wOb0nsPkr2TlLi2AEPhYE/0/82oS+qaiWPuKwTP4H
	md/BVfmojTiYmcrl0smVpaL+D+wq+LBBtdJR/CGV+q/rqz1YB1cOqaSqp0pwyrxyBx0ywLy
	q3PjEv98CLdzyGdjIm0upDayoHoG3gcFSnMjqwB3BfDqiocQx/gzo9c4czA3eA75U6klyA0
	c+rJqr9tHQkX0yFvtsdIBCOXWfytwurCxWw7VwV84XtpUE6mRRx5y5jszu+MbX/yLnX6/aE
	xlC1NNT9y3Dq3vS9RCT8AlSUS//Ok=
X-QQ-XMRINFO: MSVp+SPm3vtSOMZOz9FXV91ojphix8iJBQ==
X-QQ-RECHKSPAM: 0

在 2026/6/10 14:30, Carlos Maiolino 写道:
> On Wed, Jun 10, 2026 at 10:20:26AM +0800, Yingjie Gao wrote:
>> Hi all,
>>
>> The first patch fixes a leaked inode reference in
>> xfs_attr_recover_work() when transaction allocation fails after the
>> recovered attr work item has been attached to the defer pending list.
>>
>> The second patch cleans up the same function's exit paths so they follow
>> the same linear cleanup style as the neighboring bmap and exchmaps
>> recovery helpers, and initializes the local error variable in the same
>> style.
>>
>> Changes since v1:
>> - route the transaction allocation failure through out_rele in patch 1,
>>   as Darrick suggested;
>> - keep patch 2 focused on the remaining cleanup-path reshaping and the
>>   local error initialization.
> 
> Please avoid sending new versions in-reply-to the previous version. Send
> them as a new thread.
> 
Understood, sorry about that.  I will make sure new versions are sent
as separate threads going forward.

Thanks,
Yingjie
```
>>
>> Thanks,
>> Yingjie
>>
>> Yingjie Gao (2):
>>   xfs: fix inode ref leak in attr intent recovery
>>   xfs: clean up attr intent recovery error paths
>>
>>  fs/xfs/xfs_attr_item.c | 17 ++++++++++++-----
>>  1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> -- 
>> 2.20.1
>>
> 

