Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A7BC77B7A
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jun 2023 07:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240458AbjFMHwP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 03:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238289AbjFMHwO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2023 03:52:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC0AE7C
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jun 2023 00:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7389661EB8
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jun 2023 07:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174D4C433EF;
        Tue, 13 Jun 2023 07:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686642732;
        bh=+hHPA/I8mQszOroLyiBNdwJLglLlVMdtpS0wBiAY2V0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XFZIOsNJMLwI1YDDqASuDJw7EvK9krQTilDR0zjDfpGRjibGxvPF64M/Y4DLc3p2T
         Tm4zE4qRyr5aqXgwq3eHS3jU5CGRmduPRWmSiKsGY5FNhb1Rw5pKUV4Toov8c+aeGG
         D6ZE0Aw0w1flSC6HinoNJTo1+sSSFJpH5XsxYLbpro4c7PBUhw3c99p5ZvOYXlkWOU
         ANnNActm7LURUvsBq1oPXTaj5NLaqveG6o7M/jGJlnpmCMHTXPsE11C1EKj6XDHpSQ
         /rATlygJs7VqBQowHmOP3bCTddsIIVRBGJrHQ2kuk80WM8VH/nK/LlFofdkvJw0Iyz
         KkpWUixV/gE4w==
Date:   Tue, 13 Jun 2023 09:52:07 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Weifeng Su <suweifeng1@huawei.com>, linux-xfs@vger.kernel.org,
        hch@lst.de, sandeen@sandeen.net, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com
Subject: Re: [PATCH v2] libxcmd: add return value check for dynamic memory
 function
Message-ID: <20230613075207.qmszpcaepbem7dqi@andromeda>
References: <20230608025146.64940-1-suweifeng1@huawei.com>
 <20230608144624.GU1325469@frogsfrogsfrogs>
 <c247b956-55e9-ecd1-4db0-d45d2f65e9fe@huawei.com>
 <W-F_NbCmDcMEVA17P_cDfzk3P4fh6hEvEGo307Dz4E6cPvgK0hr-VIZ_4EAsIFTMpls6DU-1Kgh5Pk107NtQeQ==@protonmail.internalid>
 <20230612152533.GB11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612152533.GB11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 08:25:33AM -0700, Darrick J. Wong wrote:
> [add xfsprogs maintainer to thread]
> 
> On Mon, Jun 12, 2023 at 08:23:00PM +0800, Weifeng Su wrote:
> > Just ping, Is the merge windown open?
> 
> It's never not open for xfsprogs, but mostly it depends on the xfsprogs
> maintainer (Carlos) deciding to pick up a patch.

I'll pull this into for-next on my next batch. Hopefully this week yet.

-- 
Carlos

> 
> --D
> 
> > On 2023/6/8 22:46, Darrick J. Wong wrote:
> > > On Thu, Jun 08, 2023 at 10:51:46AM +0800, Weifeng Su wrote:
> > > > The result check was missed and It cause the coredump like:
> > > > 0x00005589f3e358dd in add_command (ci=0x5589f3e3f020 <health_cmd>) at command.c:37
> > > > 0x00005589f3e337d8 in init_commands () at init.c:37
> > > > init (argc=<optimized out>, argv=0x7ffecfb0cd28) at init.c:102
> > > > 0x00005589f3e33399 in main (argc=<optimized out>, argv=<optimized out>) at init.c:112
> > > >
> > > > Add check for realloc function to ignore this coredump and exit with
> > > > error output
> > > >
> > > > Signed-off-by: Weifeng Su <suweifeng1@huawei.com>
> > >
> > > Looks good to me,
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > >
> > > --D
> > >
> > > > ---
> > > > Changes since version 1:
> > > > - Modify according to review opinions, Add more string
> > > >
> > > >   libxcmd/command.c | 4 ++++
> > > >   1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/libxcmd/command.c b/libxcmd/command.c
> > > > index a76d1515..e2603097 100644
> > > > --- a/libxcmd/command.c
> > > > +++ b/libxcmd/command.c
> > > > @@ -34,6 +34,10 @@ add_command(
> > > >   	const cmdinfo_t	*ci)
> > > >   {
> > > >   	cmdtab = realloc((void *)cmdtab, ++ncmds * sizeof(*cmdtab));
> > > > +	if (!cmdtab) {
> > > > +		perror(_("adding libxcmd command"));
> > > > +		exit(1);
> > > > +	}
> > > >   	cmdtab[ncmds - 1] = *ci;
> > > >   	qsort(cmdtab, ncmds, sizeof(*cmdtab), compare);
> > > >   }
> > > > --
> > > > 2.18.0.windows.1
> > > >
