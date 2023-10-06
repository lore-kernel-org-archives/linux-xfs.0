Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AACAEE92FE3
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 05:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjJFFEy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 01:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjJFFEx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 01:04:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3936BB6
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 22:04:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3095C433C7;
        Fri,  6 Oct 2023 05:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696568691;
        bh=3desV0PDtS09EqbU4ya7KUPj3Z3o0/XUB85nudR/6eY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KwMIcK/hYNrnaX2GaJrj/V91JPvsM4xeQOUypbqmgrectnsgKOSnpXbLChkbE93bW
         W1tH1YWO2FOgPGYwQCsGCACrmg0wR2F6I81W12QvQoLa7ii1blEit09djA+dRgbc6i
         oQr2ms6FK2UInrnGhE1DtF8pa7unNUSlzbmPCgcp0BkYWGEgC0nxdVmwrLCDQomXD2
         sEkPqcb2Ug2nDP6ZYQDEGa2iTO0+Cf1zYDMgClHLvZ5NvZd4P55LnmbLM33w1NcfYQ
         jspgezv8csAhaUPYDuDsYScSno5i18ZwgT+jyq8ZCwjEXNDdgNnJsHmsyCLCEoK+Jr
         ICdYYlErqEbRw==
Date:   Thu, 5 Oct 2023 22:04:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Daan De Meyer <daan.j.demeyer@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: mkfs.xfs with --protofile does not copy extended attributes into
 the generated filesystem
Message-ID: <20231006050451.GQ21298@frogsfrogsfrogs>
References: <CAO8sHc=UYg7SFh8DWYq6wRet2CW2P8tNr-pWRNJ2wN=+_qW17g@mail.gmail.com>
 <ZR8qWqksNx1kNhvi@dread.disaster.area>
 <20231006042250.GP21298@frogsfrogsfrogs>
 <ZR+OtcVIsVrJeqMO@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR+OtcVIsVrJeqMO@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 03:36:05PM +1100, Dave Chinner wrote:
> On Thu, Oct 05, 2023 at 09:22:50PM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 06, 2023 at 08:27:54AM +1100, Dave Chinner wrote:
> > > On Thu, Oct 05, 2023 at 10:37:34AM +0200, Daan De Meyer wrote:
> > > > Hi,
> > > > 
> > > > It seems using --protofile ignores any extended attributes set on
> > > > source files. I would like to generate an XFS filesystem using
> > > > --protofile where extended attributes are copied from the source files
> > > > into the generated filesystem. Any way to make this happen with
> > > > --protofile?
> > > 
> > > mkfs.xfs doesn't have a '--protofile' option. It has a '-p <file>'
> > > option for specifying a protofile - is that what you mean?
> > 
> > While we're on the topic, would it also be useful to have a -p switch
> > that would copy the fsxattr options as well?
> 
> If protofile support is going to be extended then supporting
> everything that can be read/set through generic kernel interfaces
> would be appropriate...
> 
> But I'm not convinced that we should extend protofile support
> because mounting the filesytsem and running rsync, xfs_restore, etc
> can already do all this stuffi with no development work necessary...

rsync doesn't support copying the fsxattr data (though it does support
extended attributes), and iirc xfsdump can only do entire filesystems,
right?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
