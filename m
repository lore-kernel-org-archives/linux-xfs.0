Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751046AbdFTLFx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jun 2017 07:05:53 -0400
Date: Tue, 20 Jun 2017 13:05:48 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Shutdown filesystem when a thin pool become full
Message-ID: <20170620110548.eruly7ygixydyk2o@eorzea.usersys.redhat.com>
References: <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
 <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
 <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
 <20170523122753.k7plzg3musc4up73@eorzea.usersys.redhat.com>
 <24daa89a452496d2cdffa5512a64ed2e@assyoma.it>
 <7e8e16f1-5425-44b3-e908-c0e8a3300e3f@assyoma.it>
 <a89aa00c4f86fbdc674dd8f5b5eeb248@assyoma.it>
 <20170615131433.n33sqvyes4fhcbye@eorzea.usersys.redhat.com>
 <20170615141057.q7fpnicynucq6yk2@eorzea.usersys.redhat.com>
 <f2edd27c-615b-d20f-0b03-51cc399221bb@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2edd27c-615b-d20f-0b03-51cc399221bb@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

Hi Gionatan,

On Thu, Jun 15, 2017 at 05:04:48PM +0200, Gionatan Danti wrote:
> On 15/06/2017 16:10, Carlos Maiolino wrote:
> > 
> > Disregard this comment, I messed up with some tests, so, basically, the
> > application is responsible for the user data, and need to use fsync/fdatasync to
> > ensure the data is properly written, this is not FS responsibility.
> > 
> > cheers
> 
> Hi Carlos,
> I fully agree that it is application responsibility to issue appropriate
> fsync(). However, knowing that this not always happens in real-world, I am
> trying to be as much "fail-safe" as possible.
> 
Yeah, unfortunately, the real-world has lots of bad written applications :(


> From my understanding of your previous message, a full thin pool with
> --errorwhenfull=y should return ENOSPC to the filesystem. Does this work on
> normal cached/buffered/async writes, or with O_DIRECT writes only?
> 

AFAIK, it will return ENOSPC with O_DIRECT, yes. With async writes, you won't
have any error returned until you issue a fsync/fdatasync, which, per my
understanding, it will return an EIO.

> If it is not the case, how can I prevent further writes to a data-full thin
> pool? With ext4, I can use "data=journal,errors=remount-ro" to catch any
> write errors and stop the filesystem (or remount it read-only), losing only
> some seconds worth of data. This *will* works even for applications that do
> not issue fsync(), as the read-only filesystem will not let the write()
> syscall to complete successfully.
> 
It 'works' on Ext4, because it will journal the data first, and at some point it
will try to allocate blocks for metadata, and that will fail, which will
help ext4 to catch this corner case, although, IIRC, 'data=journal' mode isn't
supported at all. I even heard rumors of the possibility to have this option
removed from Ext4, but I don't follow ext4 development close enough to tell you
if this is just a rumor or they are really considering it.

> On XFS (which I would *really* use, because it is quite more advanced), all
> writes directed to a full thin-pool will basically end on /dev/null and, as
> write() succeeded, the application/user will *not* be alerted on any way. If
> the thin-pool can communicate its "end of free space" to the filesystem, the
> problem can be avoided.
> 

The application won't be alerted in any way unless it uses fsync()/fdatasync()
with any filesystem being used, even using data=journal in ext4, this won't
happen, ext4 gets mounted as read-only because there were 'metadata' errors when
writing the file to the journal, but again, it is not a fix for a faulty
application, it is not even reliable for shutting down the filesystem the way
you are thinking this will. It will only shut down the filesystem depending on
the amount of blocks being allocated, even when using data=journal, if the
amount of blocks allocated are enough to hold the metadata, but not the data,
you will see the same problem as you are seeing with XFS (or ext4 without
data=journal), so, don't rely on it.


> If this can not be done, the only remaining possibility is to instruct the
> filesystem to stop itself on data writeout errors. So, we got full-circle
> about my original question: how can I stop XFS when writes return I/O
> errors? Please note that I tried to set any
> /sys/fs/xfs/dm-8/error/metadata/*/max_retries tunable to 0, but I can not
> get the filesystem to suspend itself, even when dmesg reported metadata
> write errors.

Yes, these options won't help, because they are configuration options
for metadata errors, not data errors.

Please, bear in mind that your question should be: "how can I stop a filesystem
when async writes return I/O errors", because this isn't a XFS issue.

BUt again, there isn't too much you can do here, async writes are supposed to
behave this way. And whoever is writing "data" to the device is supposed to care
of their own data.

Imagine for example a situation where you have 2 applications using the same
filesystem (quite common right?), then application A and B issues buffered
writes, and for some reason, application A data, hits an IO error, for any
reason, maybe a too busy storage, a missed scsi command, whatever, anything that
can be retried.

then the filesystem shuts down because of that, which will also affect
application B, even if nothing wrong happened with application B.

One of the goals of multitasking is having applications running at the same time
without affecting each other.

Now, consider that, application B is a well written application, and application
A isn't.

App B cares for its data to be written to disk, while app A doesn't.

In case of a casual error, app B will retry to write its data, while app A
won't.

Should we really shutdown the filesystem here affecting everything on the
system, because application A is not caring for its own data?

Shutting a filesystem down, has basically one purpose: avoid corruption, we
basically only shutdown a filesystem when keeping it alive can cause a problem
with everything using it (really really simple explanation here).

Surely this can be improved, but at the end, the application will always need to
check for its own data.

I am not really a device-mapper developer and I don't know much about its code
in depth. But, I know it will issue warnings when there isn't more space left,
and you can configure a watermark too, to warn the admin when the space used
reaches that watermark.

By now, I believe the best solution is to have a reasonable watermark set on the
thin device, and the Admin take the appropriate action whenever this watermark
is achieved.

Cheers.

> 
> Thank you very much.
> 
-- 
Carlos
