Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2CD19805E
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 17:44:19 -0600 (CST)
Message-ID: <513531D0.9080409@sgi.com>
Date: Mon, 4 Mar 2013 17:44:16 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 10/10] xfstests: add disk failure simulation test
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-11-git-send-email-dmonakhov@openvz.org>
	<51310B63.4070105@sgi.com> <87621ah8q4.fsf@openvz.org>
In-Reply-To: <87621ah8q4.fsf@openvz.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On 03/01/2013 07:49 PM, Dmitry Monakhov wrote:
> On Fri, 1 Mar 2013 14:11:15 -0600, Rich Johnston <rjohnston@sgi.com> wrote:
>> On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
>>> There are many situations where disk may fail for example
>>> 1) brutal usb dongle unplug
>>> 2) iscsi (or any other netbdev) failure due to network issues
>>> In this situation filesystem which use this blockdevice is
>>> expected to fail(force RO remount, abort, etc) but whole system
>>> should still be operational. In other words:
>>> 1) Kernel should not panic
>>> 2) Memory should not leak
>>> 3) Data integrity operations (sync,fsync,fdatasync, directio) should fail
>>>      for affected filesystem
>>> 4) It should be possible to umount broken filesystem
>>>
>>> Later when disk becomes available again we expect(only for journaled filesystems):
>>> 5) It will be possible to mount filesystem w/o explicit fsck (in order to caught
>>
>> typo                                     s/caught/catch/g
>>
>>>      issues like https://patchwork.kernel.org/patch/1983981/)
>>> 6) Filesystem should be operational
>>> 7) After mount/umount has being done all errors should be fixed so fsck should
>>>      not spot any issues.
>>>
>>> This test use fault enjection (CONFIG_FAIL_MAKE_REQUEST=y config option )
>>     May want to mention all the kernel config options required.
>> i.e. CONFIG_FAULT_INJECTION=y ... are there others?
>> CONFIG_FAULT_INJECTION_DEBUG_FS=y ???
> Yes, all three options are required.
>>
>>> which force all new IO requests to fail for a given device. Xfs already has
>>     to force
>>
>>> XFS_IOC_GOINGDOWN ioctl which provides similar behaviour, but it is fs speciffic
>>
>> typos s/behaviour/behavior/g  s/speciffic/specific
>>                                           > and it does it in an easy way
>> because it perform freeze_bdev() before actual
>>> shotdown.
>> typo s/shotdown/shutdown/g
> Agree with your diagnosis. My gramma is bad and I've forget to call spell check
> before submission. Should I resend this one or you fix it manually
> on commit time?

No worries, I'm sure your English is much better than any of my attempts 
to write in your native tongue. ;)
No need to resend, glad to take care of these minor changes at commit time.

commit 02e57e1e3a42856dca9061ff943ba72fa7be8469
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Feb 20 10:42:15 2013 +0000

     xfstests: add disk failure simulation test

     There are many situations where disk may fail for example
     1) brutal usb dongle unplug
     2) iscsi (or any other netbdev) failure due to network issues
     In this situation filesystem which use this blockdevice is
     expected to fail(force RO remount, abort, etc) but whole system
     should still be operational. In other words:
     1) Kernel should not panic
     2) Memory should not leak
     3) Data integrity operations (sync,fsync,fdatasync, directio) 
should fail
        for affected filesystem
     4) It should be possible to umount broken filesystem

     Later when disk becomes available again we expect(only for 
journaled filesystems):
     5) It will be possible to mount filesystem w/o explicit fsck (in 
order to catch
        issues like https://patchwork.kernel.org/patch/1983981/)
     6) Filesystem should be operational
     7) After mount/umount has being done all errors should be fixed so 
fsck should
        not spot any issues.

     This test use fault injection (CONFIG_FAULT_INJECTION=y,
     CONFIG_FAIL_MAKE_REQUEST=y and CONFIG_FAULT_INJECTION_DEBUG_FS=y config
     options) to force all new IO requests to fail for a given device. Xfs
     already has XFS_IOC_GOINGDOWN ioctl which provides similar 
behavior, but it
     is fs specific and it does it in an easy way because it performs 
freeze_bdev()
     before actual shutdown.

     Test run fsstress in background and then force disk failure.
     Once disk failed it check that (1)-(4) is true.
     Then makes disk available again and check that (5)-(7) is also true

     BE CAREFUL!! test known to cause memory corruption for XFS
     see: https://gist.github.com/dmonakhov/4953045



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
