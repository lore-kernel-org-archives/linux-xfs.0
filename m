Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from firestarter.dermichi.com ([194.177.153.153]:56246 "EHLO
        firestarter.dermichi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1043283AbdDVIit (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Apr 2017 04:38:49 -0400
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
References: <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
 <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
 <d6f598d1-7e7e-ac85-3cdc-e4f4bfdba94e@dermichi.com>
 <20170419180811.GB41631@bfoster.bfoster>
 <268ce851-dad0-a777-526a-82ad967490cd@dermichi.com>
 <20170419205525.GD5205@birch.djwong.org>
 <86fbec25-f026-350b-ffe3-b0b182b768ac@dermichi.com>
 <20170419234838.GH12369@dastard>
 <f3e222a4-bcdb-6c61-79b0-1450c12e054f@dermichi.com>
 <20170420231603.GJ12369@dastard>
 <c8842112-444c-2051-1001-323b7180af57@dermichi.com>
 <6558ade6-bbda-1270-6f90-99943466a77e@oracle.com>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <1c5e0eb1-5c0b-f7e0-d956-8c0ce66c8db9@dermichi.com>
Date: Sat, 22 Apr 2017 10:38:43 +0200
MIME-Version: 1.0
In-Reply-To: <6558ade6-bbda-1270-6f90-99943466a77e@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 21.04.2017 11:18, Shan Hai wrote:
> 
>>
>> I also noticed that unmounting the file system takes a really long time
>> after the problem occured (up to around 5 minutes!). Even when there was
>> nothing at all going on before the unmount. Would it help to capture the
>> unmount with trace-cmd?
> 
> A huge negative dcache entries would cause a slow umount,
> please check it by 'cat /proc/sys/fs/dentry-state', the first column
> is for used(active) entries while the second is for the unused
> (negative) entries.
> 
Does this qualify as "huge"?
# cat /proc/sys/fs/dentry-state
10689551        10539266        45      0       0       0

> It can be dropped by 'echo 2 > /proc/sys/vm/drop_caches'.
> 
Won't that drop all dentries and inodes from the cache, which is what I
should be trying to avoid?

>> Here is another theory. Could it be that not the rsync's, but the rm's
>> issued by rsnapshot are causing the problem? Would it help to serialize
>> all "rm -Rf" calls? Those always delete the oldest backups, which can't
>> possibly be in the cache and because of that all those inodes need to be
>> read into memory during deletion. Maybe those rm's are filling up the
>> XFS log?
>>
Answering myself here: after removing the "rm" calls from rsnapshot the
problem completely disappeared. I've now written a separate script which
processes all "rm -Rf *" calls sequentially. I would deduce now that
parallel deletion of big directory trees were pushing the filesystem
(and xfsaild) so hard to cause those 10-15 minute stalls.

Thanks to everyone who contributed to help me solve the problem.

Have a nice weekend,
Michael
