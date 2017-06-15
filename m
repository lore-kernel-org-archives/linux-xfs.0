Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42300 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751016AbdFOOLB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Jun 2017 10:11:01 -0400
Date: Thu, 15 Jun 2017 16:10:57 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Shutdown filesystem when a thin pool become full
Message-ID: <20170615141057.q7fpnicynucq6yk2@eorzea.usersys.redhat.com>
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
 <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
 <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
 <20170523122753.k7plzg3musc4up73@eorzea.usersys.redhat.com>
 <24daa89a452496d2cdffa5512a64ed2e@assyoma.it>
 <7e8e16f1-5425-44b3-e908-c0e8a3300e3f@assyoma.it>
 <a89aa00c4f86fbdc674dd8f5b5eeb248@assyoma.it>
 <20170615131433.n33sqvyes4fhcbye@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170615131433.n33sqvyes4fhcbye@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

> > Hi all,
> > any suggestion regarding the issue?
> > 
> > Regards.
> > 
> 
> Unfortunately, there isn't much a filesystem can do here. I'll need to talk with
> device-mapper folks to get a better understanding how we can handle such cases,
> if possible at all.
> 
> The problem you are seeing there is because of buffered writes, you don't get a
> ENOSPC because the device itself virtually still has space to be allocated, so
> the lack of space is only visible when the blocks are really being allocated
> from the POOL itself, but still, there isn't much a filesystem can do here
> regarding buffered writes.
> 
> As you noticed, XFS will report errors regarding the problems to write metadata
> to the device, but again, user data, is up to the application to ensure the data
> is consistent, although 

>I think I actually found a problem with it while doing
> some tests as you mentioned, I'll need to look deeper into them.

Disregard this comment, I messed up with some tests, so, basically, the
application is responsible for the user data, and need to use fsync/fdatasync to
ensure the data is properly written, this is not FS responsibility.

cheers
>  
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
