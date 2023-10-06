Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3D5E92FDD
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 04:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjJFEWw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 00:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjJFEWv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 00:22:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D2CDB
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 21:22:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAABEC433C7;
        Fri,  6 Oct 2023 04:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696566170;
        bh=iGS73n1Tw2X4DxkFY7QRdg196AhpMkyo3BRidcdMXCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i18RsW692XXDVCcFMJIOAfAuxXgL8VSnccyBm12FwxWkmezuEjhvd3QynmWgDetkB
         iB6UZ6yXU9fSFicf6J46YBl2mM+qGSos1ytsm06TxzVWkcyPnRgj1j20fNOOty0moM
         bD5lM7SpSlVCrQmmcaUzM6Br3GMI8sMZcXpiukUBNcMursBG5RPc95S9pqqTmegxlU
         qHvzjGIk7P+WloUrNcJ19jzSCrekQHUpKBl+LQXyKBuz3LlZdti41n/e43XOI8rG+l
         wXymAlMazd9F+l1IdupwOqmMarUoMksrhMIyPy03PU9bNiq290Kn4SSmZsj+hlIp3O
         nubcYidt4ySXg==
Date:   Thu, 5 Oct 2023 21:22:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Daan De Meyer <daan.j.demeyer@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: mkfs.xfs with --protofile does not copy extended attributes into
 the generated filesystem
Message-ID: <20231006042250.GP21298@frogsfrogsfrogs>
References: <CAO8sHc=UYg7SFh8DWYq6wRet2CW2P8tNr-pWRNJ2wN=+_qW17g@mail.gmail.com>
 <ZR8qWqksNx1kNhvi@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR8qWqksNx1kNhvi@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:27:54AM +1100, Dave Chinner wrote:
> On Thu, Oct 05, 2023 at 10:37:34AM +0200, Daan De Meyer wrote:
> > Hi,
> > 
> > It seems using --protofile ignores any extended attributes set on
> > source files. I would like to generate an XFS filesystem using
> > --protofile where extended attributes are copied from the source files
> > into the generated filesystem. Any way to make this happen with
> > --protofile?
> 
> mkfs.xfs doesn't have a '--protofile' option. It has a '-p <file>'
> option for specifying a protofile - is that what you mean?

While we're on the topic, would it also be useful to have a -p switch
that would copy the fsxattr options as well?

--D

> Regardless, there is no xattr support in mkfs/proto.c at all - it's
> never been supported, and I don't recall anyone ever asking for it.
> Hence it would have to be implemented from scratch if you need it.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
