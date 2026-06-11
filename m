Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90603BED74;
	Thu, 11 Jun 2026 11:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781178993; cv=none; b=M+71L8yRbeSt77DEdBQriWLo8oZcsIBfqevhP1nnXTCj8AKjsL83s/74tfoMEaAQm0ZXBD5ChvLsYVkothGy2pMqFVrbsJCACu8mVTp2ndfk6qlhDGOT0k5eIPTlEovzFMMw8gAhgp17iOS9oHpMRHh6wSoKGFpP//P9I9Ud3+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781178993; c=relaxed/simple;
	bh=qb/KPND+WLYrkrhZ01DwKQrgaWGrFzLDaVTSHnPzstg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rHqN57uDKm37TnJ1J8XnFk9SAfLimyM99GwZ1zwy9HtQv1cr5Tnco5FmHNhcHBgy3yz5cRBdS50PiBYcb2XAArCeSp8aj6DfVvQKWnQYASfhBMY0/cGKxBkBJLhllTrcEaosCyNnsFwecBGakRQ55BDEeHWqcDB8SU/F5lEUgWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=VUwLDkOL; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="VUwLDkOL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781178845;
	bh=mE9lHqft7baR+OMiGttbIHqSKgrRPf79mOCpJgwzkBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=VUwLDkOLmPmfdDjmnvSmk3uCyxllbtg5YiL9DnOpI031R+Xp2Hgdl8KM2MtQeHm5L
	 BexeV0bEe+decHXBRRccRE0t1TeVfsGb6F+ZFxg+Ap8SqoSqUjJonUiJM3MimU+tVH
	 9rAinc/b12qEs9rQMuneifNxvZhVt6kc0omR/kps=
X-QQ-mid: esmtpsz19t1781178837t185b680b
X-QQ-Originating-IP: bR/S/SZp7kdCgXjfgm328VQPKGA4o6kbuOh48Qak764=
Received: from [10.7.13.51] ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 11 Jun 2026 19:53:55 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13920602790602334213
EX-QQ-RecipientCnt: 9
Message-ID: <7EC39CB0E7CAEBEC+80edf818-6c82-4d25-aafa-b400f7b4c553@uniontech.com>
Date: Thu, 11 Jun 2026 19:49:25 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix use-after-free of buf_log_item in
 xlog_cil_build_lv_chain
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, djwong@kernel.org, dchinner@redhat.com,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 niecheng1@uniontech.com, zhanjun@uniontech.com, gouhaojake@163.com
References: <20260604094233.8492-1-gouhao@uniontech.com>
 <ailYf4UzSLplTR3f@infradead.org>
Reply-To: ailYf4UzSLplTR3f@infradead.org
From: Gou Hao <gouhao@uniontech.com>
In-Reply-To: <ailYf4UzSLplTR3f@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MZ9X7MyfBLbl13Fq0vi9C06qxuodjM1w03PgGtUrjzTw3QdU/iY8QVKm
	Hyl3NoCKoH4ASN8O3boHkYurVjUizz/yHak4kkbUVoyp60Gmj9S1X/dZN1aOu94R1DoVCJ3
	1lbnAjipUSqMolhFLIc6zOsUBa9RfOuEhRZb78G+tjw5cDUUNHxdgZRkxXVpDpCquy6rxgf
	qNo3G5jHfbmqNXkdbjXcqiwJKn6OoJ19eP0UPhAHhqUkYhydJic70QiYy6fmsahenP+D982
	eh5NUeiAT3+VF8JK5RqU5xWb9HvleqK5FmVyiIeY0xyG+416+Src+//FyyiddPucvrKyqLi
	1O3jC5VA0K/R80nl0XMtIBimIVLl4F9wZl/h+f3jIrAIWKEYr/bGxpQmaHu8d2sJ48rI6Tq
	xqOriVcPF+9vDeOAKSTCzfUgevfl5AuNV9OZhG7WLu1sdPRUDJAiByJuwldawnhImN5P7wP
	wIrjeVXZnNu0oj7ekSOLs4coZqQIQeGI5vLb4rL+KGFFxMLX5+0Lzsw5RnYKSc30Bg/wi3z
	G3ZTFHS+L9eRjRqc8mDG937hVph7TFRoP1ngdH0QvYzDWaHA4NdoUpsMDW+nLXuhHHP5flA
	ncs6SRRCVDRZTdsM/RpZ4AWTvzzjbKFC8Aa+HUk7eyA7YgNdhPZ61N27xalXzXTmxFfsYyF
	uQ0lSMAkc9OneQIvQgihMV46pRx0urCmR3Moz+TJS9zVDWqTRT1RhLQ/m5AiJF8k/n6zXKC
	Vq4I2cV2JH5Aq6x5W+LW77yns5+mty8/UHtNL6r5Mf05Lcf74sf8htE6o5e41MWU1D4QByp
	xsNPktOS4yinaPCyzoTLA0h56weq/IG6ODMW29oJjGRbolhWKBdYWdtBxKTl1O0qvlmpfho
	Kk34MMy8Abm/6lzWOlfzkyTt+z0iQ3ozbqllya+KD+B7wj70GLRGCal1W7hSHX/Mh5a1sBz
	SMLl/3P/YpxbB1tHr1c1uuXEHlTOTvhGLwYXggiij6gPq4sh2G7fENNrEiTdzeRvpScD7uT
	GKKlIFJAHmE7bRtoQRppJ1sEds2nrOKPU8dQGO/WmHAHDUO6eMLEtTdsbrnhDiB7DpRmvLF
	9ufA/qS+KUb
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0


