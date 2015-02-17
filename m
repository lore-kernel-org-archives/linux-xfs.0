Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBCC17F4E
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 09:37:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D7A3B8F8039
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 07:37:05 -0800 (PST)
Received: from mail-qa0-f52.google.com (mail-qa0-f52.google.com
	[209.85.216.52]) by cuda.sgi.com with ESMTP id eMRETFiFTYRkvhhC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2015 07:37:04 -0800 (PST)
Received: by mail-qa0-f52.google.com with SMTP id v10so26739857qac.11
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 07:37:03 -0800 (PST)
Message-ID: <54E36016.20908@gmail.com>
Date: Tue, 17 Feb 2015 10:36:54 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: xfs_alloc_fix_minleft can underflow near ENOSPC
References: <1423782857-11800-1-git-send-email-david@fromorbit.com>
	<54DE8B6D.8010401@sgi.com> <20150214232951.GW4251@dastard>
	<54E16667.1050200@gmail.com> <54E22A76.40106@sgi.com>
	<20150216231716.GB4251@dastard>
In-Reply-To: <20150216231716.GB4251@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 02/16/15 18:17, Dave Chinner wrote:
> On Mon, Feb 16, 2015 at 11:35:50AM -0600, Mark Tinguely wrote:
>> Thanks Michael, you don't need to hold your test box for me. I do
>> have a way to recreate these ABBA AGF buffer allocation deadlocks
>> and understand the whys and hows very well. I don't have a community
>> way to make a xfstest for it but I think your test is getting close.
> 
> If you know what is causing them, then please explain how it occurs
> and how you think it needs to be fixed. Just telling us that you know
> something that we don't doesn't help us solve the problem. :(
> 
> In general, the use of the args->firstblock is supposed to avoid the
> ABBA locking order issues with multiple allocations in the one
> transaction by preventing AG selection loops from looping back into
> AGs with a lower index than the first allocation that was made.
> 
> So if you are seeing deadlocks, then it may be that we aren't
> following this constraint correctly in all locations....
> 
> Cheers,
> 
> Dave.

Will this be a classic deadlock that will cause problems when trying to
kill processes and unmount filesystems?  If so, then I was unable to use
generic/224 to trigger a deadlock.  If not, then I'll need a better way
of looking at the problem.

The longest generic/224 loop lasted only 3-1/2 hours, though.  The
fstests enospc group was given some consideration as well.

If this issue does not require a lot of files, I might see if fio can 
be helpful here.

Hints on whether to us a fast kernel or a miserably slow kernel would 
be rather helpful.

My test setup is torn because most of the recent warning messages are
coming from the CONFIG_XFS_WARN kernels.  The i686 Pentium 4 box will be
left that way.  However, the Core 2 box was configured per
Documentation/SubmitChecklist from the kernel source, adding debug XFS
and locktorture.  The locktorture settings are in flux, exercising 
spinlocks at present.  There was a mild halt in I/O for generic/017, but 
that was XFS waiting on kmem-something waiting on a kmemleak function.  
kmemleak was removed, and I'll continue from there.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
