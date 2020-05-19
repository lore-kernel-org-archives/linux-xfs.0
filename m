Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030B2C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 21:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8B522072C
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 21:34:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BtURdyFl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgESVeQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 17:34:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53504 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESVeP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 17:34:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLXCdR064714;
        Tue, 19 May 2020 21:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LnqYhEiD/S5zU/SEgZZ551RxtXJyDJUYlqz/AwptqFI=;
 b=BtURdyFlKA0wz9Shg0Fhvq+RrTc1UoIWD6DRpc18HWPpueU/jnt570ZvoUAbuyzNrXSP
 sMwUbV37MLGKiBCy4XhUKQV+4/IIW8fCGIXZGZ5m02FjZVrdHRJ3j27LNWosuxeb0x/j
 jDEuJUUIrBf3ANEklQ4eRxHyUlSuUvqU9HzdIGd9o1EGaKgbAZYk9bdPqNQ01C4E4GeT
 pq+Pd9fdZbrg/m4yo0SK6VSlyO+Zuv74mnUNllH3Rd3c+Q8KseeziI/uNRU1QPOl5h5B
 XoFRykl1jnUd7rUa9yFLRepnuWZgaKXnVpAEqtUu3P98IvtGEXAk6TSA+L3Ox8fy9Rfm GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127kr7y7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 21:34:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLX8HZ126155;
        Tue, 19 May 2020 21:34:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 312sxtkhf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 21:34:10 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04JLYAae012984;
        Tue, 19 May 2020 21:34:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 14:34:09 -0700
Date:   Tue, 19 May 2020 14:34:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/1 V2] xfs_quota: allow individual timer extension
Message-ID: <20200519213409.GS17627@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <b75aef11-0e7a-7b2d-f6f0-d36af80d5e27@redhat.com>
 <fb0b46ab-98a1-4427-fa5e-4a770c9d0805@redhat.com>
 <37e9d7d7-d783-69a1-f44f-dfcc4baeb773@redhat.com>
 <20200519163810.GP17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519163810.GP17627@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=2 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=2 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 09:38:10AM -0700, Darrick J. Wong wrote:
