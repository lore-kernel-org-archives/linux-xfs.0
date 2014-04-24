Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D79127F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 01:55:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56A1BAC007
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 23:54:57 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	EW8q4vsMy1135TuL (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 23:54:55 -0700 (PDT)
Received: by mail-wi0-f182.google.com with SMTP id d1so540421wiv.9
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 23:54:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJhmKHk5fWVaDTEfL_oESULspavk83eBEsyw7=qEp8bC7f2S2g@mail.gmail.com>
References: <CAJhmKHmwvCBx=arJ6m2ZhuQVq=Jj-XbBGvEPjTPY5a1QtWRTCQ@mail.gmail.com>
	<20140408015012.GB22917@dastard>
	<CAJhmKHnap0vu8m4AXBxJr9L0RKoquFrm3NjKQdDBJwpRTYmfpw@mail.gmail.com>
	<20140408053117.GJ27017@dastard>
	<CAJhmKHk5fWVaDTEfL_oESULspavk83eBEsyw7=qEp8bC7f2S2g@mail.gmail.com>
Date: Thu, 24 Apr 2014 08:54:54 +0200
Message-ID: <CAAxjCEzdYRug8CUjhmB7AHJCNAJs4ERRTLXGAHXqi1sw-vOriw@mail.gmail.com>
Subject: Re: XFS fragmentation on file append
From: Stefan Ring <stefanrin@gmail.com>
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
To: Keyur Govande <keyurgovande@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Linux fs XFS <xfs@oss.sgi.com>

I've become interested in this topic, as I'm also running MySQL with
O_DIRECT and innodb_file_per_table. Out of curiosity, I immediately
ran xfs_bmap on a moderately sized table space (34GB). It listed
around 30000 fragments, on average one for every MB.

I want to report what happened then: A flurry of activity started on
both disks (root/swap lives on one of them, the data volume containing
the MySQL files on another) and lasted for about two minutes.
Afterwards, all memory previously allocated to the file cache has
become free, and also everything XFS seems to keep buffered internally
(I think it's called SReclaimable) was released. Swap usage increased
only slightly. dmesg was silent during that time.

This is a 2.6.32-358.2.1.el6.x86_64 kernel with xfsprogs 3.1.1 (CentOS
6.4). The machine has 64GB of RAM (2 NUMA nodes) and 24 (virtual)
cores. Is this known behavior of xfs_bmap?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
