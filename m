Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D57A7CA0
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 09:57:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2BBB304048
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 07:57:12 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id WmkBFTbwXcvi6baV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 May 2016 07:57:11 -0700 (PDT)
Subject: Bug#822369: fixed in qemu 1:2.6+dfsg-1
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.822369.B822369.14636697116049@bugs.debian.org>
References: <573DCFAA.8000500@physik.fu-berlin.de>
	<573DD225.5040502@msgid.tls.msk.ru>
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <573DD3CC.6040608@physik.fu-berlin.de>
Date: Thu, 19 May 2016 16:55:08 +0200
MIME-Version: 1.0
In-Reply-To: <573DD225.5040502@msgid.tls.msk.ru>
Reply-To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	822369@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: 822369@bugs.debian.org

On 05/19/2016 04:48 PM, Michael Tokarev wrote:
> Actually it is more interesting.  This bug is listed in qemu bug list,
> see https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=qemu , AND in
> xfsprogs bug list, see
> https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=xfsprogs

If you look closer that the package is actually "xfsprogs" in both
cases. The bug just shows up in the bug tracker of the qemu package
because it is affected by the bug.

If that is no longer the case, we should remove the association
here, i.e. removing "affects src:qemu", but not close the actual
bug because the package which is the actual origin of the bug has
not been fixed yet.

> I closed it thinking it is in qemu.  But I closed it wrongly anyway,
> and that's where I should've been more careful.  In qemu there was
> a workaround proposed for this issue, but it hasn't been applied,
> and I thought it has been.  So it has already been reopened meanwhile.

Apparently the workaround has been applied in qemu, otherwise qemu
wouldn't build. I will verify that. I have to build a patched version
of qemu for sparc64 manually anyway.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
