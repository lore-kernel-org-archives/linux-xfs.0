Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E8534104E
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 12:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770121741; cv=none; b=frotrAbDHLOUr31pVp+xNOniM1mYJvpR5Xvs8UHBjpCSJGGkLOgRH7zCnh/Z7uPOx1y21IBxoh5ZvYGssTD/OC46jjsWNHOBtPiT0py7f2ELh3xldT3+Z9REkfudtbEvrRTNpERMbxrCnf9hh+5v3/zqtDylyTcE9Bo4GRqJ1us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770121741; c=relaxed/simple;
	bh=VCQKXK/b6w1p0rJZZ0YdDkePSLgf9Ak6OzkldxZRzdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqiZ15+6aqLg+mLW0iIrYNiZjF4i7/e+HF/cXXU9qYoBPvh2k1c5Pjbl9T4r8Wackcy/QFkTHfakyrTIxsKwjUSnGPeRSyY3Yyx7fFdHQqmFT1GEwsxph+erlYEOmzqdDGPugJeYEIwLfRflkqfk4TbKLLMYXPyYbQ1b/cC1EVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RCMv5QI/; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RCMv5QI/"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6505cac9879so8118220a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Feb 2026 04:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770121737; x=1770726537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1+6Ooei3qcktWMsNzPcdbmfIrr0F/PihFSzcD/XR6E=;
        b=RCMv5QI/HmgtofiEWwt1GfMVr1c/Gz03s+iLnf2HlJcaqTrBCtp4TLrQf/5I5dUb3v
         Vi2IVUdBnCbgo3WxfsVi7hJxfXYdmDn8FkB2JJj3h+WDbxfVK1Thu3vm1cnSchieurJM
         zKe0aca2OzmJkjRiz4+mmjih4layBLN62WQSTFcQcf1vFJeSAzAsY6e6ekkzIYAZQcii
         pd8JHTT2x7F+gfiDXPBWU5bFrtUzNb66IaInAb93gOLK9+2oA2iRfdp99hmGPwamWd7Q
         6cmGLR8OmfHGBFnoVIF6dGGJtEhy2yyjbvxSer0Uml/oTvJesEsfS9JGmUgyCvMEWU7q
         dQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770121737; x=1770726537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z1+6Ooei3qcktWMsNzPcdbmfIrr0F/PihFSzcD/XR6E=;
        b=mrdjgx8s7WqMNsOo3RGkZl9NP7OlynYC1D/AUrJND5KISK1FSi6C7twxvv6uXgtmWa
         zhkEwyA37KeYGo3DPyQmaENe3D+EoyX6Aj3vkj6ZVpOGQTA5Knl8wxxr5HABDXDJFUjU
         ZzhK4Ttki4IJd/OWWWlrWK8WVDmx0BC4dWgiefHi/H7dYKZyh53ioMFtPA0KU4ntVFaO
         dCXfMxB59ZCWxGLHjTflddQ0iOSPSgDJTslpqsnB+Us330dv9a4svLSHzgz8qjkyPR91
         1zFtHQU43t6oob/jhrJw7C+/EjU7BVZwAlNe6r3nsAuT9bczBIYps03NKeKhCjjlS8eb
         5zDA==
X-Forwarded-Encrypted: i=1; AJvYcCUAlwL/L1kRUXOTCa0ffQIwsVfIonpqxKM5ZL2ordyDPIdUtbtypq3rnp0cOEWiXdwurZMLkB7BleM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNxXukAY3shHyE5nqBn33CvMcN2/8CCLakprG+fQH3Sc6li8U8
	5tNb76aC8Wdc8ZJYmJmKMzzzO7uluk7lagV9HCSwGxnwx8fzvrSm3akCQyUkFA==
X-Gm-Gg: AZuq6aIay/gdNe5Er8uYNRildFzWgOWuOuonG9g6jdK67Uo8q3YFMlV3NadHGzzC8kZ
	TGp3NJeojTQzp3N03Jm8HST/cTdIM82Y/rkfjJ4lkqb5w+X7E1EBGigADllvQrsewYvjEtcmA4s
	TxXQVbPVPDuOCUstAymkKYvC4/G61haZbJogT/sufAHr82tgWDgoKtHzP4OGSM/YAX/gTB57brd
	45T6MxJBJsbUpFpHEykhKYNaA8zzMpN/qGE/d8CaHYuFzn9WL9pmxq4ttF6CDEyHvr8JcloLOH2
	POdH/QLfBdlo4DCUtZbhIXW0uyFhkfSVWPP7gFri3/KcIRYw0yRLXm/eBW8M68oW4NI/EvT38k4
	dfE5VMWZrpRWs1C6b3uGcIKRpTvH7Ga9TDL2YL6cgMoP6eba1CMZGWVfCERkB8GvXfiBNuiQVJM
	k6TDLO9ZY=
X-Received: by 2002:a05:6000:184f:b0:435:9d70:f299 with SMTP id ffacd0b85a97d-435f3a7e644mr22293614f8f.22.1770114553095;
        Tue, 03 Feb 2026 02:29:13 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-435e10e4762sm49060917f8f.6.2026.02.03.02.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 02:29:12 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: dhowells@redhat.com
Cc: axboe@kernel.dk,
	brauner@kernel.org,
	cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	kundan.kumar@samsung.com,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org,
	wqu@suse.com
Subject: Re: [PATCH 03/14] iov_iter: extract a iov_iter_extract_bvecs helper from bio code
Date: Tue,  3 Feb 2026 13:28:21 +0300
Message-ID: <20260203102821.3017412-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1763225.1769180226@warthog.procyon.org.uk>
References: <1763225.1769180226@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

David Howells <dhowells@redhat.com>:
> Can we make vmsplice() just copy data?

vmsplice already caused at least one security issue in the past:
CVE-2020-29374 (see https://lwn.net/Articles/849638/ ). There may be other
CVEs, try to search CVE database.

Also, I think vmsplice is rarely used.

So, if you author a patch, which makes vmsplice equivalent to readv/writev,
and mention these CVEs, then, I think, such patch has high chance to
succeed.


Also, as well as I understand, this patch introduces kbufs,
which are modern uring-based alternative to whatever splice/pipe originally
meant to be:
https://lore.kernel.org/all/20260116233044.1532965-4-joannelkoong@gmail.com/ .

I. e. these kbufs provide kernel-managed buffer for fast I/O.

So, I think it is good idea to deprecate splice in favor of these kbufs.

-- 
Askar Safin
