Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S6kx1h195509 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 01:46:59 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aH5p0IvJBEbfhgID for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 23:48:18 -0700 (PDT)
Date: Fri, 28 Sep 2012 16:47:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair deleting realtime files.
Message-ID: <20120928064742.GE25626@dastard>
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net> <20120924075551.GF20960@dastard>
	<CAHt31_8rEc93vpnbbKngY4uS0kAct3Z5A+2G0LmBzv5rWKdSfA@mail.gmail.com>
	<CAHt31__s2TNhXPa9JfDLdWPqr60Te9VDPKb4ieORF8JAL07YmQ@mail.gmail.com>
	<20120926024403.GH29154@dastard>
	<CAHt31__FPLsDdVCVwwLO0Sh9v_KK2pzU577nywFPAmf_C-gRcQ@mail.gmail.com>
	<20120926061732.GI29154@dastard>
	<CAHt31__59_XJw9EF7MniiYH5sS6CX44q9gGwxiqxx43k5OFZ4A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHt31__59_XJw9EF7MniiYH5sS6CX44q9gGwxiqxx43k5OFZ4A@mail.gmail.com>
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
To: Anand Tiwari <tiwarikanand@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Sep 27, 2012 at 07:27:16PM -0600, Anand Tiwari wrote:
> On Wed, Sep 26, 2012 at 12:17 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Tue, Sep 25, 2012 at 09:45:07PM -0600, Anand Tiwari wrote:
> > > thanks Dave for prompt reply, I meant to implement option 2 as you
> > > explained (option 3).  I will start working on it tomorrow. In the mean
> > > time, I also had  to put something in xfs_repair for the files which
> > > already exists on the disk. Would you guys willing to review/comment on
> > > that ?
> >
> > Sure.
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> >
> 
> following are my changes for xfs_repair. my goal  is to keep changes
> minimum as they may not included in upstream. I had to do these changes as
> we already have files with extent map not properly aligned.
> As we know, this happens only when we are growing a file in a realtime
> volume. by keeping this in mind, I am checking if start of a record in
> extent map is not aligned, check previous record and if they are
> contiguous, we can skip that part of record.
> 
> let me know if you any issues with this or if someone has better approach.
> I would like to use pointers for prev and irec but again, I wanted to keep
> changes minimum
> 
> thanks
> anand
> 
> 
> XFS currently can have records in extent map, which starts from unaligned
> block w.r.t rextsize.
> 
> --------------------------------------
> 
> xfs_repair considers this as a bug (multiple claims for a one real time
> extent) and deletes the file.
> This patch addresses the issue, by comparing current and previous records
> and make sure they are
> contiguous and not overlapped.
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 5a2da39..5537f1c 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -406,6 +406,7 @@ verify_agbno(xfs_mount_t *mp,
>  static int
>  process_rt_rec(
>   xfs_mount_t *mp,
> + xfs_bmbt_irec_t *prev,
>   xfs_bmbt_irec_t *irec,
>   xfs_ino_t ino,
>   xfs_drfsbno_t *tot,

Your mailer has removed all the whitespace from the patch. The files
Documentation/SubmittingPatches and Documentation/email-clients.txt
for help with how to send patches sanely via email. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
