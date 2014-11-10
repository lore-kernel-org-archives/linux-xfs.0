Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 755D27F6B
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 10:55:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4528A304032
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 08:55:46 -0800 (PST)
Received: from mail-qg0-f46.google.com (mail-qg0-f46.google.com
	[209.85.192.46]) by cuda.sgi.com with ESMTP id Tbyb1AebVBWyDzv4
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 10 Nov 2014 08:55:43 -0800 (PST)
Received: by mail-qg0-f46.google.com with SMTP id i50so5687890qgf.19
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 08:55:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141110135249.GR28565@dastard>
References: <20141107190959.GB21021@infradead.org>
	<20141108234232.GJ28565@dastard>
	<CAJfpegsvZtCxV-GSJ4ON7=JeNkZ7o2=+fmbOTrxDAfm==b1XBw@mail.gmail.com>
	<20141110135249.GR28565@dastard>
Date: Mon, 10 Nov 2014 17:55:43 +0100
Message-ID: <CAJfpegt9moB+Aa3VzkcFrE=BOXO7HR8MQsNvK5Jteb0PAxrMuw@mail.gmail.com>
Subject: Re: beginners project: RENAME_WHITEOUT
From: Miklos Szeredi <miklos@szeredi.hu>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 10, 2014 at 2:52 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 10, 2014 at 10:25:40AM +0100, Miklos Szeredi wrote:
>> On Sun, Nov 9, 2014 at 12:42 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Fri, Nov 07, 2014 at 11:09:59AM -0800, Christoph Hellwig wrote:
>> >> The overlayfs merge introduces a new rename flag to create to whiteouts.
>> >> Should be a fairly easy to implement.
>> >>
>> >> Miklos, do you have any good documentation and/or test cases for this?
>> >
>> > So overlayfs uses some weird char dev hack to implement whiteout
>> > inodes in directories?  Why do we need a whiteout inode on disk?
>> > what information is actually stored in the whiteout inode that
>> > overlayfs actually needs?  Only readdir and lookup care about
>> > whiteouts, and AFAICT nothing of the inode is ever used except
>> > checking the chrdev/whiteoutdev hack via ovl_is_whiteout(dentry).
>> >
>> > Indeed, whatever happened to just storing the whiteout in the dirent
>> > via DT_WHT and using that information on lookup in the lower
>> > filesystem to mark the dentry returned appropriately without needing
>> > to lookup a real inode?
>>
>> The filesystem is free to implement whiteouts a dirent without an actual inode.
>
> Sure, but overlayfs won't make use of it, so we'd have
> have to hack around overlayfs's ignorance of DT_WHT in several
> different places to do this. e.g.
>
>         - in mknod to intercept creation of magical whiteout chardevs
>         - in readdir so we can convert them to DT_CHR so overlayfs
>           can detect them,
>         - in ->lookup so we can create magical chardev inodes in
>           memory rather than try to read them from disk.
>         - in rename we have to detect the magical chardev inodes so
>           we know it's a whiteout we are dealing with

I care little where it's intercepted, in the filesystem or in the VFS.
Obviously if this is going to be done by more than one filesystem it
makes sense to gather the common bits and pieces into VFS helpers.

And overlayfs could easily make use of DT_WHT, if it was available, I
really have no problem with that.

As long as we don't have the insane DT_WHT == negative dentry on the
userspace API, it's good (i.e. you *should* be able to remove it).
And if "tar" is able to archive the thing and restore it, that's just
an added bonus.  The special chardev does all that.  So in my book
it's a perfect solution.

And while I don't care if  DT_WHT ends up not using an inode *on disk*
or not, a negative entry on disk with a positive dentry in the VFS is
bound to end up with complex and fiddly conversion layers, that may
not actually be worth it.


- "DT_WHT + S_IFCHR inode" OK, needs some conversion but not too difficult

- "DT_WHT + negative indode" OK, but fiddly

- "DT_CHR + S_IFCHR inode" OK, but sligthly suboptimal (or "completely
fucked up" depending on your POV).

The big advantage of not introducing DT_WHT is that it spares the pain
of introducing possibly incompatible on-disk format (i.e. will old
versions of fsck  going to balk at it?  will old kernels reject the
image containing DT_WHT?)

If the filesystem and tools are already prepared for the DT_WHT dirent
type then that's a non-issue, obviously.

Thanks,
Miklos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
