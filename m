Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95BF27F54
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 15:29:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51875AC004
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 13:29:37 -0700 (PDT)
Received: from mail.zytor.com ([198.137.202.10]) by cuda.sgi.com with ESMTP id
	aw3nlzlkhku0MecE (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Jun 2014 13:29:32 -0700 (PDT)
In-Reply-To: <8618458.1EVJCoVbkH@wuerfel>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<538995D4.9050702@zytor.com>
	<alpine.LFD.2.11.1405311055410.17310@knanqh.ubzr>
	<8618458.1EVJCoVbkH@wuerfel>
MIME-Version: 1.0
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 01 Jun 2014 13:26:03 -0700
Message-ID: <0ab4392c-d89d-4277-914d-1696f455daab@email.android.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com

Perhaps we should make this a kernel command line option instead, with the settings: error out on outside the standard window, or a date indicating the earliest date that should be recognized and do windowing (0 for no windowing, 1970 for retconning the Unix epoch as unsigned...)

But again, the kernel is probably the least problem here...

On June 1, 2014 12:56:52 PM PDT, Arnd Bergmann <arnd@arndb.de> wrote:
>On Saturday 31 May 2014 11:46:16 Nicolas Pitre wrote:
>> > readonly if not in reality than in practice.
>> 
>> For those (legacy) filesystems with a signed 32-bit timestamps, any 
>> attempt to create a timestamp past Jan 19 03:14:06 2038 UTC should be
>
>> (silently) clamped to 0x7fffffff and that value (the last
>representable 
>> time) used as an overflow indicator.  The filesystem driver should 
>> convert that value into a corresponding overflow value for whatever 
>> kernel internal time representation being used when read back, and
>this 
>> should be propagated up to user space.  It should not be a hard error
>
>> otherwise, as you rightfully stated, everything non read-only would
>come 
>> to a halt on that day.
>
>I don't think there is much of a difference between not being able to
>write at all and all newly written files having the same timestamp,
>causing random things to break differently.
>
>The clamp to the maximum supported time stamp sounds like a reasonable
>choice for 'utimens' and related syscalls for the case of someone
>setting an arbitrary future date beyond what the file system can
>represent. Then again, I don't see a reason why that shouldn't just
>cause an error to be returned.
>
>For actually running kernels beyond 2038, the best idea I've seen so
>far is to disallow all broken code at compile time. I don't see
>a choice but to audit the entire kernel for invalid uses on both
>32 and 64 bit in the next few years. A lot of code will get changed
>in the process so we can actually keep running 32-bit kernels and
>file systems, but other code will likely go away:
>
>* any system calls that pass a time_t, timeval or timespec on
>  32-bit systems return -ENOSYS, to ensure all user land uses
>  the replacements we will put into place
>* The definition of 'time_t', 'timval' and 'timespec' can be hidden
>  from the kernel, and all code using it left out.
>* ext2 and ext3 file system code will have to be disabled, but that's
>  file since ext4 can mount old file systems.
>* until xfs gets extended, we can also disiable it at build time.
>
>For most users, we probably want to leave all that enabled by
>default until we get much closer to 2038, but a compile time
>option should allow us to test what works or doesn't, and it
>can be set by embedded developers that want to ensure their
>code keeps running for the next few decades.
>
>	Arnd

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
