Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 18:47:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5K1l3lR013537
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 18:47:03 -0700
Received: from zimbra.vpac.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0B87255384
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 18:47:59 -0700 (PDT)
Received: from zimbra.vpac.org (zimbra.vpac.org [202.158.218.6]) by cuda.sgi.com with ESMTP id rgZ7OJc6WAmD1LOX for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 18:47:59 -0700 (PDT)
Message-ID: <485B0C47.5060001@vpac.org>
Date: Fri, 20 Jun 2008 11:47:51 +1000
From: Brian May <brian@vpac.org>
MIME-Version: 1.0
Subject: Re: open sleeps
References: <4859EE54.6050801@vpac.org> <20080619062118.GY3700@disturbed> <4859FF40.8010206@vpac.org> <20080619084311.GA16736@infradead.org>
In-Reply-To: <20080619084311.GA16736@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Thu, Jun 19, 2008 at 04:40:00PM +1000, Brian May wrote:
>   
>> Does the following help? I still have the logs of the other processes, if 
>> required (just in case it is some weird interaction between multiple 
>> processes?)
>>
>> It seems to be pretty consistent with lock_timer_base, every time I look 
>> (assuming I haven't read the stack trace upside down...).
>>
>> Jun 19 16:33:30 hq kernel: grep          S 00000000     0 12793  12567                     (NOTLB)
>>
>> Jun 19 16:33:30 hq kernel:        f0c23e7c 00200082 000a1089 00000000 
>> 00000010 00000008 cd0db550 dfa97550 
>> Jun 19 16:33:30 hq kernel:        34f84262 00273db2 0008a1dc 00000001 
>> cd0db660 c20140a0 dfe1cbe8 00200286 
>> Jun 19 16:33:30 hq kernel:        c0125380 a4dbf26b dfa6a000 00200286 
>> 000000ff 00000000 00000000 a4dbf26b 
>> Jun 19 16:33:30 hq kernel: Call Trace:
>>
>> Jun 19 16:33:30 hq kernel:  [<c0125380>] lock_timer_base+0x15/0x2f
>>
>> Jun 19 16:33:30 hq kernel:  [<c027f960>] schedule_timeout+0x71/0x8c
>>
>> Jun 19 16:33:30 hq kernel:  [<c0124a81>] process_timeout+0x0/0x5
>>
>> Jun 19 16:33:30 hq kernel:  [<c016c801>] __break_lease+0x2a8/0x2b9
>>     
>
> That's the lease breaking code in the VFS, long before we call
> into XFS.  Looks like someone (samba?) has a least on this file and
> we're having trouble having it broken.  Try sending a report about
> this to linux-fsdevel@vger.kernel.org
>   
I feel I am going around in circles.

Anyway, I started the discussion from 
<http://www.archivum.info/linux-fsdevel@vger.kernel.org/2008-06/msg00337.html>.

In the last message (which isn't archived yet), I looked at the Samba 
process that is holding the lease. The following is the stack trace of 
this process. I don't understand why the XFS code is calling e1000 code, 
the filesystem isn't attached via the network. Perhaps this would mean 
the problem is with the network code???

Jun 20 10:54:37 hq kernel: smbd          S 00000000     0 13516  11112               13459 (NOTLB)

Jun 20 10:54:37 hq kernel:        ddd19b70 00000082 034cdfca 00000000 00000001 00000007 f7c2c550 dfa9caa0 


Jun 20 10:54:37 hq kernel:        ae402975 002779a9 0000830f 00000003 f7c2c660 c20240a0 00000001 00000286 


Jun 20 10:54:37 hq kernel:        c0125380 a5d7f11b c2116000 00000286 000000ff 00000000 00000000 a5d7f11b 


Jun 20 10:54:37 hq kernel: Call Trace:

Jun 20 10:54:37 hq kernel:  [<c0125380>] lock_timer_base+0x15/0x2f

Jun 20 10:54:37 hq kernel:  [<c027f960>] schedule_timeout+0x71/0x8c

Jun 20 10:54:37 hq kernel:  [<c0124a81>] process_timeout+0x0/0x5

Jun 20 10:54:37 hq kernel:  [<c016a115>] do_select+0x37a/0x3d4

Jun 20 10:54:37 hq kernel:  [<c016a677>] __pollwait+0x0/0xb2

Jun 20 10:54:37 hq kernel:  [<c0117778>] default_wake_function+0x0/0xc

Jun 20 10:54:37 hq kernel:  [<c0117778>] default_wake_function+0x0/0xc

Jun 20 10:54:37 hq kernel:  [<f88e998f>] e1000_xmit_frame+0x928/0x958 [e1000]

Jun 20 10:54:37 hq kernel:  [<c0121c24>] tasklet_action+0x55/0xaf

Jun 20 10:54:37 hq kernel:  [<c022950a>] dev_hard_start_xmit+0x19a/0x1f0

Jun 20 10:54:37 hq kernel:  [<f8ae3e6d>] xfs_iext_bno_to_ext+0xd8/0x191 [xfs]

Jun 20 10:54:37 hq kernel:  [<f8ac7aec>] xfs_bmap_search_multi_extents+0xa8/0xc5 [xfs]

Jun 20 10:54:37 hq kernel:  [<f8ac7b52>] xfs_bmap_search_extents+0x49/0xbe [xfs]

Jun 20 10:54:37 hq kernel:  [<f8ac7e35>] xfs_bmapi+0x26e/0x20ce [xfs]

Jun 20 10:54:37 hq kernel:  [<f8ac7e35>] xfs_bmapi+0x26e/0x20ce [xfs]

Jun 20 10:54:37 hq kernel:  [<c02547e4>] tcp_transmit_skb+0x604/0x632

Jun 20 10:54:37 hq kernel:  [<c02560d3>] __tcp_push_pending_frames+0x6a2/0x758

Jun 20 10:54:37 hq kernel:  [<c016d84e>] __d_lookup+0x98/0xdb

Jun 20 10:54:37 hq kernel:  [<c016d84e>] __d_lookup+0x98/0xdb

Jun 20 10:54:37 hq kernel:  [<c0165370>] do_lookup+0x4f/0x135

Jun 20 10:54:37 hq kernel:  [<c016dbc4>] dput+0x1a/0x11b

Jun 20 10:54:37 hq kernel:  [<c0167312>] __link_path_walk+0xbe4/0xd1d

Jun 20 10:54:37 hq kernel:  [<c016a3fb>] core_sys_select+0x28c/0x2a9

Jun 20 10:54:37 hq kernel:  [<c01674fe>] link_path_walk+0xb3/0xbd

Jun 20 10:54:37 hq kernel:  [<f8afbea1>] xfs_inactive_free_eofblocks+0xdf/0x23f [xfs]

Jun 20 10:54:37 hq kernel:  [<c016785d>] do_path_lookup+0x20a/0x225

Jun 20 10:54:37 hq kernel:  [<f8b07de5>] xfs_vn_getattr+0x27/0x2f [xfs]

Jun 20 10:54:37 hq kernel:  [<c0161b28>] cp_new_stat64+0xfd/0x10f

Jun 20 10:54:37 hq kernel:  [<c016a9c1>] sys_select+0x9f/0x182

Jun 20 10:54:37 hq kernel:  [<c0102c11>] sysenter_past_esp+0x56/0x79



I guess I also need to make sure I get this same stack trace each time.

Thanks.
Brian May
