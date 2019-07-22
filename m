Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54663 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfGVAFg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Jul 2019 20:05:36 -0400
Date: Mon, 22 Jul 2019 10:04:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
Message-ID: <20190722000424.GP7689@dread.disaster.area>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
 <x49zhlbe8li.fsf@segfault.boston.devel.redhat.com>
 <BYAPR04MB5816B59932372E2D97330308E7C80@BYAPR04MB5816.namprd04.prod.outlook.com>
 <x49h87iqexz.fsf@segfault.boston.devel.redhat.com>
 <BYAPR04MB58164A7ACFD3B6331404ECA3E7CA0@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB58164A7ACFD3B6331404ECA3E7CA0@BYAPR04MB5816.namprd04.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

On Sat, Jul 20, 2019 at 07:15:26AM +0000, Damien Le Moal wrote:
> Jeff,
> 
> On 2019/07/19 23:25, Jeff Moyer wrote:
> > OK, I can see how a file system eases adoption across multiple
> > languages, and may, in some cases, be easier to adopt by applications.
> > However, I'm not a fan of the file system interface for this usage.
> > Once you present a file system, there are certain expectations from
> > users, and this fs breaks most of them.
> 
> Your comments got me thinking more about zonefs specifications/features and I am
> now wondering if I am not pushing this too far in terms of simplicity. So here
> is a new RFC/Question to chew on... While keeping as a target the concept of
> "file == zone" or as close to it as possible, what do you think zonefs minimal
> feature set should be ?
> 
> One idea I have since a while back now is this:
> 1) If a zone is unused, do not show a file for it. This means adding a dynamic
> "zone allocation" code and supporting O_CREAT on open, unlink, etc. So have more
> normal file system calls behave as with a normal FS.
> 2) Allow file names to be decided by the user instead of using a fixed names.
> Again, have O_CREAT behave as expected

So now you have to implement a persistent directory structure,
atomic/transactional updates, etc. You've just added at least 2
orders of magnitude complexity to zonefs and a very substantial
amount of additional, ongoing QA to ensure it works correctly.

I think keeping it simple by exposing all zones to userspace and
leaving it to the application to track/index what zones it is
using is the simplest way forward for everyone.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
