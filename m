Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 17:18:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N0IP7R025267
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 17:18:27 -0700
Message-ID: <4886790C.7040100@sgi.com>
Date: Wed, 23 Jul 2008 10:19:24 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore over ssh?
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>	 <4884F2A5.5050507@sgi.com>	 <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>	 <48855B16.4050208@sgi.com>	 <1216708397.4499.57.camel@verge.scott.net.au>	 <48858676.3030105@sgi.com> <2d460de70807220351i7c468de5o33fa5aa5e9ddab99@mail.gmail.com>
In-Reply-To: <2d460de70807220351i7c468de5o33fa5aa5e9ddab99@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: Nathan Scott <nscott@aconex.com>, Bill Kendall <wkendall@sgi.com>, xfs@oss.sgi.com

Richard Hartmann wrote:
> On Tue, Jul 22, 2008 at 09:04, Timothy Shimmin <tes@sgi.com> wrote:
>> If you could strace it then we could see what call was failing> in path_to_fshandle().
> First with -ttt to get rid of a tty allocation error, then without:
> % cat root.xfs | ssh -ttt root@192.168.1.213 strace xfsrestore - /mnt/sda3

>From your output:
> open("/mnt/sda3", O_RDONLY|O_LARGEFILE) = 4
> ioctl(4, 0xc01c5868, 0xbfd4178c)        = -1 EINVAL (Invalid argument)
> close(4) 

(I probably should have just asked for:
 # strace -o output -e trace=open,ioctl xfsrestore ...)


> On Tue, Jul 22, 2008 at 12:49, Richard Hartmann
> <richih.mailinglist@gmail.com> wrote:
> 
>> > The Knoppix boot CD is am using to restore has 2.2.24-1, btw.
> 
> Grml to the rescue.. I downloaded a grml iso, which has 2.2.45-1,
> and was able to restore the image.
> 
> Extremely annoying, as I spent quite some time poking various
> options, thinking I had been doing something very basic very
> wrong. I assume the issue has been fixed between .24 and .45.
> 
> 
> Thanks again,
> Richard


Okay, my best guess is that you are trying to restore to a non-xfs
filesystem. This was fixed again in 2.2.26 so that it would work
on a non-xfs filesystem.
Otherwise the xfs ioctl will be being called and get back an EINVAL
as we saw in the strace.

Personally, I can't remember why we are bothering with handle code
in restore (in dump, yes, because of bulkstat but restore....
I vaguely remember a comment about optimitisation).



Looking at the code (annotated version) in restore:

wkendall  |1.34 |master-melb:xfs-cmds:187436a|  /* effectively initialize libhandle on this filesystem by
wkendall  |1.34 |master-melb:xfs-cmds:187436a|   * allocating a file system handle. this needs to be done
wkendall  |1.34 |master-melb:xfs-cmds:187436a|   * before any open_by_handle() calls (and possibly other
wkendall  |1.34 |master-melb:xfs-cmds:187436a|   * libhandle calls).
wkendall  |1.34 |master-melb:xfs-cmds:187436a|   */
wkendall  |1.34 |master-melb:xfs-cmds:187436a|  if ( persp->a.dstdirisxfspr ) {
wkendall  |1.34 |master-melb:xfs-cmds:187436a|          void    *fshanp;
wkendall  |1.34 |master-melb:xfs-cmds:187436a|          size_t  fshlen=0;
wkendall  |1.34 |master-melb:xfs-cmds:187436a|
wkendall  |1.34 |master-melb:xfs-cmds:187436a|          if(path_to_fshandle(persp->a.dstdir, &fshanp, &fshlen)) {
wkendall  |1.34 |master-melb:xfs-cmds:187436a|                  mlog( MLOG_NORMAL,
wkendall  |1.34 |master-melb:xfs-cmds:187436a|                          _("unable to construct a file "
wkendall  |1.34 |master-melb:xfs-cmds:187436a|                            "system handle for %s: %s\n"),
wkendall  |1.34 |master-melb:xfs-cmds:187436a|                          persp->a.dstdir,
wkendall  |1.34 |master-melb:xfs-cmds:187436a|                          strerror( errno ));
wkendall  |1.34 |master-melb:xfs-cmds:187436a|                  return BOOL_FALSE;
wkendall  |1.34 |master-melb:xfs-cmds:187436a|          }
wkendall  |1.34 |master-melb:xfs-cmds:187436a|          /* libhandle has it cached, release this copy */
wkendall  |1.34 |master-melb:xfs-cmds:187436a|          free_handle(fshanp, fshlen);
wkendall  |1.34 |master-melb:xfs-cmds:187436a|  }
wkendall  |1.34 |master-melb:xfs-cmds:187436a|

----------------------------
revision 1.34
date: 2005/02/10 02:14:17;  author: wkendall.bonnie.engr.sgi.com;  state: Exp;  lines: +34 -26
modid: master-melb:xfs-cmds:187436a
Fix a couple of spots in xfsrestore where XFS-specific calls were
being made without first checking to see if the filesystem being
restored is XFS.
Merge of master:xfs-cmds:187436a by kenmcd.
----------------------------

xfsdump-2.2.26 (09 February 2005)
        - Fix xfsrestore so that it can restore to non-XFS filesystems again.


--Tim
