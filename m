Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2KCYq26228799 for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 07:34:53 -0500
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	yHKwNEA01fOTfGjM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Mar 2012 05:34:50 -0700 (PDT)
Received: by lbok6 with SMTP id k6so4616453lbo.26
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 05:34:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F66F74D.3030909@hardwarefreak.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<4F64115D.50208@hardwarefreak.com> <20120317223454.GQ5091@dastard>
	<20325.17387.216150.45013@tree.ty.sabi.co.UK>
	<20325.50714.237894.328039@tree.ty.sabi.co.UK>
	<20120318140051.GA2594@infradead.org>
	<20326.13500.799169.828158@tree.ty.sabi.co.UK>
	<4F66F74D.3030909@hardwarefreak.com>
Date: Tue, 20 Mar 2012 20:34:49 +0800
Message-ID: <CAA8mOyDPhGfPUcfSi4CaTo_d0bZZGZg=2Y1eWqghmvm6LRhN6w@mail.gmail.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
From: Jessie Evangelista <jessie.evangelista@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

Thank you everyone for you insights and comments.

I made a post of how I proceeded here:
http://blog.henyo.com/2012/03/cheap-and-safe-file-storage-on-linux.html

In summary, I did some benchmarks with bonnie++ using different raid
levels(5,10n2,10f2,10o2) using different chunks(64,128,256,512,1024)
using different file systems(xfs,ext4) and different settings for each
file system.

I decided to go with ext4 because I wanted to make use of the
data=journal option which IMHO is safer albeit slower.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
