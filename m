Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C613334C05
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 11:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771500424; cv=none; b=Q4JOX/MhAf0p9u7Cr6qlHhg04w/2AHjSkYz3M9nmrLVUzKRBP0JNX2wFRkvqQO0aEWhuljOiX62AaquUXIlKSN35XRqeESnD7Szd9b4k9CRtQZhwYKyrN7JJtqeE8V2y84vHzWvASzczzB4YXz5UyuXUU3K7b6q1vO1dZj/SDWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771500424; c=relaxed/simple;
	bh=f3vAqn4ppbFnh0QecIxiNKjgijr644VO5H3nZrPIEnY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=anb4fxf2RBwBhmOw/imACXMdJQyknSkf9kBTtxdmKn2YXCKIMb/tolDyY4cBUULtukJthxpvCMHgDkM3hSTk/eOZWFq9LRRkr3Q0qK6+RpZiNRO9Fnjo7HBpNA+CORr1GMiu36/dJT8F72OMKVib59Q5Tuz6ZoxeyPm9B4T9j2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XlqP4ZCk; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XlqP4ZCk"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3562212b427so299895a91.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 03:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771500422; x=1772105222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZURHwMivqBWxN0ER4yF2IOWlvgzhn1+/h2yBszFYV2Q=;
        b=XlqP4ZCkRs+B3PVqNMoBClzHRMa/euJTmlWoct7LYj9lc+lbPrQIqo44xAAHC6P9fq
         RTXM9GGVrqRAYsvhhS+XS4hkXZW8Yq4Ibkw+96+T/Hvuh8rjypW73QiiLQMrg0+pUM2e
         VJQC5ehsVNUo+5O0delNmNi8zKwZZ9WkGh/vJfKhsTwsR4iehOqtjyBbXSgammV4VK68
         0mf1mgRycScFnIvMp33OKLzu8apki8MD0rq190yFMtJy0MsgndOjxFHXFUvjenRii10p
         +MDBC83EEJUcKpCu1QcYDHO/Ok4GINIyXklTdjh50IqJNgNPH3IUwFQiZRMxI1DCOIyw
         bx3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771500422; x=1772105222;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZURHwMivqBWxN0ER4yF2IOWlvgzhn1+/h2yBszFYV2Q=;
        b=KMQk+uouk3oPrVuQorj/ljBIQXP4C5LmFzLes056/iT9+jjfRcg0uVmoxDSB8SmHF7
         Qcfk63TQBrc9cXX7vEGp7pdZrSCtLmqXTNTQB7iIYV27EohsHaksOBqpESUkOCEfyQ6u
         JRN/fs3zTn/yyLnFZaAKQuAmK6W4iUnAf7qX/6/XZCfSFlK8pBL0Y/4MTDIM/jOsfCq7
         WQ2DFAAA57g5+M4v57oNz97svsIyrn08oRSQEtd63VRhAJtNKvSQiGehh8L3Dw7CZq5F
         BF6X45U6XsdMBNud6MWamwMQmfc6bZA8YcRotZZeT6aWZenZw10M/5W8g1foUgfKEYpn
         uQ6A==
X-Forwarded-Encrypted: i=1; AJvYcCUQOPYBZr5YZScIUu0f5+IQ4vlC8xLl86mxP6TYHSb3XVSD32WYdohIguIUXVWWQNlo7kwpVxIa7NI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2vbSBvj0yBSCqLqHadU/u8to+XZo5VUCkcJgYHIbmstzmb9Uy
	bFEoH9f/rbTKaVhQLcaI5qZFyNcHFCAQAMKnpHS1jzDONvFCMS50S2P0
