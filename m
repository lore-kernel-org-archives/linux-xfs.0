Received: from cl6.mikrovps.hu (cl6.mikrovps.hu [139.28.140.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F482141B5
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 12:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.28.140.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728651122; cv=none; b=OrfFNasFB/Ob1t5f5GsGQXo57v1wDMl68Ycnr0N0cpv/AnPRXJ65A2t0fg3HNABcdhHiYwPa7e53ouXFm3glSxgYeCPnk57HeQWioOoe7Hi56vIkIk7osAkKHshrXIjJquu/Gggz9Q8FBmkSprrW8klOikyu+WZ/LJsqAf+DRRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728651122; c=relaxed/simple;
	bh=tcFYnmF2zONxPGURqXGK4LUzvQKdrP48HJPNUofaGLI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=a821hsFoBrvl/nigXk+PkQcASLzcJw33wwLOR/wAh7C1MKYJvRr44K2FGFiE0gq+XopJGFItg06btffpMimuaf2zpFwCK9LnSkI6KXyo+2jhHoMqET0fqqyOJgFjukM2/T7n48ytWy40vTpuPynngoivoh8FhdLBr2I0A1w1nU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rezso.net; spf=pass smtp.mailfrom=rezso.net; dkim=pass (2048-bit key) header.d=rezso.net header.i=@rezso.net header.b=GYn0SBLt; arc=none smtp.client-ip=139.28.140.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rezso.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rezso.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rezso.net header.i=@rezso.net header.b="GYn0SBLt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rezso.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HdnBWBfrf/Usf3DxCfdQM2H4RvWj01hYiVAqVqqU0Rk=; b=GYn0SBLtWNprJVWNxF1YRJvhLF
	y+QKZL6eVP1wcMsVORCBmjRnhQRb3jKNFWtkWx2yRM27j0LIzdlhdCQmOK/ES7XgfdbShIvDwgSqj
	1BdSev+I/vQNlf6vo8fo8uVapgDsE337Py+XKeB0tM9pghza5kZxPAI4MPqxxBov6Bi3RhQfAX3ad
	DMMsP6TcVokoLfru0Z4WEQywRdiUQzHxnMvMj6wWK7aCuHiHZxdHNi7S/EyfLf5a5Ae4jkZifGDAh
	IpvVTzeIBQTLcEimIgXMfWaMOOMPfCdw6GrnaIK9BORg2IJlI6PthHP3hkYM06TyTcaEyiRqFXH4g
	Nn5HyChw==;
Received: from 188-143-97-82.pool.digikabel.hu ([188.143.97.82]:58300 helo=rezso)
	by cl6.mikrovps.hu with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <rezso@rezso.net>)
	id 1szEYE-00000008mq5-2hy1
	for linux-xfs@vger.kernel.org;
	Fri, 11 Oct 2024 14:15:22 +0200
Date: Fri, 11 Oct 2024 14:15:22 +0200
From: =?UTF-8?B?UMOhZGVyIFJlenPFkQ==?= <rezso@rezso.net>
To: linux-xfs@vger.kernel.org
Subject: xfsprogs build: missing hard dependency?
Message-ID: <20241011141522.36415e20@rezso>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cl6.mikrovps.hu
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rezso.net
X-Get-Message-Sender-Via: cl6.mikrovps.hu: authenticated_id: rezso@rezso.net
X-Authenticated-Sender: cl6.mikrovps.hu: rezso@rezso.net

Hello,


I tried to compile now the xfsprogs 6.10.1 release, but it failed:


/bin/ld: fsproperties.o: in function `fileio_to_fsprops_handle':
/var/uhubuild/work/compile/io/fsproperties.c:63:(.text+0x155): undefined reference to `fsprops_open_handle'
/bin/ld: fsproperties.o: in function `print_fsprop':
/var/uhubuild/work/compile/io/fsproperties.c:99:(.text+0x26d): undefined reference to `fsprops_get'
/bin/ld: fsproperties.o: in function `listfsprops_f':
/var/uhubuild/work/compile/io/fsproperties.c:133:(.text+0x380): undefined reference to `fsprops_walk_names'
/bin/ld: /var/uhubuild/work/compile/io/fsproperties.c:139:(.text+0x390): undefined reference to `fsprops_free_handle'
/bin/ld: fsproperties.o: in function `removefsprops_f':
/var/uhubuild/work/compile/io/fsproperties.c:331:(.text+0x48f): undefined reference to `fsprops_remove'
/bin/ld: /var/uhubuild/work/compile/io/fsproperties.c:339:(.text+0x4a8): undefined reference to `fsprops_free_handle'
/bin/ld: fsproperties.o: in function `getfsprops_f':
/var/uhubuild/work/compile/io/fsproperties.c:189:(.text+0x5b6): undefined reference to `fsprops_get'
/bin/ld: /var/uhubuild/work/compile/io/fsproperties.c:199:(.text+0x5e3): undefined reference to `fsprops_free_handle'
/bin/ld: fsproperties.o: in function `setfsprops_f':
/var/uhubuild/work/compile/io/fsproperties.c:271:(.text+0x6d4): undefined reference to `fsprops_set'
/bin/ld: /var/uhubuild/work/compile/io/fsproperties.c:284:(.text+0x74f): undefined reference to `fsprops_free_handle'
collect2: error: ld returned 1 exit status

These functions are defined in libfrog/fsprops.h, but this is included
only if the libattr is exists.

After adding libattr to build dependencies, the build is succesful, so
I think, the libattr always needed for this source.

-- 
Bestr regards.

Rezso
