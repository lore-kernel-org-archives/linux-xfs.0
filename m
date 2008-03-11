Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 05:21:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2BCKgDN010466
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 05:20:46 -0700
Date: Tue, 11 Mar 2008 23:21:03 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
Message-ID: <20080311122103.GP155407@sgi.com>
References: <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com> <1a4a774c0803060310w2642224w690ac8fa13f96ec@mail.gmail.com> <1a4a774c0803070319j1eb8790ek3daae4a16b3e6256@mail.gmail.com> <20080310000809.GU155407@sgi.com> <1a4a774c0803100302y17530814wee7522aa0dfd7668@mail.gmail.com> <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com> <20080310222135.GZ155407@sgi.com> <1a4a774c0803110108u3f01813fs7f9540f886be055@mail.gmail.com> <20080311093406.GN155407@sgi.com> <1a4a774c0803110419n645da456leaedd98593300726@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a4a774c0803110419n645da456leaedd98593300726@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian =?iso-8859-1?Q?R=F8snes?= <christian.rosnes@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 11, 2008 at 12:19:29PM +0100, Christian Røsnes wrote:
> On Tue, Mar 11, 2008 at 10:34 AM, David Chinner <dgc@sgi.com> wrote:
> >
> > On Tue, Mar 11, 2008 at 09:08:31AM +0100, Christian Røsnes wrote:
> 
> >  > I'll try to add some printk statements to the codepaths you mentioned,
> >  > and see where it leads.
> >
> >  Definitely worth confirming this is where the error is coming from.
> >
> 
> 	if (tagno == agno) {
> 			printk("XFS: xfs_dialloc:0021\n");
> 			*inop = NULLFSINO;
> 			return noroom ? ENOSPC : 0;
> 		}
> 
> seems to be what triggers this inside xfs_dialloc.
> 
> Here a trace which give some indication to the codepath taken inside
> xfs_dialloc (xfs_ialloc.c):

Yup, that's trying to allocate in each AG and failing. Almost certainly
the problem is the described alignment issue.

FYI, I'm travelling tomorrow so I won't really get a chance to look
at this more until thursday....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
