Received: from out07.mymailwall.com (out07.mymailwall.com [91.212.136.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E275E7404E
	for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2026 13:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.212.136.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777554196; cv=none; b=O+9cjTzdxndj3nwLFOi1H+vvaZMnrmn0wTrE/1vR69VnHB5kzYf3QfQRjR8YcAI4wzTI7og44wwa6Hs3whkoo9t62hxKEZPTIOtlK0Nc4zQIkiwRqJiUJ2ftpOk6DeDDQguWV941JWwufTIhNU3yEewYQhApSBaTGIgpWaCPl/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777554196; c=relaxed/simple;
	bh=EqA107iRUCvaw6wGLZRQyp37pRF4CUNxi+GIwnHYqmM=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=nNlCubUxzZ9O6NxK0EFaKfNDZ4gP+kRcAKe+GiyOaVuiYA7QU71HTeqTAZ4dyTuXGJp0F5wiW5IJFMCXN0qi0qpRMAb/EccVsi7MBIifH0fHpOX7CX93GC8LUkMjnwwaGBZmSjrSek+YjQ3sCnzXEO/ISgj/+aNLXVK0GvKLby0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siedl.net; spf=pass smtp.mailfrom=siedl.net; dkim=pass (2048-bit key) header.d=siedl.net header.i=@siedl.net header.b=XR65MALa; arc=none smtp.client-ip=91.212.136.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siedl.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siedl.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siedl.net header.i=@siedl.net header.b="XR65MALa"
X-MyMailWallStatus: Email scanned(2755560420)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=siedl.net; s=mailsecurity;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:content-transfer-encoding;
	bh=gldszbu0zQZfpibmHTZbTKlbBQFB9VVD0qDZYHUrLUQ=;
	b=XR65MALaO+4Af9Muc38C8x5vVaNEQKqWDZ9Hqmx3wEive2JBW159jAZANieErBzYjKYyx3nV
	ZPu0KwHCz+7arEwnnFXwC5tAaexgxTgnV8ZoXtsDuVxeRDe/xbq8roteD73zMjw/IOrZDXl7
	FF3oeazFqkDR2cTRkxZZO9xm5+NFvAA2QVcgdlQd2QWygw622199jYSe6lof8/6ttYJrMVde
	U/bR9m/XtRNmzGe4N9SCmK2SUZFcwWTNATzH5CqwhrD4vR3h5eb5E657DPBQ+y5uz+gH8ZOi
	SkoFzHIbEOwUgf5FF4g8Th2OsNXDg3VlcAZ5lLlZac7BxQQxjbRlQw==
Received: from hiddensender by relay.mymailwall.com with ESMTP TLS id 15631 2755560420;
	Thu, 30 Apr 2026 15:00:02 +0200
Date: Thu, 30 Apr 2026 15:00:01 +0200 (CEST)
From: Patrick Fischer <patrick.fischer@siedl.net>
To: linux-xfs@vger.kernel.org
Message-ID: <323580211.1220195.1777554001363.JavaMail.zimbra@siedl.net>
Subject: xfs_scrub_all process execution results in a dead lock condition
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Thread-Index: 7SADRGU/XJKY5w56MzkOAvujSx1vcw==
Thread-Topic: xfs_scrub_all process execution results in a dead lock condition
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,
I've encountered a bug within the xfsprogs-dev utilities, particular within=
 the Python script xfs_scrub_all.
I researched the master branch and saw, that the type of sub process call i=
s like within kernel version 6.13.0-2 I stumbled across this issue.

Overview:
xfs_scrub_all.service systemd unit (or manual execution=29 is hanging due t=
o a pipe buffer exhaustion after sub process call of lsblk.

Steps to reproduce:
Create a bunch of fake block devices to enlarge the output of lsblk to more=
 than 65520 bytes:
> modprobe scsi_debug max_lunx=3D3 num_tgts=3D7 add_hosts=3D100


Run the command of xfs_scrub_all.service manually:
> /usr/sbin/xfs_scrub_all --auto-media-scan-interval 1mo


xfs_scrub_all shows a wait4 for the sub process lsblk:
> wait4(2148527,


Within sub process lsblk there is a write to FD1 / stdout:
> write(1, =22                     =7B=5Cn         =22..., 4096


Affected Code in /usr/sbin/xfs_scrub_all=5B1=5D:
> 54     cmd=3D=5B'lsblk', '-o', 'NAME,KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J'=
=5D
> 55     result =3D subprocess.Popen(cmd, stdout=3Dsubprocess.PIPE=29
> 56     result.wait(=29
> 57     if result.returncode =21=3D 0:
> 58         return fs


Actual Results:
The execution of the command above launches a sub process of lsblk and retu=
rns more than 65520 bytes, resulting in an endless wait for return.

Expected Results:
The unit / process should not enter a dead lock.

=5B1=5D https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/x=
fs_scrub_all.py.in

Regards,
Patrick Fischer

Die E-Mail wurde von IKARUS mail.security gepr=C3=BCft.