X-Gm-Gg: AZuq6aKl8CepClykKfe5Nsnw/SBhCvIRYT4x6J2O1AENuWNMyMmI8ZOBk6pCtJ6LCsN
	QJ9qKYCimiOtaCuSzClG99A9ABJGIcpqB9CmOmsEsDooTxiRcYVIcvbF09xPg01sQ+jECTH5rL6
	eqWs5qCjSlTot9BLn0E66TSvZb6SPOCObp4WyKqS/s/oO6JLmuuoPuB2KHmFr2wkWCgQ78TZkSO
	BL41V1g3zVcT3Nz3wxbTMzSs4SHKxia8ayWektRr9CtKTniROtAlSwQA0LvG+OaScLD3Eg4SJy5
	UNFdWzu2d/1U3WB5S5H2aDnF5FwcYLIKWg+rx0H6C6aqro9sq7F+3dc3BeYsxuPpUodNR3LgQ0K
	jUz1nnnRwfOkmz9Za6Si/R8z3yPXfy5SyDvdpzQTfGFaj9LMpJmr2Ln8Q2w+n5wqdaYLzgi1p+U
	baCvGfHCr+INSCPgVJLXePdFw208WeT4VM/HR/WMdXzDmV1OGfUoPTO0oHY79t7UlbEuDa5vmyy
	sJSerJo
X-Received: by 2002:a17:90b:5190:b0:340:ad5e:cd with SMTP id 98e67ed59e1d1-358890a1502mr4212975a91.5.1771500422526;
        Thu, 19 Feb 2026 03:27:02 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.232.214])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-356629314fbsm28039491a91.0.2026.02.19.03.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 03:27:01 -0800 (PST)
Message-ID: <61386abf00c817e65ab70c994ed584fde339f9ed.camel@gmail.com>
Subject: Re: [PATCH] xfs: Fix error pointer dereference
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Ethan Tidmore <ethantidmore06@gmail.com>, Carlos Maiolino
 <cem@kernel.org>,  NeilBrown <neil@brown.name>
Cc: Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Thu, 19 Feb 2026 16:56:56 +0530
In-Reply-To: <20260218195115.14049-1-ethantidmore06@gmail.com>
References: <20260218195115.14049-1-ethantidmore06@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2026-02-18 at 13:51 -0600, Ethan Tidmore wrote:
> The function try_lookup_noperm() can return an error pointer and is not
> checked for one. Add checks for error pointer.

Nit:In the subject, maybe just add the function name where the error pointer dereference is being
fixed?
> 
> Detected by Smatch:
> fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error: 
> 'd_child' dereferencing possible ERR_PTR()
> 
> fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error: 
> 'd_child' dereferencing possible ERR_PTR()
> 
> Fixes: 06c567403ae5a ("Use try_lookup_noperm() instead of d_hash_and_lookup() outside of VFS")
> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> ---
>  fs/xfs/scrub/orphanage.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
> index 52a108f6d5f4..cdb0f486f50c 100644
> --- a/fs/xfs/scrub/orphanage.c
> +++ b/fs/xfs/scrub/orphanage.c
> @@ -442,7 +442,7 @@ xrep_adoption_check_dcache(
>  		return 0;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> -	if (d_child) {
> +	if (!IS_ERR_OR_NULL(d_child)) {
>  		trace_xrep_adoption_check_child(sc->mp, d_child);
>  
>  		if (d_is_positive(d_child)) {
> @@ -479,7 +479,7 @@ xrep_adoption_zap_dcache(
>  		return;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> -	while (d_child != NULL) {
> +	while (!IS_ERR_OR_NULL(d_child)) {
>  		trace_xrep_adoption_invalidate_child(sc->mp, d_child);

Based on my limited knowledge of this change looks okay to me. I looked into the return values of
try_lookup_noperm() and it does return error pointer which is not NULL. I also checked the other
call sites of try_lookup_noperm() but I do see a mixed handling i.e, some places just checks for
!ptr and some for IS_ERR_OR_NULL. For example in fs/autofs it checks with IS_ERR_OR_NULL whereas in
fs/proc/base.c it just checks for !child. However, IMO, it is better to check for both NULL and
error pointer if there is a possibility for both.
--NR
>  
>  		ASSERT(d_is_negative(d_child));

