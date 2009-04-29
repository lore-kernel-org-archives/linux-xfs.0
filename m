Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TCofov162345 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:50:42 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A7471CF7A3A
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 05:50:40 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id boFxTPGuUYRGR9Ga for
	<xfs@oss.sgi.com>; Wed, 29 Apr 2009 05:50:40 -0700 (PDT)
Subject: Re: generating uevents by xfs
From: Andi Kleen <andi@firstfloor.org>
References: <200904281818.32127.kb@sysmikro.com.pl>
Date: Wed, 29 Apr 2009 14:50:38 +0200
In-Reply-To: <200904281818.32127.kb@sysmikro.com.pl> (Krzysztof
	=?iso-8859-1?Q?B=E2aszkowski's?= message of "Tue, 28 Apr 2009 18:18:31
	+0200")
Message-ID: <87r5zbpqsh.fsf@basil.nowhere.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Krzysztof =?iso-8859-1?Q?B=E2aszkowski?= <kb@sysmikro.com.pl>
Cc: xfs@oss.sgi.com

Krzysztof B=E2aszkowski <kb@sysmikro.com.pl> writes:

> Hello,
>
> once upon i was asked to think about such facility for notifying userspac=
e =

> when some mount point is nearly full at some level let's say e.g. 90% =

> (threshold should be configurable).
>
> here is a solution designed by me and i would like to see comments on thi=
s =

> idea and solution.

It doesn't seem to be very useful to poll in kernel for this. When you're
in kernel you could just hook into the respective functions that handle
disk allocation directly. Polling can be as well done in user space only,
so it doesn't make too much sense to put polling code into the kernel.

-Andi


-- =

ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
