Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 16:57:51 -0700 (PDT)
Received: from mail.dvmed.net (srv5.dvmed.net [207.36.208.214])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47NvkfB019596
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 16:57:47 -0700
Message-ID: <463FB008.3080706@garzik.org>
Date: Mon, 07 May 2007 19:02:32 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org> <20070507113753.GA5439@schatzie.adilger.int> <20070507135825.f8545a65.akpm@linux-foundation.org> <20070507222103.GJ8181@schatzie.adilger.int>
In-Reply-To: <20070507222103.GJ8181@schatzie.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Andreas Dilger wrote:
> On May 07, 2007  13:58 -0700, Andrew Morton wrote:
>> Final point: it's fairly disappointing that the present implementation is
>> ext4-only, and extent-only.  I do think we should be aiming at an ext4
>> bitmap-based implementation and an ext3 implementation.
> 
> Actually, this is a non-issue.  The reason that it is handled for extent-only
> is that this is the only way to allocate space in the filesystem without
> doing the explicit zeroing.  For other filesystems (including ext3 and

Precisely /how/ do you avoid the zeroing issue, for extents?

If I posix_fallocate() 20GB on ext4, it damn well better be zeroed, 
otherwise the implementation is broken.

	Jeff
