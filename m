Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D14F97F83
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 09:54:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 67570AC009
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:54:36 -0800 (PST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id Y0otDbu1Xc7Zf3Yf
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 07:54:34 -0800 (PST)
Received: by wmec75 with SMTP id c75so90220673wme.1
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 07:54:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4425824.kIWhRaBxBZ@wuerfel>
References: <4425824.kIWhRaBxBZ@wuerfel>
Date: Tue, 3 Nov 2015 16:54:33 +0100
Message-ID: <CAHpGcM+zgZbvuMMLT8FNGaBpHqy_u3X-9+yRcQqP0UTpvo1q7w@mail.gmail.com>
Subject: Re: [PATCH] xfs: only modify ACLs if CONFIG_XFS_POSIX_ACL enabled
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Brian Foster <bfoster@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, linux-arm-kernel@lists.infradead.org

Hi Arnd,

2015-11-03 14:43 GMT+01:00 Arnd Bergmann <arnd@arndb.de>:
> A recent bug fix added a call to forget_cached_acl(), but that
> function is not always available, so we can get a build error
> here [...]

didn't expect anybody to trip over this anytime soon...

I've sent a fix yesterday,

  http://oss.sgi.com/archives/xfs/2015-11/msg00028.html

and Dave has already fixed it in for-next:

  git//git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
