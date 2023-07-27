Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22CBCC00528
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 01:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjG0By4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 21:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjG0Byz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 21:54:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A591A212A;
        Wed, 26 Jul 2023 18:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37DF561CEC;
        Thu, 27 Jul 2023 01:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8435CC433C8;
        Thu, 27 Jul 2023 01:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690422890;
        bh=jdNTKdOSeNBUq6sNo+3Z3srO3cMYWkOPOvt/KV753d4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QvB1Jc3v4dCgMbvfadDG0RVFlF0s33O22IhT/GivM/MxgI64tCkCFBaTt6YmSfdA8
         mQPg8aGYtIx2bYPO/kgFZ+2H7J3h+5Bw0JviJXmKc3eNg8OW5ha1KmMikWSlesc8w/
         FfhAgWcPVPrFkYDtrRJzh9EAwE+fFREJgCY/oyj3pr2/0VmB+zTy966EutdNUXBgEV
         TTYsZtJMyMFEFtIqbc3Aze5+LBFgEOvYkPZxMDHXxHIF0xTUcBM6WQXQM/0zY6/Cws
         TKvBGx76Zl+TcMIXIIAT68wBBZjy/0EF0ZkV7mYNY1uerl3f+dg0rnLhl5gA8OkZTV
         k1sR5nWjDDUog==
Date:   Wed, 26 Jul 2023 18:54:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230727015449.GC11352@frogsfrogsfrogs>
References: <20230719151024.ef7vgjmtoxwxkmjm@zlang-mailbox>
 <20230719152907.GA11377@frogsfrogsfrogs>
 <20230719161115.byva7tvwoafkesga@zlang-mailbox>
 <20230720022756.GH11352@frogsfrogsfrogs>
 <20230720143433.n5gkhukdkz7s5ab7@zlang-mailbox>
 <20230726000524.GG11340@frogsfrogsfrogs>
 <20230726060102.GB30264@mit.edu>
 <20230726145441.lbzzokwigrztimyq@zlang-mailbox>
 <20230726205930.GC30264@mit.edu>
 <20230727013627.GF30264@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727013627.GF30264@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 09:36:27PM -0400, Theodore Ts'o wrote:
> As an aside, while I was testing my updates to the kvm-quickstart[1]
> documentation, I timed how long it takes to run "-g quick" for a basic
> ext4 file system config with 4k blocks using a desktop NVMe SSD for
> the test and scratch devices.
> 
> [1] https://github.com/tytso/xfstests-bld/blob/test/Documentation/kvm-quickstart.md
> 
> It took 62 minutes, or a little over an hour.  Yowza!  I hadn't
> realized that "kvm-xfstests smoke" was now taking that long.  It used
> to be that using a slower SSD (an Intel SATA-attached SSD dating from
> 2008) I could run "-g quick" in 15 minutes.  Clearly, things were a
> lot simpler back then.  :-)
> 
> Anyway, I definitely need to replace what "kvm-xfstests smoke" does
> with something else much more abbrevuated before I start requesting
> drive-by patch submitters to run an fstests "smoke test".  Because an
> hour isn't it.  Ideally, I'd like to keep it under 10 minutes if at
> all possible, but we still want the testing to be likely to detect
> most of the sort of simple problems that a drive-by patch submitter
> might be likely find....
> 
> The fundamental question is how to do get the maximal amount of value
> given a limited test budget.

Just out of curiosity, if you apply this patch and change kvm-xfstests
smoke to run ./check -smoketest, how long does that actually take on
your infrastructure?

--D

> 					- Ted
