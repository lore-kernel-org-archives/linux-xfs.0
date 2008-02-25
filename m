Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 08:48:55 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1PGmnwM001046
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 08:48:50 -0800
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC55161450C
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 08:47:05 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173]) by cuda.sgi.com with ESMTP id Dfha9ZHGTRiEFqp8 for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 08:47:05 -0800 (PST)
Received: by ug-out-1314.google.com with SMTP id o29so1594144ugd.20
        for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 08:47:04 -0800 (PST)
Message-ID: <2db2c6b80802250840r6e6f3c53m8953d3c8c07b02e8@mail.gmail.com>
Date: Mon, 25 Feb 2008 17:40:27 +0100
From: Rekrutacja119 <rekrutacja119@gmail.com>
Subject: Re: xfs I/O error
In-Reply-To: <20080224123129.GE27124@teal.hq.k1024.org>
MIME-Version: 1.0
References: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
	 <20080223220818.GC27124@teal.hq.k1024.org>
	 <2db2c6b80802231414m38f70795n7f24fea1a40195df@mail.gmail.com>
	 <20080224090106.GD27124@teal.hq.k1024.org>
	 <2db2c6b80802240352o301a0d15q991efb97a1dbff82@mail.gmail.com>
	 <20080224123129.GE27124@teal.hq.k1024.org>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

i tried doing dd if with the bs=1024, and the dd command went fine! i really
don't understand it :( i wont write zeros to it, if it is fine, since this
sector is probably correct.

any ideas what to do now?

also - still no solution to force XFS to not shutdown itself?


2008/2/24, Iustin Pop <iusty@k1024.org>:
>
> On Sun, Feb 24, 2008 at 12:52:38PM +0100, Rekrutacja119 wrote:
> > smartctl -t offline is i think scheduling a SMART test
> ah yes, you're right, I'm sorry.
>
> I would recommend to use not -t offline but -t long - AFAIK, the
> 'offline' test just updates the attributes but not scan the whole of the
> disk.
>
> In any case, I don't think a smart test is better than badblocks...
>
> regards,
> iustin
>


[[HTML alternate version deleted]]
