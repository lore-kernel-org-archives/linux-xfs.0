Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:46950 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdFTPDp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 11:03:45 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr001msb.fastweb.it (8.5.140.05)
        id 5928FD8A01093822 for linux-xfs@vger.kernel.org; Tue, 20 Jun 2017 17:03:43 +0200
Subject: Re: Shutdown filesystem when a thin pool become full
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Jun 2017 17:03:42 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20170620110548.eruly7ygixydyk2o@eorzea.usersys.redhat.com>
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
 <20170620110548.eruly7ygixydyk2o@eorzea.usersys.redhat.com>
Message-ID: <dee0d3cc198663bb850ef2576c84d620@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Il 20-06-2017 13:05 Carlos Maiolino ha scritto:
> 
> AFAIK, it will return ENOSPC with O_DIRECT, yes. With async writes, you 
> won't
> have any error returned until you issue a fsync/fdatasync, which, per 
> my
> understanding, it will return an EIO.
> 

Ok, I was missing that; so ENOSPC will be returned for O_DIRECT only. 
I'll take a note ;)

> 
> The application won't be alerted in any way unless it uses 
> fsync()/fdatasync()
> with any filesystem being used, even using data=journal in ext4, this 
> won't
> happen, ext4 gets mounted as read-only because there were 'metadata' 
> errors when
> writing the file to the journal, but again, it is not a fix for a 
> faulty
> application, it is not even reliable for shutting down the filesystem 
> the way
> you are thinking this will. It will only shut down the filesystem 
> depending on
> the amount of blocks being allocated, even when using data=journal, if 
> the
> amount of blocks allocated are enough to hold the metadata, but not the 
> data,
> you will see the same problem as you are seeing with XFS (or ext4 
> without
> data=journal), so, don't rely on it.
> 

This somewhat scares me. From my understanding, a full thin pool will 
eventually bring XFS to an halt (filesystem shutdown) but, from my 
testing, this can take a fair amount of time/failed writes. During this 
period, any writes will be lost without nobody noticing that. In fact, I 
opened a similar thread on the lvm mailing list discussing this very 
same problem.

> 
> Yes, these options won't help, because they are configuration options
> for metadata errors, not data errors.
> 
> Please, bear in mind that your question should be: "how can I stop a 
> filesystem
> when async writes return I/O errors", because this isn't a XFS issue.
> 
> BUt again, there isn't too much you can do here, async writes are 
> supposed to
> behave this way. And whoever is writing "data" to the device is 
> supposed to care
> of their own data.
> 
> Imagine for example a situation where you have 2 applications using the 
> same
> filesystem (quite common right?), then application A and B issues 
> buffered
> writes, and for some reason, application A data, hits an IO error, for 
> any
> reason, maybe a too busy storage, a missed scsi command, whatever, 
> anything that
> can be retried.
> 
> then the filesystem shuts down because of that, which will also affect
> application B, even if nothing wrong happened with application B.
> 
> One of the goals of multitasking is having applications running at the 
> same time
> without affecting each other.
> 
> Now, consider that, application B is a well written application, and 
> application
> A isn't.
> 
> App B cares for its data to be written to disk, while app A doesn't.
> 
> In case of a casual error, app B will retry to write its data, while 
> app A
> won't.
> 
> Should we really shutdown the filesystem here affecting everything on 
> the
> system, because application A is not caring for its own data?
> 
> Shutting a filesystem down, has basically one purpose: avoid 
> corruption, we
> basically only shutdown a filesystem when keeping it alive can cause a 
> problem
> with everything using it (really really simple explanation here).
> 
> Surely this can be improved, but at the end, the application will 
> always need to
> check for its own data.

I think the key improvement would be to let the filesystem know about 
the full thin pool - ie: returing ENOSPC at some convenient time (a wild 
guess: can we return ENOSPC during delayed block allocation?)

> 
> I am not really a device-mapper developer and I don't know much about 
> its code
> in depth. But, I know it will issue warnings when there isn't more 
> space left,
> and you can configure a watermark too, to warn the admin when the space 
> used
> reaches that watermark.
> 
> By now, I believe the best solution is to have a reasonable watermark 
> set on the
> thin device, and the Admin take the appropriate action whenever this 
> watermark
> is achieved.

Yeah, lvmthin *will* return appropriate warnings during pool filling. 
However, this require active monitoring which, albeit a great idea and 
"the right thing to do (tm)", it adds complexity and can itself fail. In 
recent enought (experimental) versions, lvmthin can be instructed to 
execute specific actions when data allocation is higher than some 
threshold, which somewhat addresses my concerns at the block layer.

Thank you for your patience and sharing, Carlos.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
