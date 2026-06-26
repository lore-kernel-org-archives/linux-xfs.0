Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A513F8246;
	Fri, 26 Jun 2026 13:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481262; cv=none; b=I1RHeGvNwdGa6Jq1xDcmgKWnaRVA4DpqeaXcZNGQ5zvspM6PFU8JiJNGVpOTAmXtShU/CGBShrtmNdX7NagXI8+OpJ27Av3W1VKsrGRwu405fDTj6a2P56cAhHygxy5NW8hIVGZMrrzax9M9veCkJkJQTyGl+D8e06+WBmBJ8pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481262; c=relaxed/simple;
	bh=U9XtXjILV4z/r7YsvI55jkGXRuUn2jiR5fKts5PVOoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zt7h2mqr7U86g8QbbPcSVnkCYPKlq4xTKDA3KPMoeP2XoP2k44DqT6stJ+xMVK4EjdZf7UZJaAsQO+B6OOrURScbJVNE37y4e8JepEzJF6JNqkF4arHF3mUkL6HZdwf+zV4Sxbp73vIB0tRo2dXTzA/FB2USBs6p7H+r/OR50js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=dobFXW+g; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="dobFXW+g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782481239;
	bh=eAgCopvaldpMGs0k5dZYLTIrr2jo6F+DacT6v9UmDuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=dobFXW+gNSV4WUaOXSsJ91bIfvTn5Tw94PBjDiHyTr7VqMsogDPpkfvR6BHL9v9Yl
	 u+HiTRBSKTaGMGLHG7//ElKiEhfvvbiMQSa6eRf8aT7N682TQHKTpf2vcNBimGksN3
	 9VE9ofBiEQhP4dYC2vi8XeZzkvS26LOl3eTGEhGA=
X-QQ-mid: zesmtpsz5t1782481232ta0d5bee9
X-QQ-Originating-IP: S9fkTFrrHKZanZaJvHE8dcVyXNUlA/+yfEfFy3t+Sss=
Received: from [10.10.73.104] ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 Jun 2026 21:40:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6830464697361593552
Message-ID: <AE58834B98A995F6+a6737e62-a673-44ad-9285-5e2aef89804d@uniontech.com>
Date: Fri, 26 Jun 2026 21:40:30 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: release dquot buffer after dqflush failure
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260625131623.3261735-1-gaoyingjie@uniontech.com>
 <20260625175519.GF6078@frogsfrogsfrogs>
From: Yingjie Gao <gaoyingjie@uniontech.com>
Reply-To: 20260625175519.GF6078@frogsfrogsfrogs
In-Reply-To: <20260625175519.GF6078@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: MMbpVEeDwmsjS33SAXlisjqw1YtcV5D7ndTU0gRelOsy11eYAkEDCuUv
	ivyVxu2OpICDj/Jz9A9Y2AmDBmwEtA66PwmMYqLyEb487J6SwH+iBDpxzyvVvUp/QmU5jkT
	0MT30l/JcvRUTJ0HRs6ug7jAYifVzcgam+9yDwfgALNwpe/aAyF/jmI2CYPwrOnGC7O/nLK
	RJHcLvIx5bRFv89bcIivhFgyVobwfCPLxe4EU+U+RuOoHggUnNNyM1KbFm7o1R5Kqt70kUk
	fHX4kwzxgn92ne5EAe/4EzxF2T+vKqCYe+7VLMiBqJ366DcXvi4HSaFARokNuKtzhP+jzEF
	50AInYPOcCMw3rh32L36aM7a/hjRdLmsBRY77ZtuJQZpp24LdGiGIPMZp3KNFaSl5aglh9U
	B5dgbbFNUl64lXE1b++Rpj8IkB41lPJXJzTb+b5bMLTQN2l0co/oIcKOPifFCbsN1jzpT5y
	Ge3+5jgSwiMEcJ91qcJ7VKEXqaJtbnHUtv/6rpSC+X+CQ59HbwdCL1FGgYN5+tuYAWHzieb
	Gtm4Q7DGpp8OdzlU+uJPl2t0GNs8jyhlktQ5YCyQoMV44MuMaE9xDR462qMyGAow0BGvhUP
	TgNW2SPMrVomrWwXlsYHI5nLmhboj8CCbsUA4llcSw3lkXwVXQSbyUsZ8tt69eCZjkx+HLc
	+F1qk0qS0TKto5jzjfcIBZK2LTh5HKSV8+7RSv3pHN9t6zibHvEjnwyS+k2ZcIqjWJDlE6f
	jE9GVnY/AaiT+obgI3iyl1ctwW5vml1qvBamBEwpqJkLeObC+dqQINbncMYeq6qf87WrHM/
	DxZ2lqqF5DyspPc0efOJo9RrOPAdHFlY158xcJKOBL0IZhxcjZfMCrXB8o3OpObgrOJ0LB/
	Sl+zj41eaYN3olVi+KLHijQvRbD49Y/+r5cuad/QBK4pxeMdf97DazChDx4JR5LKK4R1iTS
	h0QHA4WkwkceiQj0nSv/yS1IWOxjz9qO7EOEUiu0azUI42y4uWLv26uBqliSDAVn6MVmc/O
	3oPFVUQt4nXzeqr9h/vcOQi8l+ZJL4rLBg93k6oUspWcyvZIkV
X-QQ-XMRINFO: MSVp+SPm3vtSiwei5pTfI2BzaVIKsnG2gw==
X-QQ-RECHKSPAM: 0



在 2026/6/26 01:55, Darrick J. Wong 写道:
> On Thu, Jun 25, 2026 at 09:16:23PM +0800, Yingjie Gao wrote:
>> xfs_qm_dqpurge() gets a locked buffer from xfs_dquot_use_attached_buf().
>> If xfs_qm_dqflush() fails, the error path skips xfs_buf_relse() and then
>> calls xfs_dquot_detach_buf(), which tries to lock the same buffer again.
>>
>> Release the buffer after xfs_qm_dqflush() returns so the error path drops
>> the caller hold and unlocks the buffer before the dquot is detached,
>> matching the other dqflush callers.
>>
>> Fixes: a40fe30868ba ("xfs: separate dquot buffer reads from xfs_dqflush")
>> Cc: stable@vger.kernel.org # v6.13+
>> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
> 
> Looks fine, though scanning this function further, I suspect that "goto
> out_funlock" in the "resurrect the refcount from the dead" isn't quite
> right either.

Thanks for taking a look.

I checked the "resurrect the refcount from the dead" path and sent a
separate fix for it:

https://lore.kernel.org/linux-xfs/20260626095253.3445540-1-gaoyingjie@uniontech.com/

Thanks,
Yingjie
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
>> ---
>>  fs/xfs/xfs_qm.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
>> index aa0d2976f1c3..896b24f87ac9 100644
>> --- a/fs/xfs/xfs_qm.c
>> +++ b/fs/xfs/xfs_qm.c
>> @@ -166,10 +166,9 @@ xfs_qm_dqpurge(
>>  		 * does it on success.
>>  		 */
>>  		error = xfs_qm_dqflush(dqp, bp);
>> -		if (!error) {
>> +		if (!error)
>>  			error = xfs_bwrite(bp);
>> -			xfs_buf_relse(bp);
>> -		}
>> +		xfs_buf_relse(bp);
>>  		xfs_dqflock(dqp);
>>  	}
>>  	xfs_dquot_detach_buf(dqp);
>> -- 
>> 2.20.1
>>
>>
> 
