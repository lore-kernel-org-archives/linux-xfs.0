Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065F9C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 15:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJMPuM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 11:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJMPuJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 11:50:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC48422CF;
        Thu, 13 Oct 2022 08:50:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F6DE6186B;
        Thu, 13 Oct 2022 15:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E4FC433D7;
        Thu, 13 Oct 2022 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665676203;
        bh=+uqZDl54/XnooiyOhlrOeJdNMvQ3hqg6Ja4OTn+rCnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LFiLaUNzB1AdOSGAhVmk6hZ7q7NAuEibWgZj+878xpkhthOm2K7wAvTqQxxCZ5JCj
         v/RPbu0L2wvStIl8JVD2gC8Oc5n6vB3h3W2puf4kmgHvNZzvoqJ9bg3zGGlYumwsuG
         gDlOAyeTh4sP9BcmsCNWGDjJXo+pa6KMWDdUAwIf7JHe9OicPteQQq2NQT+6kep49/
         dnvo/8QcMUKbJ+ck8WRRXSpMaMfZyBXLWGuNMtged7nJ2rFN5pyzKz84R7lRHHVhJr
         NYjh0aBEL2OZFwp5hFLZMQPCwYEJM6UmWKhOXvtCpEjBWSLMxkU3pigF1ErrhuuDi+
         BSeP1h+ve6GDA==
Date:   Thu, 13 Oct 2022 08:50:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] check: optionally compress core dumps
Message-ID: <Y0gzqyyaU171aagR@magnolia>
References: <166553910766.422356.8069826206437666467.stgit@magnolia>
 <166553911893.422356.7143540040827489080.stgit@magnolia>
 <20221013115102.qb7r37ywdy2qbwkn@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013115102.qb7r37ywdy2qbwkn@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 13, 2022 at 07:51:02PM +0800, Zorro Lang wrote:
> On Tue, Oct 11, 2022 at 06:45:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a new option, COREDUMP_COMPRESSOR, that will be used to compress
> > core dumps collected during a fstests run.  The program specified must
> > accept the -f -9 arguments that gzip has.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  README    |    4 ++++
> >  common/rc |   14 +++++++++-----
> >  2 files changed, 13 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/README b/README
> > index 80d148be82..4c4f22f853 100644
> > --- a/README
> > +++ b/README
> > @@ -212,6 +212,10 @@ Tools specification:
> >      - Set FSSTRESS_AVOID and/or FSX_AVOID, which contain options added to
> >        the end of fsstresss and fsx invocations, respectively, in case you wish
> >        to exclude certain operational modes from these tests.
> > + - core dumps:
> > +    - Set COREDUMP_COMPRESSOR to a compression program to compress crash dumps.
> > +      This program must accept '-f' and the name of a file to compress.  In
> > +      other words, it must emulate gzip.
> >  
> >  Kernel/Modules related configuration:
> >   - Set TEST_FS_MODULE_RELOAD=1 to unload the module and reload it between
> > diff --git a/common/rc b/common/rc
> > index 152b8bb414..c68869b7dc 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -4956,13 +4956,17 @@ _save_coredump()
> >  	local core_hash="$(_md5_checksum "$path")"
> >  	local out_file="$RESULT_BASE/$seqnum.core.$core_hash"
> >  
> > -	if [ -s "$out_file" ]; then
> > -		rm -f "$path"
> > -		return
> > -	fi
> > -	rm -f "$out_file"
> > +	for dump in "$out_file"*; do
> > +		if [ -s "$dump" ]; then
> > +			rm -f "$path"
> > +			return 0
> > +		fi
> > +	done
> >  
> >  	mv "$path" "$out_file"
> > +	test -z "$COREDUMP_COMPRESSOR" && return 0
> > +
> > +	$COREDUMP_COMPRESSOR -f "$out_file"
> 
> This patch looks good to me,
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> I'm just not sure if all/most compressor supports "-f" option, I use bzip2
> and gzip mostly, they both support that.

As do xz, lz4, and zstd, so I think that's sufficient coverage.

The only one I know of that won't be compatible is zip, since it uses -f
for "freshen archive".

--D

> Thanks,
> Zorro
> 
> >  }
> >  
> >  init_rc
> > 
> 
