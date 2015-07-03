Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFB0F7F9E
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 08:24:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F75A30404E
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 06:24:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b4FA4Kh7tuKxyPMi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 06:24:40 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 31E523679F6
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 13:24:40 +0000 (UTC)
Date: Fri, 3 Jul 2015 09:24:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/17] mkfs: Sanitise the superblock feature macros
Message-ID: <20150703132438.GB23023@bfoster.bfoster>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-4-git-send-email-jtulak@redhat.com>
	<20150625193807.GG36162@bfoster.bfoster>
	<118220992.23297038.1435917207418.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <118220992.23297038.1435917207418.JavaMail.zimbra@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Fri, Jul 03, 2015 at 05:53:27AM -0400, Jan Tulak wrote:
> 
> 
> ----- Original Message -----
> > From: "Brian Foster" <bfoster@redhat.com>
> > > @@ -1912,17 +2013,17 @@ _("32 bit Project IDs always enabled on CRC enabled
> > > filesytems\n"));
> > >  		 * tried to use crc=0,finobt=1, then issue a warning before
> > >  		 * turning them off.
> > >  		 */
> > > -		if (finobt && finobtflag) {
> > > +		if (sb_feat.finobt && sb_feat.finobtflag) {
> > 
> > Since the code above drops finobtflag, I don't think we'll ever hit
> > this. Indeed, I can now create a crc=0,finobt=1 fs, which shouldn't
> > happen.
> > 
> > Brian
> > 
> 
> Finobtflag is dropped by a later patch in the set entirely. After all patches, the line is:
> 
> 	if (sb_feat.finobt && mopts.subopt_params[M_FINOBT].seen)
> 
> Which indeed works as it should:
> 
> mkfs.xfs -f -m crc=0,finobt=1 /dev/vdb2
> warning: finobt not supported without CRC support, disabled.
> 

Ok, fair enough. That said, I'm not a huge fan of letting broken patches
through just because things are fixed up in a subsequent patch. For one,
it makes review difficult and kind of removes incentive to review
individual patches rather than just the end result. In general, that's
problematic for things like future bisects or if you consider a
subsequent patch might be reverted down the line after all this context
is lost, re-exposing a previously known problem.

This particular instance is not a big deal. It requires the user to do
something wrong and we wouldn't mount the fs anyways. I'm just pointing
this out because IIRC there were a couple of instances of this "break in
one patch, fix in another" pattern in this series. In most cases, the
right thing to do is fix up the broken patch. ;)

Brian

> Cheers,
> Jan
> 
> -- 
> Jan Tulak
> jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
