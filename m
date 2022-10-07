Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5CCC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Oct 2022 21:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiJGVcX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Oct 2022 17:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJGVcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2022 17:32:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317B0DFF2;
        Fri,  7 Oct 2022 14:32:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6707B8075B;
        Fri,  7 Oct 2022 21:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B18C433C1;
        Fri,  7 Oct 2022 21:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665178339;
        bh=I1mbVsUS9E5B/l0Mtcoq27bd1f7Bdn5R4TVJ+Qrab/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NtqY+M96z0RybT3IfPhyHjA+vbFcVPlea2z06h1m/gYqSiZDMUCMUNjeavK8YVUmH
         Z+k8+1cbbApwa38D1qLhbZpekQziIoV7G17hqJ5xdmTgW3iFGr2ciKVZdzsxt2uu2s
         ssD5Z6NF+l9aFS26gGc7o7+Z8HraL5Qo0GwkCjkOCgOmK5Rp8GlZECCB47PjxJj99J
         RrLa6FHPSD8NjFuXb4jlHPSt4cDUg53yibe549jAF8aofVGQIzoqaeUvxuiW1rPpfw
         M5WPGZNs20Phmz40h8oCoMYneHdtS0TzX0nfTEBbzr+Ta4EBtswxUdSHK+nKwWt1YB
         LvMfmYPblVFEA==
Date:   Fri, 7 Oct 2022 14:32:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] check: optionally compress core dumps
Message-ID: <Y0Ca43bBFUTl5XHL@magnolia>
References: <166500906990.887104.14293889638885406232.stgit@magnolia>
 <166500908117.887104.12652015559068296578.stgit@magnolia>
 <20221007124526.wr2laws2c7rzujtv@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007124526.wr2laws2c7rzujtv@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 07, 2022 at 08:45:26PM +0800, Zorro Lang wrote:
> On Wed, Oct 05, 2022 at 03:31:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Compress coredumps whenever desired to save space.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  README    |    1 +
> >  common/rc |   13 +++++++++++++
> >  2 files changed, 14 insertions(+)
> > 
> > 
> > diff --git a/README b/README
> > index 80d148be82..ec923ca564 100644
> > --- a/README
> > +++ b/README
> > @@ -241,6 +241,7 @@ Misc:
> >     this option is supported for all filesystems currently only -overlay is
> >     expected to run without issues. For other filesystems additional patches
> >     and fixes to the test suite might be needed.
> > + - Set COMPRESS_COREDUMPS=1 to compress core dumps with gzip -9.
> 
> This patch looks good to me, just one question I'm thinking -- should this
> parameter be under "Misc:" or "Tools specification:" part? If the former is
> good, then:

I was thinking misc, buuut it occurs to me that perhaps we ought to let
people specify a different compression program, e.g.

COMPRESS_COREDUMPS=xz ./check generic/444

in which case this would be a tool spec thing.

I think I'll go back and rework this to do that.

--D

> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> 
> >  
> >  ______________________
> >  USING THE FSQA SUITE
> > diff --git a/common/rc b/common/rc
> > index 9750d06a9a..d3af4e07b2 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -4955,12 +4955,25 @@ _save_coredump()
> >  	local core_hash="$(_md5_checksum "$path")"
> >  	local out_file="$RESULT_BASE/$seqnum.core.$core_hash"
> >  
> > +	if [ "$COMPRESS_COREDUMPS" = "1" ]; then
> > +		out_file="${out_file}.gz"
> > +	fi
> > +
> >  	if [ -s "$out_file" ]; then
> >  		rm -f "$path"
> >  		return
> >  	fi
> >  	rm -f "$out_file"
> >  
> > +	if [ "$COMPRESS_COREDUMPS" = "1" ]; then
> > +		if gzip -9 < "$path" > "$out_file"; then
> > +			rm -f "$path"
> > +		else
> > +			rm -f "$out_file"
> > +		fi
> > +		return
> > +	fi
> > +
> >  	mv "$path" "$out_file"
> >  }
> >  
> > 
> 
