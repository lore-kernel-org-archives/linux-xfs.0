Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:46815 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752294AbdEJJIy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 05:08:54 -0400
Subject: Re: Locking problems with Linux 4.9 with NFSD and `fs/iomap.c`
References: <de171adc29600902515d1424fd800678@molgen.mpg.de>
 <20170508131843.GB29840@bfoster.bfoster>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <90423117-4c49-5f61-2dcf-abf6d77c7ba3@molgen.mpg.de>
Date: Wed, 10 May 2017 11:08:52 +0200
MIME-Version: 1.0
In-Reply-To: <20170508131843.GB29840@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, it+linux-nfs@molgen.mpg.de, Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>

Dear Brian,


On 05/08/17 15:18, Brian Foster wrote:
> cc Christoph, who's more familiar with nfs and wrote the iomap bits.

Thank you.

> On Sun, May 07, 2017 at 09:09:49PM +0200, Paul Menzel wrote:

>> There seems to be a regression in Linux 4.9 compared to 4.4. Maybe you have
>> an idea.
>>
>> The system used 4.4.38 without issues, and was updated to 4.9.23 on April
>> 24th. Since Friday, the NFS exports where not accessible anymore. Rebooting
>> the system into 4.9.24, 4.9.24, and 4.9.25 didn’t change anything, and the
>> system went into the some lock right away. Booting 4.4.38 fixed the issue
>> though.
> 
> The buffered write path was rewritten with the iomap mechanism around
> 4.7 or so, so there's a pretty big functionality gap between 4.4 and
> 4.9.
> 
>> Here is more information.
>>
>> NFS doesn’t respond to a null call.
> 
> What exactly is a NULL call?

Sorry for not making that clear for non-NFS people. From *NFS Version 3 
Protocol Specification* [1]:

> Procedure NULL does not do any work. It is made available to
> allow server response testing and timing.

> Can this be reproduced easily?

Unfortunately, we don’t know how to reproduce it. It seems to happen 
after heavy input/output operations though.

```
$ sudo nfsstat -s
Server rpc stats:
calls      badcalls   badclnt    badauth    xdrcall
15644232   0          0          0          0

Server nfs v4:
null         compound
1071      0% 15643006 99%

Server nfs v4 operations:
op0-unused   op1-unused   op2-future   access       close        commit 

0         0% 0         0% 0         0% 87846     0% 42798     0% 50658 
   0%
create       delegpurge   delegreturn  getattr      getfh        link 

2805      0% 0         0% 16866     0% 8271204  21% 82924     0% 0 
   0%
lock         lockt        locku        lookup       lookup_root  nverify 

0         0% 0         0% 0         0% 64424     0% 0         0% 0 
   0%
open         openattr     open_conf    open_dgrd    putfh 
putpubfh
53848     0% 0         0% 1081      0% 20        0% 15569041 39% 0 
   0%
putrootfh    read         readdir      readlink     remove       rename 

1072      0% 7187366  18% 2045      0% 73        0% 9116      0% 5836 
   0%
renew        restorefh    savefh       secinfo      setattr 
setcltid
72534     0% 0         0% 5836      0% 0         0% 21817     0% 1854 
   0%
setcltidconf verify       write        rellockowner bc_ctl 
bind_conn
1854      0% 0         0% 7794634  19% 0         0% 0         0% 0 
   0%
exchange_id  create_ses   destroy_ses  free_stateid getdirdeleg 
getdevinfo
0         0% 0         0% 0         0% 0         0% 0         0% 0 
   0%
getdevlist   layoutcommit layoutget    layoutreturn secinfononam 
sequence
0         0% 0         0% 0         0% 0         0% 0         0% 0 
   0%
set_ssv      test_stateid want_deleg   destroy_clid reclaim_comp
0         0% 0         0% 0         0% 0         0% 0         0%
```

> Otherwise, it's not clear to me whether you've hit a deadlock or some
> kind of livelock. Have you checked syslog for any crash or hung task
> messages? Please also provide the hung task output (echo w >
> /proc/sysrq-trigger) once you've hit this state. It would be
> particularly interesting to see whether the iomap_zero_range() path is
> included in that output.

Please see the Linux messages in my reply to Christoph’s message.

> It may also be interesting to enable the xfs_zero_eof() tracepoint
> (trace-cmd start -e 'xfs:xfs_zero_eof') and see what the last few
> entries are from /sys/kernel/debug/tracing/trace_pipe.

I built `trace-cmd`, and did what you asked, but there are no messages.

```
$ sudo strace ~/src/trace-cmd/trace-cmd start -e 'xfs:xfs_zero_eof'
$ sudo cat /sys/kernel/tracing/events/xfs/xfs_zero_eof/enable
1
$ sudo cat /sys/kernel/debug/tracing/tracing_on
1
$ sudo cat /sys/kernel/debug/tracing/trace_pipe

```


Kind regards,

Paul


[1] https://www.ietf.org/rfc/rfc1813.txt
