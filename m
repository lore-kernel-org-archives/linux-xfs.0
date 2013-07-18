Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F19B97F3F
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 19:17:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B45478F8039
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 17:17:38 -0700 (PDT)
Received: from mail-ve0-f178.google.com (mail-ve0-f178.google.com
	[209.85.128.178]) by cuda.sgi.com with ESMTP id
	JGtCnoXCs7B6vWvb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jul 2013 17:17:37 -0700 (PDT)
Received: by mail-ve0-f178.google.com with SMTP id pb11so2043386veb.9
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 17:17:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130717234049.GC3572@sgi.com>
References: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard> <20130716193332.GB3572@sgi.com>
	<CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
	<CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
	<20130717040616.GI11674@dastard>
	<CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
	<20130717055103.GK11674@dastard>
	<CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
	<20130717234049.GC3572@sgi.com>
Date: Wed, 17 Jul 2013 17:17:36 -0700
Message-ID: <CA+55aFy-8QH4bTW7hU=381tuEWgHC=PUM6WP3qn-ooge=7M0QQ@mail.gmail.com>
Subject: Re: splice vs execve lockdep trace.
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Ben Myers <bpm@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

On Wed, Jul 17, 2013 at 4:40 PM, Ben Myers <bpm@sgi.com> wrote:
>>
>> We're still talking at cross purposes then.
>>
>> How the hell do you handle mmap() and page faulting?
>
> __xfs_get_blocks serializes access to the block map with the i_lock on the
> xfs_inode.  This appears to be racy with respect to hole punching.

Would it be possible to just make __xfs_get_blocks get the i_iolock
(non-exclusively)?

Or, alternatively, do it in the readpage() function?

That was what I thought you did anyway. Exactly because of the whole
page faulting issue.

                   Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
