Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 375AF7CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 08:20:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B057AC003
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 06:20:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id whz9PcX3Mm4ece1C (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2016 06:20:29 -0700 (PDT)
Date: Mon, 22 Aug 2016 08:20:25 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH v2 3/3] xfs_quota: additional changes to allow use on ext4
Message-ID: <20160822132025.GB2736@redhat.com>
References: <1471356998-2876-1-git-send-email-billodo@redhat.com>
	<1471356998-2876-4-git-send-email-billodo@redhat.com>
	<20160822020650.GR19025@dastard>
	<86d459e4-6853-9f3c-3851-3e212f8c7adf@sandeen.net>
	<8c1b4044-ff69-f891-a4f4-b302bd3bfef3@sandeen.net>
	<20160822053455.GT19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160822053455.GT19025@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Aug 22, 2016 at 03:34:55PM +1000, Dave Chinner wrote:
> On Sun, Aug 21, 2016 at 11:46:14PM -0500, Eric Sandeen wrote:
> > On 8/21/16 10:34 PM, Eric Sandeen wrote:
> > > On 8/21/16 9:06 PM, Dave Chinner wrote:
> > >> On Tue, Aug 16, 2016 at 09:16:38AM -0500, Bill O'Donnell wrote:
> > 
> > ...
> > 
> > >> static int
> > >> init_check_command(
> > >> 	const cmdinfo_t *ct)
> > >> {
> > >> 	if (!fspath)
> > >> 		return 1;
> > >>
> > >> 	/* Always run commands that we are told to skip here */
> > >> 	if (ct->flags & CMD_SKIP_CHECK)
> > >> 		return 1;
> > >>
> > >> 	/* if it's an XFS filesystem, always run the command */
> > >> 	if (!(fs_path->fs_flags & FS_FOREIGN))
> > >> 		return 1;
> > > 
> > > Sorry for the late review; thanks for getting on it, Dave - but,
> > > isn't "foreign ok" exactly == "skip check?"
> > > 
> > > The only check that gets skipped is the foreign check, so just
> > > setting FOREIGN_OK seems to accomplish the same thing without
> > > more flag complexity, no?
> > 
> > Oh, the subliminal brain reminded me that we want to be able to
> > issue help or quit whether or not we had the "-f" flag, regardless
> > of the filesystem, and that "foreign" isn't ok unless the -f flag
> > is set, so we do need a class of "always works" commands.
> 
> Right, but that was something that was done in patch 1/3. I pointed
> out that no mention of it was made in the cmmit message there....
> 
> > I guess that was the point of the patch, but I suppose some clarity
> > in comments or commitlog would help slow people like me.  ;)
> 
> Right. better explanations needed all round :P

Yes, I'll clean it up in v3.
Thanks-
Bill


> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
