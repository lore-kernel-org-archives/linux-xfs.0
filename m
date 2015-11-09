Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AAE107F56
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 18:03:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A8368F8033
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 16:03:15 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id hswb3qaUXFjQldzB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Nov 2015 16:03:08 -0800 (PST)
Subject: Bug#804255: Please update initramfs in postinst
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.804255.B804255.144702722713128@bugs.debian.org>
Date: Sun, 8 Nov 2015 19:00:20 -0500 (EST)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1822095565.6959319.1447027220334.JavaMail.zimbra@redhat.com>
In-Reply-To: <20151106161941.15248.86048.reportbug@tack.local>
References: <20151106161941.15248.86048.reportbug@tack.local>
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>, 804255@bugs.debian.org
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
To: Steve McIntyre <steve@einval.com>, 804255@bugs.debian.org

Hi Steve,

----- Original Message -----
> Package: xfsprogs
> Version: 3.2.1
> Severity: important
> Tags: d-i
> 
> To make this work well, all filesystem tools packages for filesystems
> that are likely to be used for / and/or /usr should call
> "update-initramfs -u" in their postinst. This will

OK.

> I've checked your package and I don't see any update-initramfs
> calls.

(yep, xfsprogs has no postinst at all IIRC)

> Please add one. If you'd like help doing that postinst work, I
> can supply a patch - just ask!

That would be great, if you don't mind Steve?  Many thanks!

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
