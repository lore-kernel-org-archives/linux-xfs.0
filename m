Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E7C7E7CA3
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2016 10:13:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B97D88F8049
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2016 08:13:31 -0700 (PDT)
Received: from mail-it0-f48.google.com (mail-it0-f48.google.com
	[209.85.214.48]) by cuda.sgi.com with ESMTP id ZLC41xpYt8Uap5BO
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Jul 2016 08:13:29 -0700 (PDT)
Received: by mail-it0-f48.google.com with SMTP id f6so86634574ith.1
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2016 08:13:29 -0700 (PDT)
MIME-Version: 1.0
From: David Binderman <linuxdev.baldrick@gmail.com>
Date: Mon, 25 Jul 2016 16:13:28 +0100
Message-ID: <CAMzoamagYyR5x4UWfLb1HZ5zf4ZYQzEpTC8Q-89gd0pA4dTK5g@mail.gmail.com>
Subject: xfs_icache.c:1298]: (style) Redundant condition
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
To: david@fromorbit.com, xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dcb314@hotmail.com

Hello there,

linux-4.7/fs/xfs/xfs_icache.c:1298]: (style) Redundant condition:
eofb. '!eofb || (eofb && eofb.eof_scan_owner!=0)' is equivalent to
'!eofb || eofb.eof_scan_owner!=0'

Source code is

   ASSERT(!eofb || (eofb && eofb->eof_scan_owner != 0));

Maybe better code

   ASSERT(!eofb || (eofb->eof_scan_owner != 0));

Regards

David Binderman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
