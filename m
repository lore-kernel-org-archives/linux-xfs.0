Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7H9JDOe039430 for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 04:19:13 -0500
Received: from emh06.mail.saunalahti.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CAB21CA80CA
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 02:19:34 -0700 (PDT)
Received: from emh06.mail.saunalahti.fi (emh06.mail.saunalahti.fi
	[62.142.5.116]) by cuda.sgi.com with ESMTP id 7KZL4sKHUK8wzYdY
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 02:19:34 -0700 (PDT)
From: Arto Jantunen <viiru@debian.org>
Subject: Re: Kernel BUG when running xfs_fsr with 2.6.35.1
References: <878w47yn36.fsf@viiru.iki.fi> <20100816220941.GK10429@dastard>
Date: Tue, 17 Aug 2010 12:19:29 +0300
In-Reply-To: <20100816220941.GK10429@dastard>
	(sfid-20100817_010956_232755_D2E8C8BA) (Dave Chinner's message
	of "Tue\, 17 Aug 2010 08\:09\:41 +1000")
Message-ID: <874oetzjdq.fsf@viiru.iki.fi>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:

> On Mon, Aug 16, 2010 at 11:32:29AM +0300, Arto Jantunen wrote:
>> I had a kernel BUG yesterday when running xfs_fsr on my Debian Unstable
>> laptop. The kernel is upstream 2.6.35.1. I'm attaching the backtrace
>> below. I haven't tried reproducing the problem yet and don't know if it is
>> reproducible. I can try that, and test patches etc. if it is useful. Let me
>> know if there is any other information I can provide to help with debugging.
>
> It's not obvious what has gone wrong at all - I haven't seen
> anything like this in all my recent testing, so it's something new.
> The first oops implies the inode has not been joined to the
> transaction, but from code inspection I cannot see how that can
> happen.
>
> What compiler did you use to build the kernel? can you reproduce the
> problem at all?

I used the compiler which is available on current Debian Testing, --version
reports "gcc (Debian 4.4.4-8) 4.4.5 20100728 (prerelease)".

I'll try to reproduce the problem later today.

-- 
Arto Jantunen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
