Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51543 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdIKGmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 02:42:37 -0400
Date: Sun, 10 Sep 2017 23:42:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS mounted with 'discard' option - deleting fio test files slow
Message-ID: <20170911064237.GA15161@infradead.org>
References: <42228B9C-D2D3-4B9C-BFCF-BC9AED4A9678@amazon.com>
 <506FE85F-21F5-444C-876D-8C25DBB442EE@amazon.com>
 <20170908232152.GA44231@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908232152.GA44231@amazon.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hao Chen <haochen@amazon.com>
Cc: "Lu, Qian" <luqia@amazon.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, amazon-linux-kernel <amazon-linux-kernel@amazon.com>

On Fri, Sep 08, 2017 at 04:21:52PM -0700, Hao Chen wrote:
> This is expected.  To get a better performance of XFS on NVMe drive, it
> is advised not use use the realtime discard option.
> 
> https://www.intel.com/content/dam/support/us/en/documents/ssdc/data-center-ssds/Intel_Linux_NVMe_Guide_330602-002.pdf

Again, this will depend on your device.  Intel in particular was the
example in my presentation for horrible performance of the NVMe
discard support - other vendors implement much better discard support,
so you'll see much better results.
