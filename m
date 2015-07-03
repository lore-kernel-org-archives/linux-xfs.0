Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 488BA7F7E
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 04:53:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C93B7AC008
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 02:53:30 -0700 (PDT)
Received: from mx5-phx2.redhat.com (mx5-phx2.redhat.com [209.132.183.37]) by
	cuda.sgi.com with ESMTP id 704f1Yb7keNdE5SE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 02:53:28 -0700 (PDT)
Date: Fri, 3 Jul 2015 05:53:27 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <118220992.23297038.1435917207418.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150625193807.GG36162@bfoster.bfoster>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-4-git-send-email-jtulak@redhat.com>
	<20150625193807.GG36162@bfoster.bfoster>
Subject: Re: [PATCH 03/17] mkfs: Sanitise the superblock feature macros
MIME-Version: 1.0
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>



----- Original Message -----
> From: "Brian Foster" <bfoster@redhat.com>
> > @@ -1912,17 +2013,17 @@ _("32 bit Project IDs always enabled on CRC enabled
> > filesytems\n"));
> >  		 * tried to use crc=0,finobt=1, then issue a warning before
> >  		 * turning them off.
> >  		 */
> > -		if (finobt && finobtflag) {
> > +		if (sb_feat.finobt && sb_feat.finobtflag) {
> 
> Since the code above drops finobtflag, I don't think we'll ever hit
> this. Indeed, I can now create a crc=0,finobt=1 fs, which shouldn't
> happen.
> 
> Brian
> 

Finobtflag is dropped by a later patch in the set entirely. After all patches, the line is:

	if (sb_feat.finobt && mopts.subopt_params[M_FINOBT].seen)

Which indeed works as it should:

mkfs.xfs -f -m crc=0,finobt=1 /dev/vdb2
warning: finobt not supported without CRC support, disabled.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
