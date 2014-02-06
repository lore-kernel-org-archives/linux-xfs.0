Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 873AF7F50
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 10:29:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6604930406B
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 08:29:34 -0800 (PST)
Received: from mail-la0-f50.google.com (mail-la0-f50.google.com
	[209.85.215.50]) by cuda.sgi.com with ESMTP id ado76seZQSNcgg9T
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 06 Feb 2014 08:29:33 -0800 (PST)
Received: by mail-la0-f50.google.com with SMTP id ec20so1636723lab.37
	for <xfs@oss.sgi.com>; Thu, 06 Feb 2014 08:29:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+QCeVRmDFjF9YMgEOR7UpdQMQU98cR0KeO1HMNoP9k1ZvOzaA@mail.gmail.com>
References: <20140204172402.380571745@bombadil.infradead.org>
	<CA+QCeVRmDFjF9YMgEOR7UpdQMQU98cR0KeO1HMNoP9k1ZvOzaA@mail.gmail.com>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Thu, 6 Feb 2014 18:29:11 +0200
Message-ID: <CA+QCeVQxTk=ZNucLG4WPrQC=oHf1sFtJ7nj5dhJg=BUyuVbsOQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] support appending AIO writes
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 5 February 2014 16:52, Sergey Meirovich <rathamahata@gmail.com> wrote:
> Hi Christoph,
>
> Thanks a lot! Applied your patches on top of 3.13.1 and they indeed
> make a huge difference.
>
>
> Append AIO
>
> chunk size           w/o patches                               with patches
> ===================================================
> 4k               6.8834 Mb/sec 1762.15 IOps      31.542 Mb/sec 8074.75 IOps
> 8k               15.321 Mb/sec 1961.12 IOps      62.873 Mb/sec 8047.71 IOps
> 16k             28.257 Mb/sec 1808.46 IOps      139.35 Mb/sec 8918.45 IOps

And with simple wrapper around io_submit() difference for 4 k is even
more impressive than with sysbench:

without patches:
=====================
bandwidth (MiB/s):    11.89
IOps:                    3044.58

with patches:
=====================
bandwidth (MiB/s):    118.16
IOps:                   30250.17

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
