Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33056 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753924AbeDQRFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 13:05:02 -0400
Received: by mail-oi0-f49.google.com with SMTP id 126-v6so18649020oig.0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 10:05:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180417165756.GC24738@magnolia>
References: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
 <20180417161056.GA24257@infradead.org> <CAPcyv4i05nP=wmOMwKFbdwqBrYXpcPBCmR4g2b4w8vOZaCBEnQ@mail.gmail.com>
 <20180417165756.GC24738@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 Apr 2018 10:05:00 -0700
Message-ID: <CAPcyv4h6WAdRxvrMpc43q42UR_o+rX1tPUu1keQWG4iY1Fg3TQ@mail.gmail.com>
Subject: Re: ioctl FIBMAP for dax gone in v4.17-rc1
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Xiong Zhou <xzhou@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, fstests <fstests@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>

On Tue, Apr 17, 2018 at 9:57 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Tue, Apr 17, 2018 at 09:53:47AM -0700, Dan Williams wrote:
>> On Tue, Apr 17, 2018 at 9:10 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Tue, Apr 17, 2018 at 10:40:59PM +0800, Xiong Zhou wrote:
>> >> We got these in v4.17-rc1:
>> >> 6e2608d xfs, dax: introduce xfs_dax_aops
>> >> fb094c9 ext2, dax: introduce ext2_dax_aops
>> >> 5f0663b ext4, dax: introduce ext4_dax_aops
>> >>
>> >> And we don't have ->bmap call in these aops, which may lead
>> >> to the ioctl call failure.
>> >>
>> >> Do we have any plan of adding/supporting it ?
>> >>
>> >> xfstests generic/223 covers this issue. If we are not going
>> >> to support this call for dax, we need to fix the testcase.
>> >
>> > Not supporting ->bmap is a good thing as it is hightly dangerous.
>>
>> I take this to mean "don't fix, it is another casualty of dax being
>> experimental and it won't be coming back". I can get on board with
>> that.
>>
>> Otherwise, I was about to send a series adding bmap to {xfs,ext2,ext4}_dax_ops.
>
> Frankly I'd rather see the swapfile code learn how to iomap and then we
> can get rid of bmap in xfs entirely.

Right, all I am trying to determine is if this is a regression or not.
It seems not supporting bmap on dax going forward is a feature not a
bug.
