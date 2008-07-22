Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 00:03:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6M73LOs001393
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 00:03:23 -0700
Message-ID: <48858676.3030105@sgi.com>
Date: Tue, 22 Jul 2008 17:04:22 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore over ssh?
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>	 <4884F2A5.5050507@sgi.com>	 <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>	 <48855B16.4050208@sgi.com> <1216708397.4499.57.camel@verge.scott.net.au>
In-Reply-To: <1216708397.4499.57.camel@verge.scott.net.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>, Bill Kendall <wkendall@sgi.com>, xfs@oss.sgi.com

Nathan Scott wrote:
> On Tue, 2008-07-22 at 13:59 +1000, Timothy Shimmin wrote:
>> Richard Hartmann wrote:
>>> On Mon, Jul 21, 2008 at 22:33, Bill Kendall <wkendall@sgi.com wrote:
>> xfsrestore: unable to construct a file system handle for /mnt/sda3:
>>> Das Argument ist ung�ltig
>>> xfsrestore: Restore Status: ERROR
> 
> "unable to construct a file system handle" - theres only one place
> in the restore code that can come from - the path_to_fshandle call.
> Is there a 32 bit userspace and 64 bit kernel on the machine where
> xfsrestore is running?
> 
> Its not clear to me what that code in xfsrestore is trying to do,
> you may be able to just comment it out...?!?
> 
> cheers.
> 
> --
> Nathan
> 

Oh yeah from this code:
>         /* effectively initialize libhandle on this filesystem by
>          * allocating a file system handle. this needs to be done
>          * before any open_by_handle() calls (and possibly other
>          * libhandle calls).
>          */
>         if ( persp->a.dstdirisxfspr ) {
>                 void    *fshanp;
>                 size_t  fshlen=0;
> 
>                 if(path_to_fshandle(persp->a.dstdir, &fshanp, &fshlen)) {
>                         mlog( MLOG_NORMAL,
>                                 _("unable to construct a file "
>                                   "system handle for %s: %s\n"),
>                                 persp->a.dstdir,
>                                 strerror( errno ));

IIRC, I think it wants an fd to use for the filesystem in
handle ioctl calls. It caches it against the fsid in the handle.

I don't think commenting out will work as it will stop the handle
calls from working.

If you could strace it then we could see what call was failing
in path_to_fshandle().

path_to_fshandle...
>         fd = open(path, O_RDONLY);
>         if (fd < 0)
>                 return -1;
>         
>         obj.path = path;
>         result = obj_to_handle(path, fd, XFS_IOC_PATH_TO_FSHANDLE,
>                                 obj, fshanp, fshlen);
>         if (result < 0) {
>                 close(fd);
>                 return result;

So I guess either open failed or obj_to_handle failed.

obj_to_handle...
>                 hreq.path    = obj.path;
>         }
> 
>         hreq.oflags   = O_LARGEFILE;
>         hreq.ihandle  = NULL;
>         hreq.ihandlen = 0;
>         hreq.ohandle  = hbuf;
>         hreq.ohandlen = &handlen;
> 
>         ret = xfsctl(fspath, fsfd, opcode, &hreq);
>         if (ret)
>                 return ret;

--Tim
