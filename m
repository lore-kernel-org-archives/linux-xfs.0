Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1FE417F47
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 23:06:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AC40CAC002
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 21:06:17 -0700 (PDT)
Received: from mail-ob0-f175.google.com (mail-ob0-f175.google.com
	[209.85.214.175]) by cuda.sgi.com with ESMTP id
	LwI3GMbiaNvR5Lbj (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2015 21:06:14 -0700 (PDT)
Received: by obbzf10 with SMTP id zf10so4641144obb.2
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 21:06:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55FA0B1D.8000905@troja.ch>
References: <55FA0B1D.8000905@troja.ch>
Date: Thu, 17 Sep 2015 06:06:13 +0200
Message-ID: <CA+o=1OUpgK6w2W9Y8JHeN7ByopEuzEx1u87FhBPTcmZRSA0Bdg@mail.gmail.com>
Subject: Re: XFS FAQ - out of date?
From: Fanael Linithien <fanael4@gmail.com>
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
To: Viktor Trojanovic <viktor@troja.ch>
Cc: xfs@oss.sgi.com

2015-09-17 2:36 GMT+02:00 Viktor Trojanovic <viktor@troja.ch>:
> I later found (very few) sources that confirmed that Grub is not compatible
> with the current XFS level 5, that SuSE created a patch for the problem but
> it wasn't adopted upstream.

It is merged upstream[1], but last GRUB release was 2.02 beta 2, which
is almost two years old. If you have no qualms about using grub-git
from AUR, there will be no problems with XFS, even with v5 superblock.

[1] http://git.savannah.gnu.org/cgit/grub.git/commit/grub-core/fs/xfs.c?id=b6e80c7778b708c1632d957d00507aad60d9e255

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
