Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48461 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751392AbdB1X6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 18:58:18 -0500
Subject: Re: [RFC] failure atomic writes for file systems and block devices
References: <20170228145737.19016-1-hch@lst.de>
From: Chris Mason <clm@fb.com>
Message-ID: <e4bc2911-99ee-0049-a11d-3944c1770cff@fb.com>
Date: Tue, 28 Feb 2017 15:48:16 -0500
MIME-Version: 1.0
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org



On 02/28/2017 09:57 AM, Christoph Hellwig wrote:
> Hi all,
>
> this series implements a new O_ATOMIC flag for failure atomic writes
> to files.   It is based on and tries to unify to earlier proposals,
> the first one for block devices by Chris Mason:
>
> 	https://urldefense.proofpoint.com/v2/url?u=https-3A__lwn.net_Articles_573092_&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=P5byIhbDCF-kdlNpZVpxMKG3E36-cQ-lK27coqUFUng&s=rqXtuRMvf2rijHel_VAiO-KQ8AtQ5DXEI2obnCI_ljQ&e=
>
> and the second one for regular files, published by HP Research at
> Usenix FAST 2015:
>
> 	https://urldefense.proofpoint.com/v2/url?u=https-3A__www.usenix.org_conference_fast15_technical-2Dsessions_presentation_verma&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=P5byIhbDCF-kdlNpZVpxMKG3E36-cQ-lK27coqUFUng&s=ilnrrNs8nG4_UV2xx7tc2Efm20d2Wa8PHoJE8WUTCwI&e=
>
> It adds a new O_ATOMIC flag for open, which requests writes to be
> failure-atomic, that is either the whole write makes it to persistent
> storage, or none of it, even in case of power of other failures.
>
> There are two implementation various of this:  on block devices O_ATOMIC
> must be combined with O_(D)SYNC so that storage devices that can handle
> large writes atomically can simply do that without any additional work.
> This case is supported by NVMe.
>

Hi Christoph,

This is great, and supporting code in both dio and bio get rid of some 
of the warts from when I tried.  The DIO_PAGES define used to be an 
upper limit on the max contiguous bio that would get built, but that's 
much better now.

One thing that isn't clear to me is how we're dealing with boundary bio 
mappings, which will get submitted by submit_page_section()

sdio->boundary = buffer_boundary(map_bh);

In btrfs I'd just chain things together and do the extent pointer swap 
afterwards, but I didn't follow the XFS code well enough to see how its 
handled there.  But either way it feels like an error prone surprise 
waiting for later, and one gap we really want to get right in the FS 
support is O_ATOMIC across a fragmented extent.

If I'm reading the XFS patches right, the code always cows for atomic. 
Are you planning on adding an optimization to use atomic support in the 
device to skip COW when possible?

To turn off mysql double buffering, we only need 16K or 64K writes, 
which most of the time you'd be able to pass down directly without cows.

-chris
