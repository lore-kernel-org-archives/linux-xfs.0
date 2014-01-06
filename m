Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A2877F37
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 15:47:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86F4A304039
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 13:47:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YJmBXis3CcaXv1Fm for
	<xfs@oss.sgi.com>; Mon, 06 Jan 2014 13:47:00 -0800 (PST)
Message-ID: <52CB2452.70507@redhat.com>
Date: Mon, 06 Jan 2014 15:46:58 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: kill lib/random.c
References: <1389038323-8304-1-git-send-email-jbacik@fb.com>
	<52CB20ED.1010705@redhat.com> <52CB2336.2060009@fb.com>
In-Reply-To: <52CB2336.2060009@fb.com>
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
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 1/6/14, 3:42 PM, Josef Bacik wrote:
> 
> On 01/06/2014 04:32 PM, Eric Sandeen wrote:
>> On 1/6/14, 1:58 PM, Josef Bacik wrote:
>>> I was trying to reproduce something with fsx and I noticed that no matter what
>>> seed I set I was getting the same file.  Come to find out we are overloading
>>> random() with our own custom horribleness for some unknown reason.  So nuke the
>>> damn thing from orbit and rely on glibc's random().  With this fix the -S option
>>> actually does something with fsx.  Thanks,
>> Hm, old comments seem to indicate that this was done <handwave> to make random
>> behave the same on different architectures (i.e. same result from same seed,
>> I guess?)  I . . . don't know if that is true of glibc's random(), is it?
>>
>> I'd like to dig into the history just a bit before we yank this, just to
>> be sure.
> 
> I think that if we need the output to match based on a predictable
> random() output then we've lost already. We shouldn't be checking for
> specific output (like inode numbers or sizes etc) that are dependant
> on random()'s behaviour, and if we are we need to fix those tests. So
> even if that is why it was put in place originally I'd say it is high
> time we ripped it out and fixed up any tests that rely on this
> behaviour. Thanks,

Yeah, you're probably right.  And the ancient xfstests history seems to
be lost in the mists of time, at least as far as I can see.  So I'm ok
with this but let's let Dave & SGI chime in too just to be certain.

Thanks,
-Eric

> Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
