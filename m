Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373D0C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jun 2023 15:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbjFBPCu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jun 2023 11:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236405AbjFBPCi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2023 11:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380DF10F8
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jun 2023 08:02:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F347E63B3E
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jun 2023 15:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57563C433EF;
        Fri,  2 Jun 2023 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685718147;
        bh=t0fHDb1CoJAberIf/bIF5bMVQs66srvOgMGWp3mceaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TbSCsMeg1PcJx8sAoYEHjDU+2TVY7+e0Dod1LXn1VMJ3SzPmONK8vmqQTGhADA9HF
         05tiObVURRe6LXdZO+07J9lJurtw+I4JHcrYG6wwH/D/wa7BqeH8m5EsGzbCD/gS+b
         vmd+rOWqw0iqupxE2hCUFcYU/JKmtcyVQmjbGmbDQEIiq2KmRzeSGqzb/jE/ZgZfK3
         CO0gRN9gw46yPmaVW0t6rxd9+K7SjoHrJ2oeY9f6rFVhhHierjOlznjB+tWvf9FqEI
         bsokfDNp+Xqi1dXjWp/qrss8UOYkEDcSIQsDB2yuM8iV94+G8KpdZ3LeS77wDApzo9
         4oOpvvGeIrwnw==
Date:   Fri, 2 Jun 2023 08:02:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/24] mdrestore: Add support for passing log device as
 an argument
Message-ID: <20230602150226.GO16865@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-24-chandan.babu@oracle.com>
 <20230523180959.GC11620@frogsfrogsfrogs>
 <87edn3iian.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edn3iian.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 07:13:03PM +0530, Chandan Babu R wrote:
> On Tue, May 23, 2023 at 11:09:59 AM -0700, Darrick J. Wong wrote:
> > On Tue, May 23, 2023 at 02:30:49PM +0530, Chandan Babu R wrote:
> >> metadump v2 format allows dumping metadata from external log devices. This
> >> commit allows passing the device file to which log data must be restored from
> >> the corresponding metadump file.
> >> 
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> ---
> >>  mdrestore/xfs_mdrestore.c | 10 ++++++++--
> >>  1 file changed, 8 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> >> index 9e06d37dc..f5eff62ef 100644
> >> --- a/mdrestore/xfs_mdrestore.c
> >> +++ b/mdrestore/xfs_mdrestore.c
> >> @@ -427,7 +427,8 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
> >>  static void
> >>  usage(void)
> >>  {
> >> -	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
> >> +	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
> >> +		progname);
> >>  	exit(1);
> >>  }
> >>  
> >> @@ -453,7 +454,7 @@ main(
> >>  
> >>  	progname = basename(argv[0]);
> >>  
> >> -	while ((c = getopt(argc, argv, "giV")) != EOF) {
> >> +	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
> >>  		switch (c) {
> >>  			case 'g':
> >>  				mdrestore.show_progress = 1;
> >> @@ -461,6 +462,9 @@ main(
> >>  			case 'i':
> >>  				mdrestore.show_info = 1;
> >>  				break;
> >> +			case 'l':
> >> +				logdev = optarg;
> >> +				break;
> >>  			case 'V':
> >>  				printf("%s version %s\n", progname, VERSION);
> >>  				exit(0);
> >> @@ -493,6 +497,8 @@ main(
> >>  	}
> >>  
> >>  	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0) {
> >> +		if (logdev != NULL)
> >> +			usage();
> >>  		mdrestore.mdrops = &mdrestore_ops_v1;
> >>  		header = &mb;
> >>  	} else if (mdrestore_ops_v2.read_header(&xmh, src_f) == 0) {
> >
> > What if we have a v2 with XME_ADDR_LOG_DEVICE meta_extents but the
> > caller doesn't specify -l?  Do we proceed with the metadump, only to
> > fail midway through the restore?
> 
> restore_v2() has the following statement just after reading in the superblock,
> 
> 	if (sb.sb_logstart == 0 && log_fd == -1)
>                 fatal("External Log device is required\n");
> 
> Hence, In the case of a missing log device argument, the program exits before
> any metadata is written to the target device.

Ah, ok, that's how you handle that.  In that case the only reason for a
flag in the v2 metadump header would be the principle of declaring
things that happen later in the metadump stream/file.  Your call. :)

--D

> -- 
> chandan
