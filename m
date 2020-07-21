Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B44DC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55CDC22B4E
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595292424;
	bh=0QnEc0nhtyk6CxnNn+Ogs09Y6WAEOsObn2/QrbH0wAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Tfi05w+Uxk7uZxwcU0ohAFRXhulJjUlgU3vvRSCrC3u33hYFXNkEpCOoxw7MPyFO0
	 skPAOmrkOEf9pdhe4Nbke0l3tbSEunrfWBu/z5SekOMgYfj7gMtYnyPrq2UnbP+6R/
	 dcNFvMdj6bqUyOUOWUWTo8KipXGOCSyIOJpHZKFw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgGUArD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbgGUArD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Jul 2020 20:47:03 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DD2A208E4;
        Tue, 21 Jul 2020 00:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595292422;
        bh=0QnEc0nhtyk6CxnNn+Ogs09Y6WAEOsObn2/QrbH0wAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zXjQJuTgwjsyBP/XIuwwWrk6+fGv2stjiMFEQrUAFDaawwAvnoRXp1XPdTNkjL7f7
         Yq2vvfw7fzPXBERGoijQO416KaAO0tQVnbatWBAqcRkPJO4GA4bQePcshNfWFYfpj8
         Fp8fFI1madGtLCD/K0QHmHE4XguNU6m/Ot+r+LoM=
Date:   Mon, 20 Jul 2020 17:47:01 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 7/7] fscrypt: update documentation for direct I/O
 support
Message-ID: <20200721004701.GD7464@sol.localdomain>
References: <20200720233739.824943-1-satyat@google.com>
 <20200720233739.824943-8-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720233739.824943-8-satyat@google.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 20, 2020 at 11:37:39PM +0000, Satya Tangirala wrote:
> Update fscrypt documentation to reflect the addition of direct I/O support
> and document the necessary conditions for direct I/O on encrypted files.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>

Reviewed-by: Eric Biggers <ebiggers@google.com>
