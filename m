Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F56191
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2024 00:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721089534; cv=none; b=bNtIC6G5v/oUuNmnIQ5pAMHyxB34jJuLGPkqzWMBDw1L/CYiitnNU/jfzoQZEjfRWlW5z71cwCiF8J1wjimWdW9SSOJy8gD1tUL/bozu3MG8uqI0Iq2MH0O2aAdwz8685Pljzq44oRboLfY75+CKLGSC5u2x/JCl2Hqlq0k+fAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721089534; c=relaxed/simple;
	bh=q8oFmTDYskE4c6KtdY4dcI5h87lPrpBVToh10l37P6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONE9AXcLaZQf7X0rKpBUIjDDzrmSa4QJgcr1T5apHdEL4tNNMIAXZjMShpx5Nm3TIqiZEClH0aapZJIxDRrxbaJJQf2nDNccsDhkwIw5aa1YsQaihpNq9QEjzucnSZCD9m9vKSE6f3BtVAqAYNd/OAl9sIB7h5bOPKoBhLlaGnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=v0TGvsX7; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="v0TGvsX7"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7035b2947a4so2846485a34.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 17:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721089531; x=1721694331; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+16bK+q1HuqL9btEUzjAZFFh7G0RphqvtjN0o0wQiyA=;
        b=v0TGvsX7mgk1RHjtrsaQun48CoNhLN5rccvm63WsznZQGy2Z633F7BW+M47rd1Fyck
         /peSWWTUUbaVfDTRSAUpBtb5EUHO36DYzOK8kNum2pSNgptcoec21PwsW/xTYj4JHhiU
         K44gYbePZULN3F1vPlQ44SeZEhY1nOtiwTIKhxxrvSBTzWHBqa8idodK1bbSW8rA2CHy
         yJptPGYfz5lSjyHFOZmHLLsseStGnTJoMY8MPBsj/VdwpspPfauVZ6XhoduNS6SdSgrD
         MKJW9H/NrS0GmxMLQUj/0CbJX+aeMWbvaE9AMKdbvPyQtiU5V5zgj6ydtihRVJHcv7Iz
         30dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721089531; x=1721694331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+16bK+q1HuqL9btEUzjAZFFh7G0RphqvtjN0o0wQiyA=;
        b=hUvdnyDCuH0QoKYnW3kccd02TVZdjFW3cjjpMc9KPjnAeB0MPAaxDoWhO0OmQrYMMt
         owQIf7g6vFEs4qnHSntjd96aGOYackQPwxTzsgCrLCE/mMrdUrvg8F1ZlDbSABdhPtvC
         TNbobQnX9f80X7EVZ6IfU2GF7HFL3ZbUEUdbhBJlitZ8BZvqB1WE6y7uYmUfjwgfNSxW
         /0Q+ifuU17YeHzpuVF/FnGMZhkTRyDqqnmhkQVyF0o8yRSDvdpgHGa62StGaVQg9cxmr
         Zuw9Fr45ahxFc/EJyCC3yr6Bw83VSqnnah/dJ8u0xzQG7FJcPj31tUOftY4aF8TEMPsF
         AMAw==
X-Gm-Message-State: AOJu0YzN4edYhiNwqy70p+E2CwkjN/d12R9ZdElLUNfphZ0SrIFYYEBD
	wt/Ijh1SF7Cupp/CaWkoaf0QH/s4NqK84MMGH1rRFhuNF1/540Tl3fY6TIWl5Z+MWgUdg5iIbwW
	V
X-Google-Smtp-Source: AGHT+IGQ4A1adg7YS7E7xC5aNhMDT+kc+0i5IRYyVn0OdUdAXYpl6gEeo7DHBwsN08REP1IIqPGDPw==
X-Received: by 2002:a05:6830:7316:b0:707:1794:6ec1 with SMTP id 46e09a7af769-708d998969amr726673a34.20.1721089531627;
        Mon, 15 Jul 2024 17:25:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-78ebcad8433sm3758699a12.9.2024.07.15.17.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 17:25:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sTW0W-00HIj1-0d;
	Tue, 16 Jul 2024 10:25:28 +1000
Date: Tue, 16 Jul 2024 10:25:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] spaceman/defrag: workaround kernel
 xfs_reflink_try_clear_inode_flag()
Message-ID: <ZpW9+PsbhhoXYeyC@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-7-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-7-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:25PM -0700, Wengang Wang wrote:
> xfs_reflink_try_clear_inode_flag() takes very long in case file has huge number
> of extents and none of the extents are shared.

Got a kernel profile showing how bad it is?

> 
> workaround:
> share the first real extent so that xfs_reflink_try_clear_inode_flag() returns
> quickly to save cpu times and speed up defrag significantly.

That's nasty.

Let's fix the kernel code, not work around it in userspace.

I mean, it would be really easy to store if an extent is shared in
the iext btree record for the extent. If we do an unshare operation,
just do a single "find shared extents" pass on the extent tree and
mark all the extents that are shared as shared.  Then set a flag on
the data fork saying it is tracking shared extents, and so when we
share/unshare extents in that inode from then on, we set/clear that
flag in the iext record. (i.e. it's an in-memory equivalent of the
UNWRITTEN state flag).

Then after the first unshare, checking for nothing being shared is a
walk of the iext btree over the given range, not a refcountbt
walk. That should be much faster.

And we could make it even faster by adding a "shared extents"
counter to the inode fork. i.e. the first scan that sets the flags
also counts the shared extents, and we maintain that as we maintain
the iin memory extent flags....

That makes the cost of xfs_reflink_try_clear_inode_flag() basically
go to zero in these sorts of workloads. IMO, this is a much better
solution to the problem than hacking around it in userspace...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
