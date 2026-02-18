Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7552244665
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 07:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771400908; cv=none; b=ZEZdmrrnKgWnIXX79URxsYR1eBpGZW1EZa79E3I52cWcjGPATyot2PPEhCRHf4dmUhrGpsHfulptqLIKNOTzjzHHmQozabXd5ugAu7apRMptr4EKLHWWSUhl0//SxftA5Z5CBSQxQQpf4PuCX9RkSZjwVAbMI4qBzY38ck6Lolg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771400908; c=relaxed/simple;
	bh=cvRxcLuJQIzRXggunhM/tQFoLnsLPVTLLHkAfRVPVWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gxZZdqhe3me50Dl3rkbqroCJqgwwu4mEOXjfDV9jhNGtH/0cYTbinKc6fB16mCiarElImE4d0lTLVkeLnNfm/3aoR5t9g1pnjetyDS3ce2xW4BWf506fGEK/xSwVFHaxWV+j2c8vYiB41Ce07RERqT9Fj9KlyD2PmYY0jlF4lzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ThNeLWJm; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ThNeLWJm"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a9296b3926so34566655ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 23:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771400907; x=1772005707; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1TQIvmfrYYP290m6AB7T04JrwoFehzrN8VpdJGdNVnU=;
        b=ThNeLWJm+DOBAAFpraP2+ffF1Ltym79682/f66HLcosrqI+zNsvyExxDecZvRwUOVt
         juvR0HJhLioiMhlF4qxJSnmv02vvhTJFdEvPxFwC0YzxQNEypAyoVbq+orYnkrz2eQFf
         aMpc6AThVsXbDz3Y0EGVf1xyoULSspKKowebUZEjNO/XcN3UV9zqt06diX1Ww5tbhL0V
         mMINWeDAmQPofQty/ZJwNEk30NxvPnHeJmE/8jHy6RAGnS5uSmGNygBLntwc4i+j/Evf
         lVxBsSZr51k17txPjmhnX2L3M0rqyzn//RGGmTSCe3oh+Lbeq5wabAth2JS1LJ/dJaJR
         aLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771400907; x=1772005707;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1TQIvmfrYYP290m6AB7T04JrwoFehzrN8VpdJGdNVnU=;
        b=rVkaC5qUaSixUcod8himF7p6hDvUgbNPBJHFSZRafgDKwOmMYY3mSRN4SfE6t2DJWY
         ZVFOa8J14ykyjyT3XvwH5QmKBaBeNAJztY6YPkKJK5jaQrhe156nPthQkNOK83eZ6DC4
         rtGGVJznbVuTQErCWhlp3X0DbLXOUWaRAk69/a23JYroGxr/XlzhPuLDIVorsmmeYdGc
         ILyYbUttgdH4qW9RTdmGMGf7HgWIwbo+cietXlAL0no4GQeaw2qUDEaRz3wSS4ZJIK4M
         wgUeInzZrOJGuxtNgqVUcVjHeiW1rayDYTDfLplrK5YyQXiDnqaIa/5wZ8xApp0q5rBM
         nKHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPYyZJ2engKOYRfs6iv+U0qnk3ZsbefdkF9XbkUWeSeH7Nx/HAoWE3NWuneieLsbECewqJVwii+vk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGj9tGiXMvW9n+T7tYFH2fqvV2DhDjDYTZi6Nef3p3ephPmnWH
	tAqmb6/EKQR9YE9KHdgrQLvK9C6sf6dJSDXiXuLAEvJmiQiGGv5H2uvY
X-Gm-Gg: AZuq6aJtIWs36C8pYyCTECYjeFGiZgp/DxD6WjWz2q67LS1vtW5yjziAEyfbHT9YsBJ
	z+cM58s6nrwO2tOXRMzKerm3pV4Pi39DswdqVuki7br9AD6tjDbicZrkKggZd1pFbezdkxSsk7f
	I9JdUhMpXHfqRwFDFSgDJtUNDBCkj/sLe42PMWdeyDwBRtksalOvol3kXX14EUL9TfoZamsmtgV
	GhplDm9+QZFsQn+glSq2iEvbB7B34hfJeRlu9VoyFUuFgT5j6nl6gO8JtV7Q41T5sMZ4HKdb96+
	CLtMWk45oTW3E7BXq1B0iySz2AcopsWvSV7BAt9PP8IRRsncMBILJV5FHODkh/hnRnlxsP5+BTS
	IgSRyjKaJ7JxUPTnUG+zcT9g1ZvtBnq+clWkp9eX6IW8Hs8axgpAln05McUfSmPNFDevgwxhRAO
	Jf5xDCxeFWR6OBML5/Q2trcx2DB8fzv1q8X0hVvYrDjtYPp2gC
X-Received: by 2002:a17:902:e80b:b0:2aa:f0ec:36f3 with SMTP id d9443c01a7336-2ad50fe2526mr10394395ad.57.1771400907028;
        Tue, 17 Feb 2026 23:48:27 -0800 (PST)
Received: from [192.168.0.120] ([49.207.205.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a9d6134sm128328195ad.57.2026.02.17.23.48.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 23:48:26 -0800 (PST)
Message-ID: <0f39dab1-3272-41b3-ba42-0376d6b0cade@gmail.com>
Date: Wed, 18 Feb 2026 13:18:22 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] xfs: Update lazy counters in
 xfs_growfs_rt_bmblock()
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <edd86fb5739483fb016fbde304d72bb7325782a0.1770904484.git.nirjhar.roy.lists@gmail.com>
 <aZVUS2ed5FF6H65H@infradead.org>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZVUS2ed5FF6H65H@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/18/26 11:25, Christoph Hellwig wrote:
> On Thu, Feb 12, 2026 at 07:31:46PM +0530, Nirjhar Roy (IBM) wrote:
>> Update lazy counters in xfs_growfs_rt_bmblock() similar to the way it
>> is done xfs_growfs_data_private().
> Please explain why you're doing this.  I think it would also be helpful
> to bring over a comment similar to the one in xfs_growfs_data_private.

Sure. Thank you for the suggestion.

--NR

>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

