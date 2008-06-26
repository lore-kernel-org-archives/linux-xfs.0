Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 01:24:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5Q8OpNG008355
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 01:24:52 -0700
Message-ID: <48635284.3060001@sgi.com>
Date: Thu, 26 Jun 2008 18:25:40 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] disable queue flag test in barrier check
References: <486307EA.7080007@sandeen.net>
In-Reply-To: <486307EA.7080007@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, jeremy@sgi.comwe

Eric Sandeen wrote:
> md raid1 can pass down barriers, but does not set an ordered flag 
> on the queue, so xfs does not even attempt a barrier write, and 
> will never use barriers on these block devices.
> 
> I propose removing the flag check and just let the barrier write
> test determine barrier support.
> 
> The risk here, I suppose, is that if something does not set an ordered
> flag and also does not properly return an error on a barrier write...
> but if it's any consolation jbd/ext3/reiserfs never test the flag, 
> and don't even do a test write, they just disable barriers the first 
> time an actual journal barrier write fails.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> Index: linux-2.6.25.1/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6.25.1.orig/fs/xfs/linux-2.6/xfs_super.c
> +++ linux-2.6.25.1/fs/xfs/linux-2.6/xfs_super.c
> @@ -733,14 +733,6 @@ xfs_mountfs_check_barriers(xfs_mount_t *
>  		return;
>  	}
>  
> -	if (mp->m_ddev_targp->bt_bdev->bd_disk->queue->ordered ==
> -					QUEUE_ORDERED_NONE) {
> -		xfs_fs_cmn_err(CE_NOTE, mp,
> -		  "Disabling barriers, not supported by the underlying device");
> -		mp->m_flags &= ~XFS_MOUNT_BARRIER;
> -		return;
> -	}
> -
>  	if (xfs_readonly_buftarg(mp->m_ddev_targp)) {
>  		xfs_fs_cmn_err(CE_NOTE, mp,
>  		  "Disabling barriers, underlying device is readonly");
> 
> 


Yeah, okay so we are revisiting this stuff again. Fair enough. (Groan;-)

So it was brought to our attention by Neil a while ago:

1.
> To: 	xfs@xxxxxxxxxxx
> Subject: 	XFS and write barriers.
> From: 	Neil Brown <neilb@xxxxxxx>
> Date: 	Fri, 23 Mar 2007 12:26:31 +1100
> 
> Hi,
>  I have two concerns related to XFS and write barrier support that I'm
>  hoping can be resolved.
> 
> Firstly in xfs_mountfs_check_barriers in fs/xfs/linux-2.6/xfs_super.c,
> it tests ....->queue->ordered to see if that is QUEUE_ORDERED_NONE.
> If it is, then barriers are disabled.
> 
> I think this is a layering violation - xfs really has no business
> looking that deeply into the device.
> For dm and md devices, ->ordered is never used and so never set, so
> xfs will never use barriers on those devices (as the default value is
> 0 or NONE).  It is true that md and dm could set ->ordered to some
> non-zero value just to please XFS, but that would be telling a lie and
> there is no possible value that is relevant to a layered devices.
> 
> I think this test should just be removed and the xfs_barrier_test
> should be the main mechanism for seeing if barriers work.

Looking back, we agreed at the time that this seemed reasonable.
(some mails from dgc and hch)

2.
> To: 	Neil Brown <neilb@xxxxxxx>
> Subject: 	Re: XFS and write barriers.
> From: 	David Chinner <dgc@xxxxxxx>
> Date: 	Fri, 23 Mar 2007 16:30:43 +1100
> Cc: 	xfs@xxxxxxxxxxx, hch@xxxxxxxxxxxxx
> 
> On Fri, Mar 23, 2007 at 12:26:31PM +1100, Neil Brown wrote:
>> 
>> Hi,
>>  I have two concerns related to XFS and write barrier support that I'm
>>  hoping can be resolved.
>> 
>> Firstly in xfs_mountfs_check_barriers in fs/xfs/linux-2.6/xfs_super.c,
>> it tests ....->queue->ordered to see if that is QUEUE_ORDERED_NONE.
>> If it is, then barriers are disabled.
>> 
>> I think this is a layering violation - xfs really has no business
>> looking that deeply into the device.
> 
> Except that the device behaviour determines what XFS needs to do
> and there used to be no other way to find out.
> 
> Christoph, any reason for needing this check anymore? I can't see
> any particular reason for needing to do this as __make_request()
> will check it for us when we test now.
> 
>> I think this test should just be removed and the xfs_barrier_test
>> should be the main mechanism for seeing if barriers work.
> 
> Yup.

3.
> To: 	David Chinner <dgc@xxxxxxx>
> Subject: 	Re: XFS and write barriers.
> From: 	Christoph Hellwig <hch@xxxxxxxxxxxxx>
> Date: 	Fri, 23 Mar 2007 09:50:55 +0000
> Cc: 	Neil Brown <neilb@xxxxxxx>, xfs@xxxxxxxxxxx, hch@xxxxxxxxxxxxx
> 
> On Fri, Mar 23, 2007 at 04:30:43PM +1100, David Chinner wrote:
>> On Fri, Mar 23, 2007 at 12:26:31PM +1100, Neil Brown wrote:
>> > 
>> > Hi,
>> >  I have two concerns related to XFS and write barrier support that I'm
>> >  hoping can be resolved.
>> > 
>> > Firstly in xfs_mountfs_check_barriers in fs/xfs/linux-2.6/xfs_super.c,
>> > it tests ....->queue->ordered to see if that is QUEUE_ORDERED_NONE.
>> > If it is, then barriers are disabled.
>> > 
>> > I think this is a layering violation - xfs really has no business
>> > looking that deeply into the device.
>> 
>> Except that the device behaviour determines what XFS needs to do
>> and there used to be no other way to find out.
>> 
>> Christoph, any reason for needing this check anymore? I can't see
>> any particular reason for needing to do this as __make_request()
>> will check it for us when we test now.
> 
> When I first implemented it I really dislike the idea of having request
> fail asynchrnously due to the lack of barriers.  Then someone (Jens?)
> told me we need to do this check anyway because devices might lie to
> us, at which point I implemented the test superblock writeback to
> check if it actually works.
> 
> So yes, we could probably get rid of the check now, although I'd
> prefer the block layer exporting an API to the filesystem to tell
> it whether there is any point in trying to use barriers.

4.
> review: handle barriers being switched off dynamically.
> 
>     * To: xfs-dev <xfs-dev@sgi.com>
>     * Subject: review: handle barriers being switched off dynamically.
>     * From: David Chinner <dgc@sgi.com>
>     * Date: Thu, 19 Apr 2007 17:37:14 +1000
>     * Cc: xfs-oss <xfs@oss.sgi.com>
> 
> As pointed out by Neil Brown, MD can switch barriers off
> dynamically underneath a mounted filesystem. If this happens
> to XFS, it will shutdown the filesystem immediately.
> 
> Handle this more sanely by yelling into the syslog, retrying
> the I/O without barriers and if that is successful, turn
> off barriers.
> 
> Also remove an unnecessary check when first checking to
> see if the underlying device supports barriers.
> 
> Cheers,
> 
> Dave.

Looking at our xfs ptools logs...

5.
> ----------------------------
> revision 1.402
> date: 2007/10/15 01:33:50;  author: tes;  state: Exp;  lines: +8 -0
> modid: xfs-linux-melb:xfs-kern:29882a
> Put back the QUEUE_ORDERED_NONE test in the barrier check.
> 
> Put back the QUEUE_ORDERED_NONE test which caused us grief in sles when it was taken out
> as, IIRC, it allowed md/lvm to be thought of as supporting barriers when they weren't
> in some configurations.
> This patch will be reverting what went in as part of a change for
> the SGI-pv 964544 (SGI-Modid: xfs-linux-melb:xfs-kern:28568a).
> Put back the QUEUE_ORDERED_NONE test in the barrier check.
> ----------------------------
> ----------------------------
> revision 1.380
> date: 2007/05/11 05:35:19;  author: dgc;  state: Exp;  lines: +0 -8
> modid: xfs-linux-melb:xfs-kern:28568a
> Barriers need to be dynamically checked and switched off
> 
> If the underlying block device sudden stops supporting barriers,
> we need to handle the -EOPNOTSUPP error in a sane manner rather
> than shutting downteh filesystem. If we get this error, clear the
> barrier flag, reissue the I/O, and tell the world bad things are
> occurring.
> We shouldn't peer down into the backing device to see if barriers
> are supported or not - the test I/O is sufficient to tell us
> this.
> ----------------------------

Also from memory, I believe Neil checked this removal into the SLES10sp1 tree
and some sgi boxes started having slow downs
(looking at Dave's email below - we were not wanting to tell them
to use nobarrier but needed it to work by default - I forget now).

6.
> Date: Wed, 25 Jun 2008 08:57:24 +1000
> From: Dave Chinner <david@fromorbit.com>
> To: Eric Sandeen <sandeen@sandeen.net>
> Cc: LinuxRaid <linux-raid@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
> Subject: Re: md raid1 passes barriers, but xfs doesn't use them?
>
> Yeah, the problem was that last time this check was removed was
> that a bunch of existing hardware had barriers enabled on them when
> not necessary (e.g. had NVRAM) and they went 5x slower on MD raid1
> devices. Having to change the root drive config on a wide install
> base was considered much more of support pain than leaving the
> check there. I guess that was more of a distro upgrade issue than
> a mainline problem, but that's the history. Hence I think we
> should probably do whatever everyone else is doing here....
> 
> Cheers,
> 
> Dave.

So I guess my question is whether there are cases where we are
going to be in trouble again.
Jeremy, do you see some problems?

--Tim
