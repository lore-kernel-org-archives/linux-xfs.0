Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FD6CA0FE1
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Sep 2023 14:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjIAOyp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 10:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350073AbjIAOyo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2023 10:54:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3CD10F1;
        Fri,  1 Sep 2023 07:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6815ACE23C2;
        Fri,  1 Sep 2023 14:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1766C433C7;
        Fri,  1 Sep 2023 14:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693580076;
        bh=NjwxTCm/jZ2eU51BgFry4cbLuNpDiz0CT8mjOyQgexM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tr9SjxLA4Ftu7kyN7WO5NTgJRmR7Q2RDTTJagwkYWiw+qbjDpKkb5pz8vi/5C+LlF
         y7UbLnisLHxl45vFEjlOvt5osdN7yAnVu/y68mpiys9r+/9WpxDIBJBHyqMdzKpLRm
         Lfzoo/G9JuoCyLdepnozBCkHUY+JiHmbR11lS+g1Tc91XBZ97TeLhM9SI4d35xEOl5
         cU2tGbMEwtVacVb/x8RlxuqP/0pDxaaq9cAsaoDGccP4B4flQ0VY8rL3+7y9AIZqtI
         XH0xKrBjm3VcEjHhNBSQE8U1PYfOFcAFJ/osIrBAhTl4QfokHATbJ8zJHRM02/jZ4c
         XioAAAwQDClqQ==
Date:   Fri, 1 Sep 2023 07:54:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Emmanuel Florac <eflorac@intellique.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: online repair is completely finished!
Message-ID: <20230901145436.GQ28186@frogsfrogsfrogs>
References: <20230822002204.GA11263@frogsfrogsfrogs>
 <20230828143317.1353fc3f@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230828143317.1353fc3f@harpe.intellique.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 28, 2023 at 02:33:17PM +0200, Emmanuel Florac wrote:
> Le Mon, 21 Aug 2023 17:22:04 -0700
> "Darrick J. Wong" <djwong@kernel.org> écrivait:
> 
> > Hi folks,
> > 
> > I am /very/ pleased to announce that online repair for XFS is
> > completely finished.  For those of you who have been following along
> > all this time, this means that part 1 and part 2 are done!
> > 
> 
> As nobody chimed in to congratulate you, I'll tell it : you're a hero,
> Darrick :)

Thank you!!

--D

> cheers
> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------


