Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9265C48BE8
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Jun 2021 00:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 913E7613D9
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Jun 2021 00:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFLAKE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 20:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhFLAKE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jun 2021 20:10:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F196124B;
        Sat, 12 Jun 2021 00:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623456485;
        bh=qdA3OELLB5CP/JOvUeK9pnaH5r2hCiQAUX7423yxG5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ThJIjOR3zLAG1kPymiUq8sfpe4+/HAspRBc62FxTPVtYxKnJI4mhMUG0tTZwsunUw
         2MV5xeCKLh5/Dted/yq7A5XbUaVSMXieMl8t7hvvEjcxUg0XODKwVTHzCv9I/diVR/
         eG7es1xG02bE37I9lUDKn9FJfWkHV7T6z7aKE/f8hNayhnd/D+lQC1y9mZ0WvxemVF
         +iYcbLpqEloGgcr32OMAufI8CQGgap7ki5o1isZIURWeuinEfRLOudVHagrylktw5V
         vOiiLS9amC8SujyJh9TYx2L3dLgopyjNr59iFBnyKWvtMI1g9AwOQfCU2Ijed7gh5L
         qvnBdy5Szm+AQ==
Date:   Fri, 11 Jun 2021 17:08:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com
Subject: Re: [PATCH 03/13] fstests: refactor test boilerplate code
Message-ID: <YMP65LkTANPpJ2Bg@gmail.com>
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317277866.653489.1612159248973350500.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162317277866.653489.1612159248973350500.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 10:19:38AM -0700, Darrick J. Wong wrote:
> diff --git a/common/preamble b/common/preamble
> new file mode 100644
> index 00000000..63f66957
> --- /dev/null
> +++ b/common/preamble
> @@ -0,0 +1,49 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +
> +# Boilerplate fstests functionality
> +
> +# Standard cleanup function.  Individual tests should override this.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}

This probably should use "rm -rf" so that tests don't need to override this just
because they created directories rather than files.

- Eric
