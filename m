Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O0gB2x246487 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 19:42:11 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81AE2191BA09
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 17:42:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UioQxku9hH1qWS66 for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 17:42:09 -0700 (PDT)
Date: Wed, 24 Aug 2011 10:42:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] XFS update for 3.1-rc4
Message-ID: <20110824004206.GG3162@dastard>
References: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
	<CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

On Tue, Aug 23, 2011 at 11:46:30AM -0700, Linus Torvalds wrote:
> On Tue, Aug 23, 2011 at 10:39 AM, Alex Elder <aelder@sgi.com> wrote:
> >
> > Linus, please pull the following XFS changes. =A0Their effect is to
> > remove the subdirectory structure from the XFS source hierarchy.
> > There are no functional changes to the XFS code itself. =A0Thanks.
> =

> Pulled.
> =

> Any plans to further sanitize the namespace?
> =

> It's kind of crazy to have filenames like
> =

>    fs/xfs/xfs_trace.c
> =

> which just duplicate the "xfs" part for no good reason.

I consider the context it adds to cscope searches a damn good reason
for keeping it.

> Why not just
> do something like
> =

>   for i in xfs_*; do j=3D$(echo $i | sed 's/^xfs_//'); git mv $i $j; done
> =

> to get rid of the silly "xfs_" prefix that adds nothing?

Because that then kills context that is actually useful in cscope
searches. That is, every filesystem has the file "inode.c",
"super.c", etc and so you can't tell from the cscope searchs which
filesystem function calls belong to. =


Duplicate name spaces are evil, and we have a lot of them in the
filesystem tree - if they all had explicit namespacing like XFS
does, then the world would be a better place. ;)


> You could use the bytes you save to rename "qm.c" to "quota_manager.c"
> instead. Wouldn't it be nice to have *good* names, instead of a jumble
> of crazy and mostly redundant letters?

The names make sense to anyone who has spent any time in the XFS
code. The name of the file reflects the namespace of the code inside
the file itself. e.g. to use the xfs_qm.c as an example:

$ grep ^xfs_qm_  fs/xfs/xfs_qm.c
xfs_qm_destroy(
xfs_qm_hold_quotafs_ref(
xfs_qm_rele_quotafs_ref(
xfs_qm_unmount(
xfs_qm_mount_quotas(
xfs_qm_unmount_quotas(
xfs_qm_dqflush_all(
xfs_qm_detach_gdquots(
xfs_qm_dqpurge_int(
xfs_qm_dqpurge_all(
xfs_qm_dqattach_one(
xfs_qm_dqattach_grouphint(
xfs_qm_dqattach_locked(
xfs_qm_dqattach(
xfs_qm_dqdetach(
xfs_qm_sync(
xfs_qm_init_quotainfo(
xfs_qm_destroy_quotainfo(
xfs_qm_list_init(
xfs_qm_list_destroy(
xfs_qm_qino_alloc(
xfs_qm_reset_dqcounts(
xfs_qm_dqiter_bufs(
xfs_qm_dqiterate(
xfs_qm_quotacheck_dqadjust(
xfs_qm_get_rtblks(
xfs_qm_dqusage_adjust(
xfs_qm_quotacheck(
xfs_qm_init_quotainos(
xfs_qm_dqreclaim_one(void)
xfs_qm_shake_freelist(
xfs_qm_shake_scan(
xfs_qm_shake_count(
xfs_qm_dqalloc_incore(
xfs_qm_write_sb_changes(
xfs_qm_vop_dqalloc(
xfs_qm_vop_chown(
xfs_qm_vop_chown_reserve(
xfs_qm_vop_rename_dqattach(
xfs_qm_vop_create_dqattach(

So there is a certain methodic sanity to the naming convention that
is not immediately obvious from just looking at the file names, and
that's a good reason not to change them.

Besides, I don't want to have to spend 3 months reprogramming
my muscle memory just because we painted the bikeshed a different
colour. ;)

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
