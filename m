Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EFD3595B
	for <linux-xfs@vger.kernel.org>; Sat, 11 Oct 2025 08:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760171982; cv=none; b=AO3v4kNxXfNjGHmTL5edJ1QmqA+6PQXfbEqT7i9k2Bvu5DDn2eez2FOq3yc1XncFhgJ4J1mZaYLc/zAyoPf/843afowt1iGGlKUu6mI8QSgtyplUlkHm39LbXof9n4nwxGJKbeJk6fa+9hW3ZjxlKP7dDcqXyvZfhtZtEuDAsPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760171982; c=relaxed/simple;
	bh=MdAFxKf/NT+G2N9H5/GzHB3FIzUSem2rowgjsmre3n8=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=iiEnUecznjPQyQ6t2rDZaeXEG35Duzh8zonN5zCxqpGwZjmgl32mMWZeJsX0oze1bwVwQf6QK0ddQBQr4oHkFTrOKmuYPXdhhP47grepPeGqSL8o96vspQOIPlA4t/IJj8lkF/FK5SBhqsL+47q+BMP4VQ3sqa3I2FqRs1bJicY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=torsten.rupp@gmx.net header.b=mKAadht4; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=torsten.rupp@gmx.net header.b="mKAadht4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1760171973; x=1760776773; i=torsten.rupp@gmx.net;
	bh=WGtfiU9xeiKvKxPF6U4p9b6NwhP4ajvVV5XJHVMMoJI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:To:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mKAadht46KMB/U0+r9f6ajx9P306mlJfhFI5O8LtwpCo6g70vINxPuohO6GI9OmK
	 AfjLeKPgFnRmdPXDW3+emVktT1VJs4vBQiCBQhmEflY3y7i+tsz1Ub8EOpSkpzWpq
	 zwKtTn7gLj15XeFM9eS82NR8z18SzWVu3WWwl5hAEo2aQ3keFGz5yd4vWFVYA3tT8
	 rbkl9duVtaX9OrS23irKYUC0ChZSy/H+9dRMGop97MY0PfR4dnlSNy9Exqloia9pP
	 ZDwO3OaK8s0kVH7e+W8m19013lOfkgAUtueMpyG1IDSChXiA/5+WxkPoCGfds4LsJ
	 +VvLRQx8nlrpZCntdw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.22.10] ([77.3.250.132]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1McH5a-1uXLRJ2wNY-00hpJz for
 <linux-xfs@vger.kernel.org>; Sat, 11 Oct 2025 10:39:33 +0200
Message-ID: <12998a08-acf3-4d18-9204-ecfdc37a70e5@gmx.net>
Date: Sat, 11 Oct 2025 10:39:24 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Torsten Rupp <torsten.rupp@gmx.net>
Content-Language: en-US
To: linux-xfs@vger.kernel.org
Subject: SegFault in cache code 2
Autocrypt: addr=torsten.rupp@gmx.net; keydata=
 xsDiBEO+wNARBAC9bu5L3kkV9iIY94Eihu5wccSTZ8p49M9FnJtgPu6rUvD+szor8e0yyreD
 TiBgf5ZRpWvNZ2zFdpj1+fwKNz/GTZJ7N88F9XfhuvPixFxK7GqfKzgPZT1gQ8FRimUF9eVj
 giELFdTVsAa0ipiAmYZLLZoAF6baJR3plcaE88GEzwCgpH+yfxAQx94gVLM1kDncbPTuUwcD
 /2uoevvNqQWyaoEbczevNDAyZtqj5rc0QmViopJX0mgQCMaDH2W1suVoBA+/jMWDOqsl/Aw+
 34Q/n45LXBsLglV0oKj3lT/UzT5yH3Yp9G1fnRMgKT2EH7d21CYmHKfGUKWmbmYJL9U3bknF
 XwcRwKpj6V8G0+JVODuolsWx6YQwBAC3ovtun+ZlbFeL58/M5qG/uKEejS69cUvpDHUjSNqZ
 yEO0fF7xxFKvX04KWyzUfzV44v1V3o3LYGU78FwMU0pdD8+XHvtDo3w6/POtvEU0H61QuDBC
 NnSJXoQe48dAi9K64HF6T7JYAuOBiEV30LXnTyYto0Op8DB4Z/XF5vJ9t80jVG9yc3RlbiBS
 dXBwIDx0b3JzdGVuLnJ1cHBAZ214Lm5ldD7CWwQTEQIAGwUCQ77A0AYLCQgHAwIDFQIDAxYC
 AQIeAQIXgAAKCRDWdxCwuabC6WlwAJ94+eEN8Gm59F4gZjmvzGUgPqtBRgCdEYK76JO/Dg2b
 SZXqtTqhHt2TAQDOwU0EQ77A6hAIANtZKko/D0jj707/6IqdhFLTBGmD3R6q+aWbciJlVmpX
 I3qXtvUWBaGVegAPUmxecJyIgOfSthWA2KA2KYfkJnmhCEMSbFccqKU/t0qpWbyR9G8tayWb
 W7dFhLrahneln0879jYPmg1+b1SoECCJdx1iUXktXB9WxpSztEmamkZy10S6EGt17HQRFQof
 ysk+8vfhYEv6CIUMQjpjrKEl5hQgdl61aXOYKJdJKgdJbs0XxvVDQ4IuoJrMOb7zKRswKsH+
 0tnzInx5tqvTbLeHlUZqKKTdMdURWQhNw8il+uc4CoqhbUx5Bny3UYVZMX5SU6Ulm0WJzFUU
 tKVX4FiLVOcAAwUH/iP6G63zA03VqweGUZKGgNkscrV9jaDJU1dQrZBkxWSyoBwxHq16lpGL
 XT9ieCevXkT8IqZ/7rXmpBEmI3HrQxN2muRVNV+Pt7CJ0t5317WZfC/YnQGEBGHI/n0gn0Cn
 icClYEciJow9zD5XF4auk48T8aD2qWxcHksON9L0enz8Ku/rz/pio/PSODTDwMtTJcq0Bjn2
 bboCGMDAlZPMfMNulusQFqnXhJI8L8AxZjmX9Xq+wi5TdpZYkQlTCzj+pLizvLWKBC+7OC04
 67YUiT1MekENsWUcdCOVwh4Gq6soCgOu3QHz3jez4R82KxuPbYEbMMGvcwQaMsxYbo2RoY3C
 RgQYEQIABgUCQ77A6gAKCRDWdxCwuabC6UbDAJ9RcXpuMPKWxGVOV8zDpiwV6v26GgCdFU22
 bk1TC0UY69vY5e/YkBX12pM=
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6KF3yliiVunBulSKFPuLICOtvrCStuCMTiuvFmVnI4lnws+GGEz
 wEGZS6b+JshG16JUAAyUFUcGzHz0mlDhgVjJiUi5BfYvBWjotojcsGmSyjm7WGpnlsGEtgU
 2pKuTEaMMj8BUIU8bwR8M15aoy+D4sjVseuURohanuCyMAp4GgFnGJGVHHGbNespq6FnZ2/
 XvGz8m+deaGtDW46fdL7Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:n/Ah1Sc3DRA=;iRX3WiaIKhy1rqd0+xw49MOy3M8
 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

Dear XFS developers,

it seems the fix for the segmentation fault in xfsprogs 6.16.0 in the=20
initialization of the cache is caused by a double initialization and=20
free of "xfs_extfree_item_cache" in init.c:init_caches() resp.=20
init.c:destroy_caches. This is already done in xfs_alloc.c as also=20
valgrind showed me.

This patch remove the double initialization and free. The segmentation=20
fault disappear with this patch and valgrind is also happy:

=2D-- xfsprogs-6.16.0.org/libxfs/init.c   2025-06-23 13:48:41.000000000 +0=
200
+++ xfsprogs-6.16.0/libxfs/init.c       2025-10-11 10:17:27.101472681 +020=
0
@@ -214,9 +214,6 @@
                 fprintf(stderr, "Could not allocate btree cursor=20
caches.\n");
                 abort();
         }
-       xfs_extfree_item_cache =3D kmem_cache_init(
-                       sizeof(struct xfs_extent_free_item),
-                       "xfs_extfree_item");
         xfs_trans_cache =3D kmem_cache_init(
                         sizeof(struct xfs_trans), "xfs_trans");
         xfs_parent_args_cache =3D kmem_cache_init(
@@ -236,7 +233,6 @@
         leaked +=3D kmem_cache_destroy(xfs_da_state_cache);
         xfs_defer_destroy_item_caches();
         xfs_btree_destroy_cur_caches();
-       leaked +=3D kmem_cache_destroy(xfs_extfree_item_cache);
         leaked +=3D kmem_cache_destroy(xfs_trans_cache);
         leaked +=3D kmem_cache_destroy(xfs_parent_args_cache);

Best regards, Torsten

