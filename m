Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45550C07E96
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 18:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3131C61C69
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 18:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhGFSbg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231252AbhGFSbg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 14:31:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C7CB61C3A;
        Tue,  6 Jul 2021 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625596137;
        bh=Znz8tyVxTjgzVUAjkr+at0r00acuX8jnjQI7CmbwPn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mi3+GmiOQPGvTshJMM7PoW1pNbxAsXCtvN1UebEBUGbj3zTIPrOtol5WjkayGeb/U
         skS8jiMnq7sTnkD1KbaKFBfOujGyBbafl6kZ7FlK191Cb+hc+l+4hTv9PbJPDXseNc
         8TU9DOi7xuhjde/w/0TsPptJKRJw6HTVaU7AQYYuyBPwfCWDMYoL40qWLPZYs5jAKM
         UAcECZCT2Ycg9cZtfGU0g63diQL8GB/eO8JJ6HRigkYU/ZiVMwOQPi7+NpzBz2jOJU
         PdaOm86zPd05Z7wnwL6giWgqSy8LYTW4ZUQEl9PRNdw6PttcHqIiAGGNfIomnE6/Rs
         MY5I8LIxQ6/9g==
Date:   Tue, 6 Jul 2021 11:28:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_io: clean up the funshare command a bit
Message-ID: <20210706182856.GC11588@locust>
References: <162528107717.36401.11135745343336506049.stgit@locust>
 <162528108811.36401.13142861358282476701.stgit@locust>
 <YOMjJmxA7WjO8kGq@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOMjJmxA7WjO8kGq@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 05, 2021 at 04:20:06PM +0100, Christoph Hellwig wrote:
> On Fri, Jul 02, 2021 at 07:58:08PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add proper argument parsing to the funshare command so that when you
> > pass it nonexistent --help it will print the help instead of complaining
> > that it can't convert that to a number.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  io/prealloc.c |   16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/io/prealloc.c b/io/prealloc.c
> > index 2ae8afe9..94cf326f 100644
> > --- a/io/prealloc.c
> > +++ b/io/prealloc.c
> > @@ -346,16 +346,24 @@ funshare_f(
> >  	char		**argv)
> >  {
> >  	xfs_flock64_t	segment;
> > +	int		c;
> >  	int		mode = FALLOC_FL_UNSHARE_RANGE;
> > -	int		index = 1;
> >  
> > -	if (!offset_length(argv[index], argv[index + 1], &segment)) {
> > +	while ((c = getopt(argc, argv, "")) != EOF) {
> > +		switch (c) {
> > +		default:
> > +			command_usage(&funshare_cmd);
> > +		}
> 
> Do we really need this switch boilerplate?

Sort of -- without it, you get interactions like:

$ xfs_io -c 'funshare 0 --help' /autoexec.bat
non-numeric length-argument -- --help

which is silly, since we could display the help screen.

The other solution might be to fix all the offset_length() callers to
emit command usage when the number parsing doesn't work, but that would
clutter up the error reporting when you try to feed it a number that
doesn't parse.

> > +	}
> > +        if (optind != argc - 2)
> > +                return command_usage(&funshare_cmd);
> 
> Spaces instead of tabs here.

Fixed.

--D
