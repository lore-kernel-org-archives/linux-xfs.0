Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:6573 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752193AbdJPWcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 18:32:00 -0400
Date: Tue, 17 Oct 2017 09:31:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: agcount for 2TB, 4TB and 8TB drives
Message-ID: <20171016223158.GK15067@dastard>
References: <20171009112306.GM3666@dastard>
 <89a7ae9a-9960-ae37-f6ca-0c1f2e33f65f@scylladb.com>
 <20171009220332.GP3666@dastard>
 <38bd7785-174d-fd09-fc1f-50a2d4e1dd69@scylladb.com>
 <20171010225524.GV3666@dastard>
 <86635b89-5016-5cd1-53a2-bf21b842ae04@scylladb.com>
 <20171014224224.GD15067@dastard>
 <db0ca95f-ce16-4b2e-7d69-52f3552a6004@scylladb.com>
 <20171015220018.GG3666@dastard>
 <10d04693-02ef-427f-95fe-cc7bcaf3ec6f@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10d04693-02ef-427f-95fe-cc7bcaf3ec6f@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 01:00:32PM +0300, Avi Kivity wrote:
> On 10/16/2017 01:00 AM, Dave Chinner wrote:
> >On Sun, Oct 15, 2017 at 12:36:03PM +0300, Avi Kivity wrote:
> >>On 10/15/2017 01:42 AM, Dave Chinner wrote:
> >>>On Fri, Oct 13, 2017 at 11:13:24AM +0300, Avi Kivity wrote:
> >>Even better would be if XFS would detect the sequential write and
> >>start allocating ahead of it.
> >That's what delayed allocation does with buffered IO. We
> >specifically do not do that with direct IO because it's direct IO
> >and we only do exactly what the IO the user submits requires us to
> >do.
> >
> >As it is, I'm not sure that it would gain us anything over extent
> >size hints because they are effectively doing exactly the same thing
> >(i.e.  allocate ahead) on every write that hits a hole beyond
> >EOF when extending the file....
> 
> If I understand correctly, you do get momentary serialization when
> you cross a hint boundary, while with allocate ahead, you would not.

Allocate ahead still requires a threshold to be crossed to trigger
allocation. So it doesn't get rid of allocation, it just changes
what IO triggers it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
