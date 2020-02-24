Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83213C11D24
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 06:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AB4D20714
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 06:05:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EbIEilon"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgBXGFM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 01:05:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46959 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725895AbgBXGFL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 01:05:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582524310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A5DeCLyZwYcYI+ZND6rQ2PbNA/rtHvaLpEhHCf9IVzA=;
        b=EbIEilonwuroDMFdQjgeTycVHcQNX3nUEuFfTyiD8CjXcJp4gmBwhMnmWezrqYNqvkj042
        wB6f6GxIsSO3ujELJtMU7aW3Mz4mdVSHUTuHoakpUL/Ikpkv4WgGTjLd6+7SXWa5X+OvVy
        a3PEmJJg6qGJGrycN7qN984M+/9DcZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-jYu1acz_M9yHjS-S-T2ixg-1; Mon, 24 Feb 2020 01:05:06 -0500
X-MC-Unique: jYu1acz_M9yHjS-S-T2ixg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A8A2800D55;
        Mon, 24 Feb 2020 06:05:05 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2BBA5C557;
        Mon, 24 Feb 2020 06:05:04 +0000 (UTC)
Date:   Mon, 24 Feb 2020 14:15:35 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 1/3] dax/dm: disable testing on devices that don't
 support dax
Message-ID: <20200224061535.GO14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
References: <20200220200632.14075-1-jmoyer@redhat.com>
 <20200220200632.14075-2-jmoyer@redhat.com>
 <20200221094801.GJ14282@dhcp-12-102.nay.redhat.com>
 <20200223150056.GG3840@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223150056.GG3840@desktop>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 11:07:15PM +0800, Eryu Guan wrote:
> On Fri, Feb 21, 2020 at 05:48:01PM +0800, Zorro Lang wrote:
> > On Thu, Feb 20, 2020 at 03:06:30PM -0500, Jeff Moyer wrote:
> > > Move the check for dax from the individual target scripts into
> > > _require_dm_target.  This fixes up a couple of missed tests that are
> > > failing due to the lack of dax support (such as tests requiring
> > > dm-snapshot).
> > > 
> > > Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> > > ---
> > >  common/dmdelay  |  5 -----
> > >  common/dmerror  |  5 -----
> > >  common/dmflakey |  5 -----
> > >  common/dmthin   |  5 -----
> > >  common/rc       | 11 +++++++++++
> > >  5 files changed, 11 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/common/dmdelay b/common/dmdelay
> > > index f1e725b9..66cac1a7 100644
> > > --- a/common/dmdelay
> > > +++ b/common/dmdelay
> > > @@ -7,11 +7,6 @@
> > >  DELAY_NONE=0
> > >  DELAY_READ=1
> > >  
> > > -echo $MOUNT_OPTIONS | grep -q dax
> > > -if [ $? -eq 0 ]; then
> > > -	_notrun "Cannot run tests with DAX on dmdelay devices"
> > > -fi
> > > -
> > >  _init_delay()
> > >  {
> > >  	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> > > diff --git a/common/dmerror b/common/dmerror
> > > index 426f1e96..7d12e0a1 100644
> > > --- a/common/dmerror
> > > +++ b/common/dmerror
> > > @@ -4,11 +4,6 @@
> > >  #
> > >  # common functions for setting up and tearing down a dmerror device
> > >  
> > > -echo $MOUNT_OPTIONS | grep -q dax
> > > -if [ $? -eq 0 ]; then
> > > -	_notrun "Cannot run tests with DAX on dmerror devices"
> > > -fi
> > > -
> > >  _dmerror_setup()
> > >  {
> > >  	local dm_backing_dev=$SCRATCH_DEV
> > > diff --git a/common/dmflakey b/common/dmflakey
> > > index 2af3924d..b4e11ae9 100644
> > > --- a/common/dmflakey
> > > +++ b/common/dmflakey
> > > @@ -8,11 +8,6 @@ FLAKEY_ALLOW_WRITES=0
> > >  FLAKEY_DROP_WRITES=1
> > >  FLAKEY_ERROR_WRITES=2
> > >  
> > > -echo $MOUNT_OPTIONS | grep -q dax
> > > -if [ $? -eq 0 ]; then
> > > -	_notrun "Cannot run tests with DAX on dmflakey devices"
> > > -fi
> > > -
> > >  _init_flakey()
> > >  {
> > >  	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> > > diff --git a/common/dmthin b/common/dmthin
> > > index 7946e9a7..61dd6f89 100644
> > > --- a/common/dmthin
> > > +++ b/common/dmthin
> > > @@ -21,11 +21,6 @@ DMTHIN_POOL_DEV="/dev/mapper/$DMTHIN_POOL_NAME"
> > >  DMTHIN_VOL_NAME="thin-vol"
> > >  DMTHIN_VOL_DEV="/dev/mapper/$DMTHIN_VOL_NAME"
> > >  
> > > -echo $MOUNT_OPTIONS | grep -q dax
> > > -if [ $? -eq 0 ]; then
> > > -	_notrun "Cannot run tests with DAX on dmthin devices"
> > > -fi
> > > -
> > >  _dmthin_cleanup()
> > >  {
> > >  	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
> > > diff --git a/common/rc b/common/rc
> > > index eeac1355..65cde32b 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -1874,6 +1874,17 @@ _require_dm_target()
> > >  	_require_sane_bdev_flush $SCRATCH_DEV
> > >  	_require_command "$DMSETUP_PROG" dmsetup
> > >  
> > > +	echo $MOUNT_OPTIONS | grep -q dax
> > > +	if [ $? -eq 0 ]; then
> > > +		case $target in
> > > +		stripe|linear|log-writes)
> > 
> > I've checked all cases which import ./common/dm.* (without dmapi), they all
> > has _require_dm_target. So this patch is good to me.
> 
> So can I add "Reviewed-by: Zorro Lang <zlang@redhat.com>" to all these
> three patches? :)

Sure, my pleasure :)

> 
> Thanks for the review!
> 
> Eryu
> > 
> > And by checking current linux source code:
> > 
> >   0 dm-linear.c      226 .direct_access = linear_dax_direct_access,
> >   1 dm-log-writes.c 1016 .direct_access = log_writes_dax_direct_access,
> >   2 dm-stripe.c      486 .direct_access = stripe_dax_direct_access,
> >   3 dm-target.c      159 .direct_access = io_err_dax_direct_access,
> > 
> > Only linear, stripe and log-writes support direct_access.
> > 
> > Thanks,
> > Zorro
> > 
> > > +			;;
> > > +		*)
> > > +			_notrun "Cannot run tests with DAX on $target devices."
> > > +			;;
> > > +		esac
> > > +	fi
> > > +
> > >  	modprobe dm-$target >/dev/null 2>&1
> > >  
> > >  	$DMSETUP_PROG targets 2>&1 | grep -q ^$target
> > > -- 
> > > 2.19.1
> > > 
> > 
> 

