Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UGii63147759 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 11:44:44 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	bBEMWOAEFmIcxtLe (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 Mar 2012 09:44:43 -0700 (PDT)
Received: by obqv19 with SMTP id v19so1353041obq.26
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 09:44:42 -0700 (PDT)
From: Kirill Malkin <kirill.malkin@starboardstorage.com>
References: <CALJQnoyM3V1Wntn5sHfxW2WwuCQuy6Qj9ukmb4WNLN5OV0ORqQ@mail.gmail.com>
	<20120330160631.GA19594@infradead.org>
In-Reply-To: <20120330160631.GA19594@infradead.org>
MIME-Version: 1.0
Date: Fri, 30 Mar 2012 12:44:41 -0400
Message-ID: <2d15488c40b89969cc1be4c09549d010@mail.gmail.com>
Subject: RE: bug #917 - deadlock on log recovery
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com

Christoph -

Thank you for getting back to me. The kernel I am using is not a vanilla
kernel.org 2.6.32, but is part of the RHEL/CentOS 6 distribution, which
has many bug fixes backported, at least up until 2.6.38 or so.
Technically, it's their latest kernel.

The bug is very difficult to reproduce even on this kernel. It occurs
while mounting a snapshot of a very large (40TB) filesystem that is in a
very active, continuous use. Once the filesystem snapshot is in that
state, it is reproducible 100% (i.e. on every mount), but it's not clear
what pushes it there. Unfortunately, a kernel upgrade on that system is
currently not possible.

Note the lockup occurs during the trimming of free list in
xfs_alloc.c:xfs_alloc_fix_freelist when it's too long (look for "Make the
freelist shorter if it's too long" comment inside this function), then for
some reason the buffer gets double-locked inside xfs_btree_get_bufs, and
the mount hangs forever. I suspect that we are not seeing this more
frequently because the free list trimming is not a typical occurrence
during recovery.

I've looked through the patches to xfs stack in kernel.org git, and found
virtually no changes to this particular area or references to something
similar. I can probably do more research into it, but would really
appreciate some guidance. Would it help to obtain the metadata backup from
that system? What could possibly cause a deadlock when the log recovery
has really no concurrency? Would it help to debug this by somehow forcing
free list trimming during the recovery?

Thanks again for your help.

Kirill

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Friday, March 30, 2012 12:07 PM
To: Kirill Malkin
Cc: xfs@oss.sgi.com; xfs-masters@oss.sgi.com
Subject: Re: bug #917 - deadlock on log recovery

On Thu, Mar 22, 2012 at 01:34:00PM -0400, Kirill Malkin wrote:
> Hi,
>
> I am wondering if someone had a chance to look at the bug #917. I
> filed it a couple of weeks ago, but haven?t seen any action. We are
> running into it quite a lot, and the only way out of it is to reboot
> the OS and drop the log. Below is another stack trace that is slightly
> different from the one I filed, but apparently it is the same bug.
>
> Please let me know if you need any other input.

Can you reproduce this with a recent kernel?  2.6.32 is fairly old and a
lot of things have changed in this area.  I quickly looked over the trace
and nothing obvious springs to mind.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
