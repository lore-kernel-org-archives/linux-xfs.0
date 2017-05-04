Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37791 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdEDIHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 04:07:49 -0400
Received: by mail-wm0-f50.google.com with SMTP id m123so7144616wma.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 May 2017 01:07:49 -0700 (PDT)
Message-ID: <DDDCF9D44B6A4D1493F62FCA5AC73CF6@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap> <20170502073501.GB6679@infradead.org>
In-Reply-To: <20170502073501.GB6679@infradead.org>
Subject: Re: xfs_alloc_ag_vextent_near() takes minutes to complete
Date: Thu, 4 May 2017 11:07:45 +0300
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="iso-8859-1";
        reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hello Brian, Cristoph,

Thank you for your responses.

> The search overhead could be high due to either fragmented free space or
> perhaps waiting on busy extents (since you have enabled online discard).
> Do you have any threads freeing space and waiting on discard operations
> when this occurs? Also, what does 'xfs_db -c "freesp -s" <dev>' show for
> this filesystem?
I disabled the discard, but the problem still happens. Output of the freesp 
command is at [1]. To my understanding this means that 60% of the free space 
is 16-31 continuous blocks, i.e., 64kb-124kb. Does this count as a 
fragmented free space?

I debugged the issue further, profiling the xfs_alloc_ag_vextent_near() call 
and what it does. Some results:

# it appears to not be triggering any READs of xfs_buf, i.e., no calls to 
xfs_buf_ioapply_map() with rw==READ or rw==READA in the same thread
# most of the time (about 95%) is spent in xfs_buf_lock() waiting in 
"down(&bp->b_sema)" call
# the average time to lock an xfs_buf is about 10-12 ms

For example, in one test it took 45778 ms to complete the 
xfs_alloc_ag_vextent_near()  execution. During this time, 6240 xfs_buf were 
locked, totalling to 42810 ms spent in locking the buffers, which is about 
93%. On average 7 ms to lock a buffer.

# it is still not clear who is holding the lock

Cristoph, I understand that kernel 3.18 is EOL at the moment, but it used to 
be a long-term kernel, so there is an expectation of stability, but perhaps 
not community support at this point.

Thanks,
Alex.


[1]
   from      to extents  blocks    pct
      1       1  155759  155759   0.00
      2       3    1319    3328   0.00
      4       7   13153   56265   0.00
      8      15  152663 1752813   0.03
     16      31 143626908 4019133338  60.17
     32      63 1484214 72838775   1.09
     64     127 9799130 876068428  13.12
    128     255 1929928 310722786   4.65
    256     511  150035 49779357   0.75
    512    1023   26496 19658529   0.29
   1024    2047   27800 41418636   0.62
   2048    4095   26369 77587481   1.16
   4096    8191   13872 80270202   1.20
   8192   16383    6653 77527746   1.16
  16384   32767    4384 100576452   1.51
  32768   65535    3967 200958816   3.01
  65536  131071    1346 127613203   1.91
131072  262143     753 141530959   2.12
262144  524287     473 168900109   2.53
524288 1048575     202 147607986   2.21
1048576 2097151      65 95394305   1.43
2097152 4194303      16 42998164   0.64
4194304 8388607       5 26710209   0.40
total free extents 157425510
total free blocks 6679263646
average free extent size 42.4281

