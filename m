Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793187110;
	b=S1r19PT2yMTcEjsazGV/lJsfIP+5wRVzTWIdOSlVZAfNST1pB2g9W9o70WOUesh0FiTf
	 LoPpPu7Geik6Pc8i2bi9i5apONgLxx6kZ5J2MJxpqkXgFK3nalS/FD0kyLSAlM0kFxLaA
	 NLtJFarONFpTeRFwvRc4RVDkSCg+AtR9kDgpalVYltH/uBo4/Kjt9+aAReoPS2bdCkrpn
	 wPrds1FwKWF3vLk0LCQHE/nCo3zcIOWHRXbGrQczBQa4yJyAMrwapMAK3NOQRT5Tq+67V
	 BYr6Sst/U/sKOnYKDcH0f6hjYEjq+egae+y/d5kxza2f2cWjNmX1ZR4NyNDoK4YtziQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793187110;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W2giDCY2xuWpTcZAEXRUmytbytl04hUv3N8ovPS9868=;
	b=fXYchaqv6V2Cf3re28bAVjniK8V8EqRBU3iRGTcricBQeuyObze47Q0DtDa9cO8dRuy3
	 MkbocnkmZkI0XlAa/NPqxRFUi0951AlKvUgiCvwrSFt6oX4upwaZuaOPB2gYrnPNGPEg7
	 8Nfk337uYQfrPGeOH7RLz+QHNNOY8gFTxbYiN2IqN42CvhUBGWi7GjcD8MrV7bQqdbCzF
	 GGKlwwtCcIGVG2N5PhUUb7kgM5rvT5VF42O+vDlz+Ii1wAN2egFF2nke+B8auow3Fe3jp
	 ItBYT155/p9z11Mptl/WNsWK3KRVBLUZ185H0J2WrtJlSV8UlYikwTCUaPbQAs+1y1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DOugLRcM;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89586606A320
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 11:31:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89586606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DOugLRcM
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3646e6de3e8so70633eec.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 04:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793187110; x=1793791910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W2giDCY2xuWpTcZAEXRUmytbytl04hUv3N8ovPS9868=;
        b=DOugLRcM0EyM7nC4PyJDIYRXIiT3pKHDFKlTsfjqo1BYSjhs5Xc0GMR7XvUvKFllww
         ZUGzy9NESCcXZQ2FdpXdRJIVRD3rl+SzTyVY5uDSe4B6N54KZoQ0Rh0KSuEDvEUoQx20
         sNRuepdAiUASIgvRJyZQLz3euL6Z5FVfqbV+NXNbk/oTK39temn0NG0MqN/oFec4+Wju
         0NpqBMGJy4IyfG1mZLQD9F/zqBxPaMctbvmTbZWrHrb+thcpWxzx2PA05D3WOicrQM+S
         aoyKPcRvqIiwjzCnvoyWbv02wqGN7XqpcFwxwZNEBXVnAMBOTFtMdJ+8rxMJwIaFfGor
         qywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793187110; x=1793791910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W2giDCY2xuWpTcZAEXRUmytbytl04hUv3N8ovPS9868=;
        b=Wf32R8m/cgBebwi2JoMDhGuH8SXmXTr92lx9GWhoC+YCUvZC18ItfLcC0/rnJ0KxUF
         oh1zNHCw2AQqSxqxx2eOGF6oAEAUfNFlCWxxgUOzTjpDXToesuIpyqx8Thx4W//Gs+/V
         9q5vmz7HBYnfVrxX4X7KoBOWIk6/SY4ucXFW1IpweQUcL0OfGMsclgHNA7sFKb+n4cuN
         jKceB6xdP7E8SmSOQ+e0+qjVp7uoj0o2+ue4JmC3owWm9DL+1pcnDJ5/eCksBDcj/yoI
         2WqjbIzMrIiXRvCfCKajGtEbsnq2DIcup3LOwFzV4hbDvX63z6obWCBe6iWUxODJ27k/
         82uA==
X-Forwarded-Encrypted: i=1; AKwUvByXR7eRBPALZ8qTLOL68Jc3+lIxPHjmYvUnfF7mwmwN4xJ4Njc3wl8GnveUZnU/voZDTPMH/t0mFys=@vger.kernel.org
X-Gm-Message-State: AFq9FYIERmGwuKu9Mn2TKqbnmZWycMA+3mW3xylXWD2wSsplsBPnEoMF
	lhtI/M4ao8kqx7AWf+GswIO3tk1784dVY6NeMLY3Q+AuoWkntret0dyw
X-Gm-Gg: AYBFou1Nv+FQ6sUvkZUoC06RIIsjJwGZyRO4AJRSc5v7VDze9Xp/9DQ0eUzX57CgBgH
	suWDxz0AeW78FxIqPYqnTvsOk2ptcIGWUr4eYNiICkdfbljZZ6XswDdXuDQ4uOV616K1vKbb+R4
	gFhB7MTU8LB8u0HYj6yOLTJE1mnoTFxqwAHsDp2zFPwKoNXmdqeVoUHkmnqLh61dYMMnDLj1DaK
	BmtUGinAhwn0rYCdpzKrFb+pm6N5EEpcILinsTIubHLbLj1qOTRzrYTWPK4LxV84/sP/wBN36uq
	HCKAfXLMtUB4O2P4R1WInUgvlnAfKD9NhiZwtlWylJto/JNYHK9fm52Ds+S4auPfQozutvNZzs7
	eBFCq3KbkqkgcfcGp7Y033xQXce5EGy/oCfK7xUQVpfT8sqccO1bIP+08Zzmgv9LwlprVZWnUCj
	mwqbZt33yvyGLGuFJGrI/0hcT75udtehOv5hL0NbMLy+W9lzsfkIT5qTN6OgVXp/nInXs7oioJK
	rJEUIWz11gUdZk5HuHnFY6Zh3Dv6GTcvP1wS7pWvAUmxJ6iefwM56kfV5J7iNWWWIup8lLqG9c/
	fANd0mCD/c+rEi6/a2QFixH1mKb39XWp6WEbRl9VUfuMCUZcvuLJbJGEpJkKkqKTvGGz72vvHAe
	QLw==
X-Received: by 2002:a05:7300:4306:b0:35e:d21c:f33e with SMTP id 5a478bee46e88-36a1ff99b86mr6523145eec.1.1793187109429;
        Wed, 28 Oct 2026 04:31:49 -0700 (PDT)
Received: from tacolabs ([72.251.220.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a2390929asm7462425eec.12.2026.10.28.04.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 04:31:48 -0700 (PDT)
From: Reid Downing <skibletz@gmail.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Reid Downing <skibletz@gmail.com>
Subject: Re: [PATCH v2] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
Date: Wed, 28 Oct 2026 07:31:27 -0400
Message-ID: <20261028113127.3374246-1-skibletz@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261027161748.2760321-1-skibletz@gmail.com>
References: <20261027161748.2760321-1-skibletz@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi David, Eric, Carlos,

Thank you all for the careful review, and Eric, thanks for catching
the second line.

I looked at the refactor David suggested and Eric sketched, and I
agree it is the better way to write this function. I'm not confident
enough in the 32-bit compat code to send it myself, and I only want to
send changes I can fully vouch for. If the refactor should go in, I'd
be glad to see it done.

Reid
