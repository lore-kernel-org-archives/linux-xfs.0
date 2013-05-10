Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB1A629DF8
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 14:07:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9C308F8050
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 12:07:20 -0700 (PDT)
Received: from mail-ve0-f174.google.com (mail-ve0-f174.google.com
	[209.85.128.174]) by cuda.sgi.com with ESMTP id
	FumKR17GWnTcuu32 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 May 2013 12:07:19 -0700 (PDT)
Received: by mail-ve0-f174.google.com with SMTP id pb11so4140427veb.5
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 12:07:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130510021942.GP23072@dastard>
References: <518B08D9.1060906@gmail.com> <20130509031646.GN24635@dastard>
	<20130509072045.GO24635@dastard> <518C54AA.7070908@gmail.com>
	<20130510021942.GP23072@dastard>
Date: Fri, 10 May 2013 15:07:19 -0400
Message-ID: <CAJzLF9kmBuQ5+-7NbzPqjUxG5yUELxCxjhh=3NiTFD0dNh-UXQ@mail.gmail.com>
Subject: Re: Rambling noise #1: generic/230 can trigger kernel debug lock
	detector
From: "Michael L. Semon" <mlsemon35@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, May 9, 2013 at 10:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, May 09, 2013 at 10:00:10PM -0400, Michael L. Semon wrote:
>> On 05/09/2013 03:20 AM, Dave Chinner wrote:
>> >On Thu, May 09, 2013 at 01:16:46PM +1000, Dave Chinner wrote:
>> >>On Wed, May 08, 2013 at 10:24:25PM -0400, Michael L. Semon wrote:
>> >>No, there's definitely a bug there. Thanks for the report, Michael.
>> >>Try the patch below.
>> >
>> >Actaully, there's a bug in the error handling in that version - it
>> >fails to unlock the quotaoff lock properly on failure. The version
>> >below fixes that problem.
>> >
>> >Cheers,
>> >
>> >Dave.
>>
>> OK, I'll try this version as well.  The first version seemed to work
>> just fine.
>
> It should, the bug was in an error handling path you are unlikely to
> hit.

OK, this version looks good, too, maybe better.  The only lockdep that
I'm hitting consistently so far is caused by generic/249--a circular
dependency--but that's probably a separate issue.  The trace is on my
USB key, but the PC for this E-mail is Windows XP and can't read F2FS.
 Sorry about that.

>> xfs/012 13s ...[ 1851.323902]
>> [ 1851.325479] =================================
>> [ 1851.326551] [ INFO: inconsistent lock state ]
>> [ 1851.326551] 3.9.0+ #1 Not tainted
>> [ 1851.326551] ---------------------------------
>> [ 1851.326551] inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
>> [ 1851.326551] kswapd0/18 [HC0[0]:SC0[0]:HE1:SE1] takes:
>> [ 1851.326551]  (&(&ip->i_lock)->mr_lock){++++-+}, at: [<c11dcabf>]
>> xfs_ilock+0x10f/0x190
>> [ 1851.326551] {RECLAIM_FS-ON-R} state was registered at:
>> [ 1851.326551]   [<c105e10a>] mark_held_locks+0x8a/0xf0
>> [ 1851.326551]   [<c105e69c>] lockdep_trace_alloc+0x5c/0xa0
>> [ 1851.326551]   [<c109c52c>] __alloc_pages_nodemask+0x7c/0x670
>> [ 1851.326551]   [<c10bfd8e>] new_slab+0x6e/0x2a0
>> [ 1851.326551]   [<c14083a9>] __slab_alloc.isra.59.constprop.67+0x1d3/0x40a
>> [ 1851.326551]   [<c10c12cd>] __kmalloc+0x10d/0x180
>> [ 1851.326551]   [<c1199b56>] kmem_alloc+0x56/0xd0
>> [ 1851.326551]   [<c1199be1>] kmem_zalloc+0x11/0xd0
>> [ 1851.326551]   [<c11c666e>] xfs_dabuf_map.isra.2.constprop.5+0x22e/0x520
>
> Yup, needs a KM_NOFS allocation there because we come through
> here outside a transaction and so it doesn't get KM_NOFS implicitly
> in this case. There's been a couple of these reported in the past
> week or two - I need to do an audit and sweep them all up....
>
> Technically, though, this can't cause a deadlock on the inode we
> hold a lock on here because it's a directory inode, not a regular
> file and so it will never be seen in the reclaim data writeback path
> nor on the inode LRU when the shrinker runs. So most likely it is a
> false positive...

Thanks for looking at it.  There are going to be plenty of false
positives out there.  Is there a pecking order of what works best?  As
in...

* IRQ (IRQs-off?) checking: worth reporting...?
* sleep inside atomic sections: fascinating, but almost anything can trigger it
* multiple-CPU deadlock detection: can only speculate on a uniprocessor system
* circular dependency checking: YMMV
* reclaim-fs checking: which I knew how much developers need to
conform to reclaim-fs, or what it is

Your list will probably look totally different and have extra items,
and I'll be happy if it completely contradicts my list.

Anyway, have a good weekend!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
