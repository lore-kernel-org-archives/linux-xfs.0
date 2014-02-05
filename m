Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2BABA7F52
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 08:52:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD5E5AC003
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 06:52:53 -0800 (PST)
Received: from mail-la0-f47.google.com (mail-la0-f47.google.com
	[209.85.215.47]) by cuda.sgi.com with ESMTP id B3fYxSVcSWZxPRtn
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 05 Feb 2014 06:52:48 -0800 (PST)
Received: by mail-la0-f47.google.com with SMTP id hr17so400124lab.6
	for <xfs@oss.sgi.com>; Wed, 05 Feb 2014 06:52:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140204172402.380571745@bombadil.infradead.org>
References: <20140204172402.380571745@bombadil.infradead.org>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Wed, 5 Feb 2014 16:52:27 +0200
Message-ID: <CA+QCeVRmDFjF9YMgEOR7UpdQMQU98cR0KeO1HMNoP9k1ZvOzaA@mail.gmail.com>
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

Hi Christoph,

Thanks a lot! Applied your patches on top of 3.13.1 and they indeed
make a huge difference.


Append AIO

chunk size           w/o patches                               with patches
===================================================
4k               6.8834 Mb/sec 1762.15 IOps      31.542 Mb/sec 8074.75 IOps
8k               15.321 Mb/sec 1961.12 IOps      62.873 Mb/sec 8047.71 IOps
16k             28.257 Mb/sec 1808.46 IOps      139.35 Mb/sec 8918.45 IOps


On 4 February 2014 19:24, Christoph Hellwig <hch@infradead.org> wrote:
> At least XFS can support appending AIO writes easily, and Sergey has
> demonstrated a use case for them.
>
> I've not done any performance testing myself, but ensured that xfstests
> already exercises the code path.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
