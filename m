Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49958 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750813AbdAXRLq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 12:11:46 -0500
Subject: Re: [PATCH] xfs/122: reduce xfs_dsb_t size
References: <20170124170819.GP14033@birch.djwong.org>
 <20170124170930.GA24572@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cc480f83-5d14-fbeb-f56d-be4dbd002b01@sandeen.net>
Date: Tue, 24 Jan 2017 11:11:35 -0600
MIME-Version: 1.0
In-Reply-To: <20170124170930.GA24572@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On 1/24/17 11:09 AM, Christoph Hellwig wrote:
> On Tue, Jan 24, 2017 at 09:08:19AM -0800, Darrick J. Wong wrote:
>> We're not going to do reverse-mapping on the realtime device for
>> some time, so let's fix xfs/122 in the meantime.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Philosophically (I'm good at that) how do we handle tests like this
that really only work on the latest version of the code, but don't
actually indicate a bug if it fails on something older?

-Eric
