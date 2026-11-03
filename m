Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793702630;
	b=xnEEl/g8c0sXcwMvlUq2EuP5l8K+OWPKh/e7aBbigDZMf1fEodsg5REzSNMwA7uGWlbE
	 PuXJkYGokRHH3RpSEIuFet7ApwrcXvKtIyspIx4HiivOrfC3ocooeXhS3VDHJC0qBKuW1
	 CmA/Y0qh1DEvDLOYBr1btWYXm52CZd+bzWmOHKwffH7vNa+i4EPhGA15ywoYQs8PTg8wS
	 uza0bEeIGO0u+f2NQK2lV4qgCKcd5DcXrRKm6j5oBO8MKiCIvUGJt3ZOIL5HMKoLnkYvK
	 bJWvl/6I1gx6E09RFEwpSA3STxWPf4Y9tgJDXh+L8ygzngBIvn1q155s+1XdOqOHV1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793702630;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:To:Cc:References:Subject:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=eikMRmKOtIKFihA7RtGFBBN60oPP05oBcRZhobubR1Q=;
	b=BlVCXPitIiqwovd/ThuTWc9mLQrFA7VTDudrOk7tDTqolet6d/50L2R3ENLh/IKqxH6G
	 78Daw/L2eTWb2NZKJYhND1+fDwp9dPw417O+6emCfzHT8zVBH4iD8agRox3NXv8HIhAeD
	 RmatC1E98PLh//KWknUgKVsniqkpBSrDG339Fza0khzmcj5ysbhe47WBywZOCeVk8pFyY
	 xA6Glqc0V9tQJBY+l64PRcmW94MOipMINnHE3NoSEsVpdqEcp4j8KoUwYL0up6y3Vlu0l
	 0yk617WeuZCEr36BiiL0LLZZPtlOT19C2xmwyhIq+vyAYWBdsgUy8NdwNgc8TApa16A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=web.de;
	spf=pass smtp.mailfrom=web.de;
	dkim=pass header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=isPaZqGN;
	arc=none smtp.remote-ip=212.227.17.11
Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F208C606F7E1;
	Tue,  3 Nov 2026 10:43:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F208C606F7E1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=isPaZqGN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1793702607; x=1794307407; i=markus.elfring@web.de;
	bh=eikMRmKOtIKFihA7RtGFBBN60oPP05oBcRZhobubR1Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=isPaZqGN8QeUWwFvMf/kPF0gP2z1NYbze3wTRvc1unzbPh6xXdBlHpdw8wQVLl49
	 C7pluSSZajmdl4QJoYz05wLiB7i/ylWfSqVmuADNp2aZXrohqZTitjidME/LqqD+c
	 5O0XimNSXVMKYxZXQQaJ0PU3nu2BrtyjeHanit+AVD8R35N+JCwHGkGfuF3coymw7
	 QVzgaPx1/PQim+/4gnFjWp8j4i7el1uegKFflLoT77gatv0qTvD9ZNjuN9uNepNlB
	 HFBMRCuoP7RPrnoV7l18691xnzV3/GDS7zbd1+oC8lFf053wlw7GFUSd7fsv4lRnm
	 VNaD6Z+ZI8C7Wo2EmA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mf3uS-1wrZvZ2wRu-00gpx8; Tue, 03
 Nov 2026 11:43:27 +0100
Message-ID: <717984c9-a0c2-43d8-a801-d36c18c7040d@web.de>
Date: Tue, 3 Nov 2026 11:43:18 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jianyun Gao <jianyungao89@gmail.com>, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Bill O'Donnell <billodo@sgi.com>,
 "Darrick J. Wong" <djwong@kernel.org>, David Chinner <david@fromorbit.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Lachlan McIlroy <lachlan@sgi.com>,
 Viktor Malik <vmalik@redhat.com>, Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>
References: <20261102150146.19777-1-jianyungao89@gmail.com>
Subject: Re: [PATCH] xfs: fix temporary cursor leak in btree shift corruption
 paths
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20261102150146.19777-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JsKEoR3htlDkXLu7ClGTaIyyw6vhb+7Y7dtXF308Dij1n77IMYo
 3KhwAEajAd/0SY273upCekPJOH0UsTPWTlDaLAoLX6FwFCzFxJD6wqBYpAhZYf9GJdk3PTP
 vzkFdufyH04fjh0MbNBTTRn1jDqK2wQTCclhRr9C4XiCu7yfSHb8cxKGRIBGQr3T2s6TBxg
 uEmSjWApXvRvrleebq/rA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:d/PEv0Lk21E=;i6n1mPvBjFUuP59BIAVRfrvEj4p
 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

=E2=80=A6
> held by the duplicated cursor.  Jump to error1 instead, which calls
> xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR) to properly release all
> resources.

Can further source code clean-up become helpful for affected function impl=
ementations?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv7.4-rc1#n526
=09
Regards,
Markus
