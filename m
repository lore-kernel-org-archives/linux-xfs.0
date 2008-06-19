Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 23:39:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5J6dDGU017138
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 23:39:13 -0700
Received: from zimbra.vpac.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A1D4CEECA8
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 23:40:10 -0700 (PDT)
Received: from zimbra.vpac.org (zimbra.vpac.org [202.158.218.6]) by cuda.sgi.com with ESMTP id y8qoeG6JAAsT7xza for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 23:40:10 -0700 (PDT)
Message-ID: <4859FF40.8010206@vpac.org>
Date: Thu, 19 Jun 2008 16:40:00 +1000
From: Brian May <brian@vpac.org>
MIME-Version: 1.0
Subject: Re: open sleeps
References: <4859EE54.6050801@vpac.org> <20080619062118.GY3700@disturbed>
In-Reply-To: <20080619062118.GY3700@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brian May <brian@vpac.org>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Thu, Jun 19, 2008 at 03:27:48PM +1000, Brian May wrote:
>   
>> Hello,
>>
>> I am having (weird) issues with XFS, in that open(...) on certain files  
>> takes 45 seconds to return. After the file has been opened, the next  
>> file in the same directory takes 45 seconds. If the file was recently  
>> opened it returns immediately.
>>
>> I thought this was a low level I/O issue, so copied the files in  
>> question to a completely independent RAID array  (separate LVM, RAID,  
>> controllers, disks), but the problem remains.
>>
>> More details at thread starting from  
>> <http://lists.luv.asn.au/wws/arc/luv-main/2008-06/msg00143.html>.
>>
>> Any ideas?
>>     
>
> # echo t > /proc/sysrq-trigger
>
> when it is hung to get a stack trace of the blocked open call.
>
> Cheers,
>
> Dave.
>   
Does the following help? I still have the logs of the other processes, 
if required (just in case it is some weird interaction between multiple 
processes?)

It seems to be pretty consistent with lock_timer_base, every time I look 
(assuming I haven't read the stack trace upside down...).

Jun 19 16:33:30 hq kernel: grep          S 00000000     0 12793  12567                     (NOTLB)

Jun 19 16:33:30 hq kernel:        f0c23e7c 00200082 000a1089 00000000 00000010 00000008 cd0db550 dfa97550 

Jun 19 16:33:30 hq kernel:        34f84262 00273db2 0008a1dc 00000001 cd0db660 c20140a0 dfe1cbe8 00200286 

Jun 19 16:33:30 hq kernel:        c0125380 a4dbf26b dfa6a000 00200286 000000ff 00000000 00000000 a4dbf26b 

Jun 19 16:33:30 hq kernel: Call Trace:

Jun 19 16:33:30 hq kernel:  [<c0125380>] lock_timer_base+0x15/0x2f

Jun 19 16:33:30 hq kernel:  [<c027f960>] schedule_timeout+0x71/0x8c

Jun 19 16:33:30 hq kernel:  [<c0124a81>] process_timeout+0x0/0x5

Jun 19 16:33:30 hq kernel:  [<c016c801>] __break_lease+0x2a8/0x2b9

Jun 19 16:33:30 hq kernel:  [<c0117778>] default_wake_function+0x0/0xc

Jun 19 16:33:30 hq kernel:  [<c0166450>] may_open+0x125/0x203

Jun 19 16:33:30 hq kernel:  [<c0168451>] open_namei+0x23d/0x5c8

Jun 19 16:33:30 hq kernel:  [<c0158cb8>] do_filp_open+0x1c/0x31

Jun 19 16:33:30 hq kernel:  [<c0161f38>] sys_stat64+0x1e/0x23

Jun 19 16:33:30 hq kernel:  [<c0158d0b>] do_sys_open+0x3e/0xb3

Jun 19 16:33:30 hq kernel:  [<c0158dad>] sys_open+0x16/0x18

Jun 19 16:33:30 hq kernel:  [<c0102c11>] sysenter_past_esp+0x56/0x79



Jun 19 16:33:50 hq kernel: grep          S 00000000     0 12793  12567                     (NOTLB)

Jun 19 16:33:50 hq kernel:        f0c23e7c 00200082 000a1089 00000000 00000010 00000008 cd0db550 dfa97550 

Jun 19 16:33:50 hq kernel:        34f84262 00273db2 0008a1dc 00000001 cd0db660 c20140a0 dfe1cbe8 00200286 

Jun 19 16:33:50 hq kernel:        c0125380 a4dbf26b dfa6a000 00200286 000000ff 00000000 00000000 a4dbf26b 

Jun 19 16:33:50 hq kernel: Call Trace:

Jun 19 16:33:50 hq kernel:  [<c0125380>] lock_timer_base+0x15/0x2f

Jun 19 16:33:50 hq kernel:  [<c027f960>] schedule_timeout+0x71/0x8c

Jun 19 16:33:50 hq kernel:  [<c0124a81>] process_timeout+0x0/0x5

Jun 19 16:33:50 hq kernel:  [<c016c801>] __break_lease+0x2a8/0x2b9

Jun 19 16:33:50 hq kernel:  [<c0117778>] default_wake_function+0x0/0xc

Jun 19 16:33:50 hq kernel:  [<c0166450>] may_open+0x125/0x203

Jun 19 16:33:50 hq kernel:  [<c0168451>] open_namei+0x23d/0x5c8

Jun 19 16:33:50 hq kernel:  [<c0158cb8>] do_filp_open+0x1c/0x31

Jun 19 16:33:50 hq kernel:  [<c0161f38>] sys_stat64+0x1e/0x23

Jun 19 16:33:50 hq kernel:  [<c0158d0b>] do_sys_open+0x3e/0xb3

Jun 19 16:33:50 hq kernel:  [<c0158dad>] sys_open+0x16/0x18

Jun 19 16:33:50 hq kernel:  [<c0102c11>] sysenter_past_esp+0x56/0x79


Thanks.

Brian May
