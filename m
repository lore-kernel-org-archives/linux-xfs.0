Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 04:31:14 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1OCV9v2020400
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 04:31:11 -0800
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2483711EC356
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 04:31:35 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.168]) by cuda.sgi.com with ESMTP id QJ1HEsaICZ4dyvWU for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 04:31:35 -0800 (PST)
Received: by ug-out-1314.google.com with SMTP id o29so720896ugd.20
        for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 04:31:33 -0800 (PST)
Date: Sun, 24 Feb 2008 13:31:29 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: xfs I/O error
Message-ID: <20080224123129.GE27124@teal.hq.k1024.org>
References: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com> <20080223220818.GC27124@teal.hq.k1024.org> <2db2c6b80802231414m38f70795n7f24fea1a40195df@mail.gmail.com> <20080224090106.GD27124@teal.hq.k1024.org> <2db2c6b80802240352o301a0d15q991efb97a1dbff82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2db2c6b80802240352o301a0d15q991efb97a1dbff82@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rekrutacja119 <rekrutacja119@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 24, 2008 at 12:52:38PM +0100, Rekrutacja119 wrote:
> smartctl -t offline is i think scheduling a SMART test
ah yes, you're right, I'm sorry.

I would recommend to use not -t offline but -t long - AFAIK, the
'offline' test just updates the attributes but not scan the whole of the
disk.

In any case, I don't think a smart test is better than badblocks...

regards,
iustin