> On Mon, May 18, 2020 at 03:09:30PM -0500, Eric Sandeen wrote:
> > The only grace period which can be set via xfs_quota today is for id 0,
> > i.e. the default grace period for all users.  However, setting an
> > individual grace period is useful; for example:
> > 
> >  Alice has a soft quota of 100 inodes, and a hard quota of 200 inodes
> >  Alice uses 150 inodes, and enters a short grace period
> >  Alice really needs to use those 150 inodes past the grace period
> >  The administrator extends Alice's grace period until next Monday
> > 
> > vfs quota users such as ext4 can do this today, with setquota -T
> > 
> > xfs_quota can now accept an optional user id or name (symmetric with
> > how warn limits are specified), in which case that user's grace period
> > is extended to expire the given amount of time from now(). 
> > 
> > To maintain compatibility with old command lines, if none of 
> > [-d|id|name] are specified, default limits are set as before.
> > 
> > (kernelspace requires updates to enable all this as well.)
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > V2: Add comments about only extending if past soft limits
> >     Fix typo/mistake checking block hard limits instead of soft
> > 
> > diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> > index e6fe7cd1..dd0479cd 100644
> > --- a/man/man8/xfs_quota.8
> > +++ b/man/man8/xfs_quota.8
> > @@ -457,14 +457,46 @@ must be specified.
> >  .B \-bir
> >  ]
> >  .I value
> > +[
> > +.B -d
> > +|
> > +.I id
> > +|
> > +.I name
> > +]
> >  .br
> >  Allows the quota enforcement timeout (i.e. the amount of time allowed
> >  to pass before the soft limits are enforced as the hard limits) to
> >  be modified. The current timeout setting can be displayed using the
> >  .B state
> > -command. The value argument is a number of seconds, but units of
> > -\&'minutes', 'hours', 'days', and 'weeks' are also understood
> > +command.
> > +.br
> > +When setting the default timer via the
> > +.B \-d
> > +option, or for
> > +.B id
> > +0, or if no argument is given after
> > +.I value
> > +the
> > +.I value
> > +argument is a number of seconds indicating the relative amount of time after
> > +soft limits are exceeded, before hard limits are enforced.
> > +.br
> > +When setting any other individual timer by
> > +.I id
> > +or
> > +.I name,
> > +the
> > +.I value
> > +is the number of seconds from now, at which time the hard limits will be enforced.
> > +This allows extending the grace time of an individual user who has exceeded soft
> > +limits.
> > +.br
> > +For
> > +.I value,
> > +units of \&'minutes', 'hours', 'days', and 'weeks' are also understood
> >  (as are their abbreviations 'm', 'h', 'd', and 'w').
> > +.br
> >  .HP
> >  .B warn
> >  [
> > diff --git a/quota/edit.c b/quota/edit.c
> > index 442b608c..5fdb8ce7 100644
> > --- a/quota/edit.c
> > +++ b/quota/edit.c
> > @@ -419,6 +419,7 @@ restore_f(
> >  
> >  static void
> >  set_timer(
> > +	uint32_t	id,
> >  	uint		type,
> >  	uint		mask,
> >  	char		*dev,
> > @@ -427,14 +428,43 @@ set_timer(
> >  	fs_disk_quota_t	d;
> >  
> >  	memset(&d, 0, sizeof(d));
> > +
> > +	/*
> > +	 * If id is specified we are extending grace time by value
> > +	 * Otherwise we are setting the default grace time
> > +	 */
> > +	if (id) {
> > +		time_t	now;
> > +
> > +		/* Get quota to find out whether user is past soft limits */
> > +		if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
> > +			exitcode = 1;
> > +			fprintf(stderr, _("%s: cannot get quota: %s\n"),
> > +					progname, strerror(errno));
> > +				return;
> > +		}
> > +
> > +		time(&now);
> > +
> > +		/* Only set grace time if user is already past soft limit */
> > +		if (d.d_blk_softlimit && d.d_bcount > d.d_blk_softlimit)
> > +			d.d_btimer = now + value;
> > +		if (d.d_ino_softlimit && d.d_icount > d.d_ino_softlimit)
> > +			d.d_itimer = now + value;
> > +		if (d.d_rtb_softlimit && d.d_rtbcount > d.d_rtb_softlimit)
> > +			d.d_rtbtimer = now + value;
> 
> Hmm, I /was/ going to complain about 32-bit wraparound, but then
> realized that the whole ioctl interface is totally __s32 and needs
> y2038 updates and meh.
> 
> Someone looking for a project could work on either fixing the xfs quota
> ioctls, or the vfs quota ioctls, or both, assuming Arnd didn't already
> fix the VFS...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

...hmm, wait, so an old kernel won't /do/ anything, right?  It won't
error out, but the grace period for that non-root user won't have been
changed.  Perhaps this ought to re-check the grace period values
afterwards to assess efficacy.

--D

> --D
> 
> > +	} else {
> > +		d.d_btimer = value;
> > +		d.d_itimer = value;
> > +		d.d_rtbtimer = value;
> > +	}
> > +
> >  	d.d_version = FS_DQUOT_VERSION;
> >  	d.d_flags = type;
> >  	d.d_fieldmask = mask;
> > -	d.d_itimer = value;
> > -	d.d_btimer = value;
> > -	d.d_rtbtimer = value;
> > +	d.d_id = id;
> >  
> > -	if (xfsquotactl(XFS_SETQLIM, dev, type, 0, (void *)&d) < 0) {
> > +	if (xfsquotactl(XFS_SETQLIM, dev, type, id, (void *)&d) < 0) {
> >  		exitcode = 1;
> >  		fprintf(stderr, _("%s: cannot set timer: %s\n"),
> >  				progname, strerror(errno));
> > @@ -447,10 +477,15 @@ timer_f(
> >  	char		**argv)
> >  {
> >  	uint		value;
> > -	int		c, type = 0, mask = 0;
> > +	char		*name = NULL;
> > +	uint32_t	id = 0;
> > +	int		c, flags = 0, type = 0, mask = 0;
> >  
> > -	while ((c = getopt(argc, argv, "bgipru")) != EOF) {
> > +	while ((c = getopt(argc, argv, "bdgipru")) != EOF) {
> >  		switch (c) {
> > +		case 'd':
> > +			flags |= DEFAULTS_FLAG;
> > +			break;
> >  		case 'b':
> >  			mask |= FS_DQ_BTIMER;
> >  			break;
> > @@ -474,23 +509,45 @@ timer_f(
> >  		}
> >  	}
> >  
> > -	if (argc != optind + 1)
> > +	 /*
> > +	 * Older versions of the command did not accept -d|id|name,
> > +	 * so in that case we assume we're setting default timer,
> > +	 * and the last arg is the timer value.
> > +	 *
> > +	 * Otherwise, if the defaults flag is set, we expect 1 more arg for
> > +	 * timer value ; if not, 2 more args: 1 for value, one for id/name.
> > +	 */
> > +	if (!(flags & DEFAULTS_FLAG) && (argc == optind + 1)) {
> > +		value = cvttime(argv[optind++]);
> > +	} else if (flags & DEFAULTS_FLAG) {
> > +		if (argc != optind + 1)
> > +			return command_usage(&timer_cmd);
> > +		value = cvttime(argv[optind++]);
> > +	} else if (argc == optind + 2) {
> > +		value = cvttime(argv[optind++]);
> > +		name = (flags & DEFAULTS_FLAG) ? "0" : argv[optind++];
> > +	} else
> >  		return command_usage(&timer_cmd);
> >  
> > -	value = cvttime(argv[optind++]);
> >  
> > +	/* if none of -bir specified, set them all */
> >  	if (!mask)
> >  		mask = FS_DQ_TIMER_MASK;
> >  
> >  	if (!type) {
> >  		type = XFS_USER_QUOTA;
> >  	} else if (type != XFS_GROUP_QUOTA &&
> > -	           type != XFS_PROJ_QUOTA &&
> > -	           type != XFS_USER_QUOTA) {
> > +		   type != XFS_PROJ_QUOTA &&
> > +		   type != XFS_USER_QUOTA) {
> >  		return command_usage(&timer_cmd);
> >  	}
> >  
> > -	set_timer(type, mask, fs_path->fs_name, value);
> > +	if (name)
> > +		id = id_from_string(name, type);
> > +
> > +	if (id >= 0)
> > +		set_timer(id, type, mask, fs_path->fs_name, value);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -616,9 +673,9 @@ edit_init(void)
> >  
> >  	timer_cmd.name = "timer";
> >  	timer_cmd.cfunc = timer_f;
> > -	timer_cmd.argmin = 2;
> > +	timer_cmd.argmin = 1;
> >  	timer_cmd.argmax = -1;
> > -	timer_cmd.args = _("[-bir] [-g|-p|-u] value");
> > +	timer_cmd.args = _("[-bir] [-g|-p|-u] value [-d|id|name]");
> >  	timer_cmd.oneline = _("set quota enforcement timeouts");
> >  	timer_cmd.help = timer_help;
> >  	timer_cmd.flags = CMD_FLAG_FOREIGN_OK;
> > 
