Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F47C11D09
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 13:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5414222C4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582206154;
	bh=kLhP1URrWaxjLC2OSHW5CTjnSxV9t3hQTHhtufmcwD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gPC9oCMoc/JffxVVPeLWZ+cMWvSywL6kmLRx68tUnkkG+5rOP7EdPCLwywVf5OAwj
	 6CC8RB6r/2M63YxmRRUW3Tdich1Uc6H5hK7PlT8bb/80YZFSzOUwv6vLlm6dZLa9UD
	 MYJurMlcbieXr65n2tRKA+bdxi47a4O7NHQKwbpw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgBTNme (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 08:42:34 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39448 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbgBTNme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 08:42:34 -0500
Received: by mail-pj1-f67.google.com with SMTP id e9so911114pjr.4;
        Thu, 20 Feb 2020 05:42:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=A8nR8c1bnJTy/2DwNb9tSR6XMbpEcSCUAourdL5AT9k=;
        b=Ggmt/H8/LIr6wcK6s//BKEEB8/kF3k9/JE0SK6WJxaw18wjAfTslkO2hMKyxkjUo1a
         199w8cpuzCOZB1OXWJeMmSNaE66pqtQiVyxFDqSG8O50yAbFenpINzLa7cEYcdQ8zbrT
         ImOPagwzYptzSA4htWaE9U1iCSG4XjlcEGFJIPsLE4fzHq0dF43A9r5lbeF8Zn11AVJK
         +2B6OWEJdh9hRjXQvk8L7EX/fTzQC2jyOSShsDOPTcm+1cxdZYroULG6uDL1pRAVuy3o
         pA/wR/iUY+LSdhdkTV0YDUIKEU4O6n+HlT45BLvuhH9UlKEJLWUBOUhDhATkFAbehmbK
         bhkQ==
X-Gm-Message-State: APjAAAW9glcqTHXgh1SaePIP1zym9863bwqWq3MhO9vr83TuKbi946L7
        jGY0vU2uIj3FxiRFe+v+Iv3RPQ+QqwY=
X-Google-Smtp-Source: APXvYqwnnKeBhiA28TqOxapiOXOU+5ubbxne7yT4+V3/2Ymh8GM5lkVQljeZSJIqEtP0+f0V9e0hsw==
X-Received: by 2002:a17:902:8bc7:: with SMTP id r7mr31314171plo.12.1582206153245;
        Thu, 20 Feb 2020 05:42:33 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id d3sm3695887pjx.10.2020.02.20.05.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:42:32 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 759EE402D7; Thu, 20 Feb 2020 13:42:31 +0000 (UTC)
Date:   Thu, 20 Feb 2020 13:42:31 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/030: fix test for external log device
Message-ID: <20200220134231.GV11244@42.do-not-panic.com>
References: <d3b3a65e-3575-f153-98ca-4a34e170ab78@redhat.com>
 <e1ce0ddb-a043-03bc-167c-c36476f0a9ee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1ce0ddb-a043-03bc-167c-c36476f0a9ee@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 08:20:14PM -0600, Eric Sandeen wrote:
> On 2/19/20 8:16 PM, Eric Sandeen wrote:
> > Several tests fail if an external log device is used; in this case
> > the xfs_db invocation fails with a clear indication of why, so fix
> > that as other tests do by testing for and using the external log
> > option if present.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> hm self-NAK I didn't realize we had _scratch_xfs_db, better to go
> through and fix all of these sorts of things at once.
> 
> Luis, seems like you have an itch to scratch, no?

I didn't know it was so easy, sure! Since I test rt and logdev
on stable kernels, will give this a crack once I have my new
stable test rig running. Thanks for the proactive approach.

  Luis
