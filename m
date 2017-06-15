Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:40360 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752409AbdFOPEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 11:04:54 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr001msb.fastweb.it (8.5.140.05)
        id 5928FD8A00DE0737 for linux-xfs@vger.kernel.org; Thu, 15 Jun 2017 17:04:52 +0200
Subject: Re: Shutdown filesystem when a thin pool become full
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
 <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
 <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
 <20170523122753.k7plzg3musc4up73@eorzea.usersys.redhat.com>
 <24daa89a452496d2cdffa5512a64ed2e@assyoma.it>
 <7e8e16f1-5425-44b3-e908-c0e8a3300e3f@assyoma.it>
 <a89aa00c4f86fbdc674dd8f5b5eeb248@assyoma.it>
 <20170615131433.n33sqvyes4fhcbye@eorzea.usersys.redhat.com>
 <20170615141057.q7fpnicynucq6yk2@eorzea.usersys.redhat.com>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <f2edd27c-615b-d20f-0b03-51cc399221bb@assyoma.it>
Date: Thu, 15 Jun 2017 17:04:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170615141057.q7fpnicynucq6yk2@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

On 15/06/2017 16:10, Carlos Maiolino wrote:
> 
> Disregard this comment, I messed up with some tests, so, basically, the
> application is responsible for the user data, and need to use fsync/fdatasync to
> ensure the data is properly written, this is not FS responsibility.
> 
> cheers

Hi Carlos,
I fully agree that it is application responsibility to issue appropriate 
fsync(). However, knowing that this not always happens in real-world, I 
am trying to be as much "fail-safe" as possible.

 From my understanding of your previous message, a full thin pool with 
--errorwhenfull=y should return ENOSPC to the filesystem. Does this work 
on normal cached/buffered/async writes, or with O_DIRECT writes only?

If it is not the case, how can I prevent further writes to a data-full 
thin pool? With ext4, I can use "data=journal,errors=remount-ro" to 
catch any write errors and stop the filesystem (or remount it 
read-only), losing only some seconds worth of data. This *will* works 
even for applications that do not issue fsync(), as the read-only 
filesystem will not let the write() syscall to complete successfully.

On XFS (which I would *really* use, because it is quite more advanced), 
all writes directed to a full thin-pool will basically end on /dev/null 
and, as write() succeeded, the application/user will *not* be alerted on 
any way. If the thin-pool can communicate its "end of free space" to the 
filesystem, the problem can be avoided.

If this can not be done, the only remaining possibility is to instruct 
the filesystem to stop itself on data writeout errors. So, we got 
full-circle about my original question: how can I stop XFS when writes 
return I/O errors? Please note that I tried to set any 
/sys/fs/xfs/dm-8/error/metadata/*/max_retries tunable to 0, but I can 
not get the filesystem to suspend itself, even when dmesg reported 
metadata write errors.

Thank you very much.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