On 6/10/26 20:28, Christoph Hellwig wrote:
> On Thu, Jun 04, 2026 at 05:42:33PM +0800, Gou Hao wrote:
>> xfs_buf_item_done() frees the buf_item via xfs_buf_item_relse() but
>> does not remove the item from the CIL log_items list (li_cil). When the
>> item is freed through an error/shutdown/abort path before the CIL push
>> worker processes it, the freed memory remains linked in ctx->log_items.
>>
>> The CIL push worker in xlog_cil_build_lv_chain() then dereferences
>> the freed object via item->li_lv, triggering a KASAN slab-use-after-free.
>> For details, see Link[1].
> There's no reproducer there.  Do you have a local one?

No, I don't have one either. It's just based on code analysis.


>> Add down_read() on xc_ctx_lock before list_del_init() in
>> xfs_buf_item_done() to safely remove the item from the CIL list.  This
>> uses the same lock that protects CIL list operations: insertions are
>> done under xc_ctx_lock read-side (xlog_cil_insert_items) and removals
>> under write-side (xlog_cil_build_lv_chain).  The read lock is safe here
>> because xfs_buf_item_done() is always called in process context (workqueue
>> or direct I/O wait) and cannot deadlock with the CIL push worker which
>> holds the write lock during xlog_cil_build_lv_chain - the worker does not
>> trigger metadata buffer I/O that would call xfs_buf_item_done().
> This looks like a more general issue as we should never free anything
> that is still on the CIL. I.e. it looks like we have even more issues
> with the buf item state machine here :(
>
>> Reported-by: syzbot+598a791b31c498b63c6b@syzkaller.appspotmail.com
>> Closes: https://lore.kernel.org/all/6a069a95.050a0220.2921a.0006.GAE@google.com/T/ [1]
>> Fixes: 816c330b605c ("xfs: factor out stale buffer item completion")
>> Cc: stable@vger.kernel.org
>> Suggested-by: Zhan Jun <zhanjun@uniontech.com>
>> Signed-off-by: Gou Hao <gouhao@uniontech.com>
>> ---
>>   fs/xfs/xfs_buf_item.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
>> index 8487635579e5..75529dfd1170 100644
>> --- a/fs/xfs/xfs_buf_item.c
>> +++ b/fs/xfs/xfs_buf_item.c
>> @@ -1067,6 +1067,11 @@ void
>>   xfs_buf_item_done(
>>   	struct xfs_buf		*bp)
>>   {
>> +	if (bp->b_log_item->bli_item.li_log->l_cilp) {
>> +		down_read(&bp->b_log_item->bli_item.li_log->l_cilp->xc_ctx_lock);
>> +		list_del_init(&bp->b_log_item->bli_item.li_cil);
>> +		up_read(&bp->b_log_item->bli_item.li_log->l_cilp->xc_ctx_lock);
>> +	}
>>   	/*
>>   	 * If we are forcibly shutting down, this may well be off the AIL
>>   	 * already. That's because we simulate the log-committed callbacks to
>> -- 
>> 2.20.1
>>
>>
> ---end quoted text---
>
