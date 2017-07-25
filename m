Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58318 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752225AbdGYODM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 10:03:12 -0400
Subject: Re: request for inclusion of 04197b341f23 ("xfs: don't BUG() on mixed
 direct and mapped I/O")
References: <5bcfc94b-ecb9-468b-78f3-ae5de53f62a0@suse.com>
 <666c5faf-cbee-f83b-90bf-279284f0600b@applied-asynchrony.com>
 <18dc98f7-abd8-4925-a303-7ae4c1e46db5@suse.com>
 <20170725134221.GB19075@kroah.com> <20170725134334.GC19075@kroah.com>
 <20170725134745.GA19961@kroah.com> <20170725135035.GA20865@lst.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8639f3da-77f4-6330-40f5-3c3d9cbfbc06@suse.com>
Date: Tue, 25 Jul 2017 17:02:54 +0300
MIME-Version: 1.0
In-Reply-To: <20170725135035.GA20865@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Greg KH <greg@kroah.com>
Cc: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>



On 25.07.2017 16:50, Christoph Hellwig wrote:
> On Tue, Jul 25, 2017 at 06:47:45AM -0700, Greg KH wrote:
>> Oh, and I need an ack from the xfs maintainers to be able to take this,
>> there must be some reason they didn't backport it like they did for a
>> number of other xfs patches...
> 
> In general we'd like to see xfstests runs for all stable backports,
> because file system code is hairy.
> 
> So for any xfs stable backports please send the list of patches you
> want backported, and tell us that you did indeed run xfstests.  No
> proof is required, we'd like to trust our contributors.
> 

Before including this in our enterprise distribution I did run xfstest
with and without the patch and there was no difference in the result.
Hence I sent the patch.
