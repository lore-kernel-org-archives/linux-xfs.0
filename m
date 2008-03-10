Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 03:02:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2AA2FNZ006914
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 03:02:16 -0700
Received: from wx-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CB1E67B299
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 03:02:29 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.238]) by cuda.sgi.com with ESMTP id vsX7yNJqo40XVmsS for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 03:02:29 -0700 (PDT)
Received: by wx-out-0506.google.com with SMTP id s9so1814129wxc.32
        for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 03:02:28 -0700 (PDT)
Message-ID: <1a4a774c0803100302y17530814wee7522aa0dfd7668@mail.gmail.com>
Date: Mon, 10 Mar 2008 11:02:28 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
In-Reply-To: <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
	 <20080213214551.GR155407@sgi.com>
	 <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com>
	 <1a4a774c0803060310w2642224w690ac8fa13f96ec@mail.gmail.com>
	 <1a4a774c0803070319j1eb8790ek3daae4a16b3e6256@mail.gmail.com>
	 <20080310000809.GU155407@sgi.com>
	 <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 10, 2008 at 9:34 AM, Christian Røsnes
<christian.rosnes@gmail.com> wrote:
>  On Mon, Mar 10, 2008 at 1:08 AM, David Chinner <dgc@sgi.com> wrote:
>  > On Fri, Mar 07, 2008 at 12:19:28PM +0100, Christian Røsnes wrote:
>  >
>  >  > Instrumenting the code, I found that this occurs on my system when I
>  >  > do a 'mkdir /data/test' on the partition in question:
>  >  >
>  >  > in xfs_mkdir  (xfs_vnodeops.c):
>  >  >
>  >  >   error = xfs_dir_ialloc(&tp, dp, mode, 2,
>  >  >                         0, credp, prid, resblks > 0,
>  >  >                 &cdp, NULL);
>  >  >
>  >  >         if (error) {
>  >  >                 if (error == ENOSPC)
>  >  >                         goto error_return;   <=== this is hit and then
>  >  > execution jumps to error_return
>  >  >                 goto abort_return;
>  >  >         }
>  >
>  >  Ah - you can ignore my last email, then. You're already one step ahead
>  >  of me ;)
>  >
>  >  This does not appear to be the case I was expecting, though I can
>  >  see how we can get an ENOSPC here with plenty of blocks free - none
>  >  are large enough to allocate an inode chunk. What would be worth
>  >  knowing is the value of resblks when this error is reported.
>
>  Ok. I'll see if I can print it out.

Ok. I added printk statments to xfs_mkdir in xfs_vnodeops.c:

 'resblks=45' is the value returned by:

resblks = XFS_MKDIR_SPACE_RES(mp, dir_namelen);

and this is the value when the error_return label is called.

--

and inside xfs_dir_ialloc (file: xfs_utils.c) this is where it returns

       ...

       code = xfs_ialloc(tp, dp, mode, nlink, rdev, credp, prid, okalloc,
                          &ialloc_context, &call_again, &ip);

        /*
         * Return an error if we were unable to allocate a new inode.
         * This should only happen if we run out of space on disk or
         * encounter a disk error.
         */
        if (code) {
                *ipp = NULL;
                return code;
        }
        if (!call_again && (ip == NULL)) {
                *ipp = NULL;
                return XFS_ERROR(ENOSPC);   <============== returns here
        }



Christian
