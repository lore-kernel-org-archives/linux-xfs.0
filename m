Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E43C197A0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 03:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjKPD6w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 22:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjKPD6w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 22:58:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7A59E
        for <linux-xfs@vger.kernel.org>; Wed, 15 Nov 2023 19:58:48 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B623C433C8;
        Thu, 16 Nov 2023 03:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700107128;
        bh=goeDjvc6uvJpo9BQZeB6C5mQDgdaw/1wIQ3kmGRrrYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vcu+j2QvwxVFR5et3XkKXfpWM7WVHtJRCspUyzbAGhNwAksFexsMnVCQ/TPLFmaVA
         Oo1o4XGFtXoYYhzXJhtLj168Mcgnc+fd/+7oFl5VH7eDOOHxzwcGFAFSvdKxNY+1vD
         IVGcti/Y7BcfaxTXfHDMDqQBokCzkpXxZKannEkX8rM7aDLDJyCTO8LxH8YeDelgDL
         k9AD9qcVb2/r1OXyY3oIlZTBiUDYd+wbGyEOGmxJk73ei4A4jfSVsZYQ3Y14p9czuh
         0EIHxTeG9FXpyoOY3FKkGoPlfMhzbpAIXyKFA+w4hIez3zX4FAVAw3iBcpomatiFTi
         q43kmgXQPIIVQ==
Date:   Wed, 15 Nov 2023 19:58:46 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [xfsprogs PATCH] xfs_io/encrypt: support specifying crypto data
 unit size
Message-ID: <20231116035846.GA1583@sol.localdomain>
References: <20231013062639.141468-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013062639.141468-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 11:26:39PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add an '-s' option to the 'set_encpolicy' command of xfs_io to allow
> exercising the log2_data_unit_size field that is being added to struct
> fscrypt_policy_v2 (kernel patch:
> https://lore.kernel.org/linux-fscrypt/20230925055451.59499-6-ebiggers@kernel.org).
> 
> The xfs_io support is needed for xfstests
> (https://lore.kernel.org/fstests/20231013061403.138425-1-ebiggers@kernel.org),
> which currently relies on xfs_io to access the encryption ioctls.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  configure.ac          |  1 +
>  include/builddefs.in  |  4 +++
>  io/encrypt.c          | 72 ++++++++++++++++++++++++++++++++-----------
>  m4/package_libcdev.m4 | 21 +++++++++++++
>  man/man8/xfs_io.8     |  5 ++-
>  5 files changed, 84 insertions(+), 19 deletions(-)

Hi!  Any feedback on this patch?

- Eric
