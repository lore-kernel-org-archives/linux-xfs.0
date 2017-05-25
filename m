Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:63605 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1424225AbdEYNbL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 May 2017 09:31:11 -0400
Message-ID: <1495718961.6967.117.camel@linux.intel.com>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 25 May 2017 16:29:21 +0300
In-Reply-To: <20170525130027.GA30194@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
         <20170518062705.25902-11-hch@lst.de>
         <1495478957.6967.69.camel@linux.intel.com> <20170523084956.GB20121@lst.de>
         <1495545099.6967.81.camel@linux.intel.com> <20170525130027.GA30194@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Thu, 2017-05-25 at 15:00 +0200, Christoph Hellwig wrote:
> On Tue, May 23, 2017 at 04:11:39PM +0300, Andy Shevchenko wrote:
> > Since we introduced a union it's possible that we might access the
> > member which wasn't last modified one. So, my comment is to give an
> > attention on such possibility and avoid if there is an aliasing
> > happened.
> 
> We do for AFS (and XFS for fs fsid).  My preference would be to
> not have the v1 struct defintion but instead provide a few
> helpers in uuid.h that use get_unaligned_be* if needed:
> 
> 	uuid_v1_time_low()
> 	uuid_v1_time_mid()
> 	uuid_v1_time_time_hi_and_version()..
> 
> From his previously reply it seems like Dave doesn't like that idea
> too much, in which case I suspect moving struct uuid_v1 back into
> afs and living with cast in it is the way to go.

Personally I don't like that union stuff, so, definitely my vote to get
rid of AFS stuff in generic helpers.

OTOH if there will be more users of such API then something like you
proposed would be sufficient without introducing a union.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
