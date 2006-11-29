Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 01:18:22 -0800 (PST)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.236])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAT9IDaG004035
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 01:18:14 -0800
Received: by wx-out-0506.google.com with SMTP id t4so2033233wxc
        for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 01:17:25 -0800 (PST)
Message-ID: <9a8748490611290117oc0ba880v1a6407bc4f41088f@mail.gmail.com>
Date: Wed, 29 Nov 2006 10:17:25 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c (kernel 2.6.18.1)
In-Reply-To: <20061129013214.GH44411608@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490611280749k5c97d21bx2e499d2209d27dfe@mail.gmail.com>
	 <20061129013214.GH44411608@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Keith Owens <kaos@sgi.com>

On 29/11/06, David Chinner <dgc@sgi.com> wrote:
> On Tue, Nov 28, 2006 at 04:49:00PM +0100, Jesper Juhl wrote:
> > Hi,
> >
> > One of my NFS servers just gave me a nasty surprise that I think it is
> > relevant to tell you about:
>
> Thanks, Jesper.
>
> > Filesystem "dm-1": XFS internal error xfs_trans_cancel at line 1138 of
> > file fs/xfs/xfs_trans.c.  Caller 0xffffffff8034b47e
> >
> > Call Trace:
> > [<ffffffff8020b122>] show_trace+0xb2/0x380
> > [<ffffffff8020b405>] dump_stack+0x15/0x20
> > [<ffffffff80327b4c>] xfs_error_report+0x3c/0x50
> > [<ffffffff803435ae>] xfs_trans_cancel+0x6e/0x130
> > [<ffffffff8034b47e>] xfs_create+0x5ee/0x6a0
> > [<ffffffff80356556>] xfs_vn_mknod+0x156/0x2e0
> > [<ffffffff803566eb>] xfs_vn_create+0xb/0x10
> > [<ffffffff80284b2c>] vfs_create+0x8c/0xd0
> > [<ffffffff802e734a>] nfsd_create_v3+0x31a/0x560
> > [<ffffffff802ec838>] nfsd3_proc_create+0x148/0x170
> > [<ffffffff802e19f9>] nfsd_dispatch+0xf9/0x1e0
> > [<ffffffff8049d617>] svc_process+0x437/0x6e0
> > [<ffffffff802e176d>] nfsd+0x1cd/0x360
> > [<ffffffff8020ab1c>] child_rip+0xa/0x12
> > xfs_force_shutdown(dm-1,0x8) called from line 1139 of file
> > fs/xfs/xfs_trans.c.  Return address = 0xffffffff80359daa
>
> We shut down the filesystem because we cancelled a dirty transaction.
> Once we start to dirty the incore objects, we can't roll back to
> an unchanged state if a subsequent fatal error occurs during the
> transaction and we have to abort it.
>
So you are saying that there's nothing I can do to prevent this from
happening in the future?

> If I understand historic occurrences of this correctly, there is
> a possibility that it can be triggered in ENOMEM situations. Was your
> machine running out of memoy when this occurred?
>
Not really. I just checked my monitoring software and, at the time
this happened, the box had ~5.9G RAM free (of 8G total) and no swap
used (but 11G available).


> > Filesystem "dm-1": Corruption of in-memory data detected.  Shutting
> > down filesystem: dm-1
> > Please umount the filesystem, and rectify the problem(s)
> > nfsd: non-standard errno: 5
>
> EIO gets returned in certain locations once the filesystem has
> been shutdown.
>
Makes sense.


> > I unmounted the filesystem, ran xfs_repair which told me to try an
> > mount it first to replay the log, so I did, unmounted it again, ran
> > xfs_repair (which didn't find any problems) and finally mounted it and
> > everything is good - the filesystem seems intact.
>
> Yeah, the above error report typically is due to an in-memory
> problem, not an on disk issue.
>
Good to know.


> > The server in question is running kernel 2.6.18.1
>
> Can happen to XFS on any kernel version - got a report of this from
> someone running a 2.4 kernel a couple of weeks ago....
>

Ok.  Thank you for your reply David.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
