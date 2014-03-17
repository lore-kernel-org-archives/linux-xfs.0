Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0262A7F9F
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 12:45:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8FF88F804B
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 10:45:17 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id Yz3s6Rh8nqfk0iir for
	<xfs@oss.sgi.com>; Mon, 17 Mar 2014 10:45:16 -0700 (PDT)
Date: Mon, 17 Mar 2014 18:45:16 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: elevator question
Message-ID: <20140317184516.091b253d@harpe.intellique.com>
In-Reply-To: <c9ab54d1b0462d58dcf0b8c8da768244@zbfmail.de>
References: <ea0e10e64a65dbd39cd71a826e18985e@zbfmail.de>
	<CAFLt3pg256f7iNnYtZVu6dfQ=Z5rq3Aum_zWjGk571fHA4By-w@mail.gmail.com>
	<c9ab54d1b0462d58dcf0b8c8da768244@zbfmail.de>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

Le Mon, 17 Mar 2014 18:25:32 +0100
Marko Weber|8000 <weber@zbfmail.de> =E9crivait:

> thx grozdan,
> but what, if i have mixed setup in a server ssd + sata ??
> =


Very easy, you can set the io scheduler for each device separately at
will:

echo 'noop' > /sys/block/sda/queue/scheduler
echo 'deadline' > /sys/block/sdb/queue/scheduler

You can put that in some startup script like /etc/rc.local.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
