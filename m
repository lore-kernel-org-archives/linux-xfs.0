Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39135 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1434129AbdDZBE7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 21:04:59 -0400
Date: Wed, 26 Apr 2017 03:04:57 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 05/12] mkfs: extend opt_params with a value field
Message-ID: <20170426010457.GQ28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-6-jtulak@redhat.com>
 <20170425031326.GI28800@wotan.suse.de>
 <CACj3i70LFrv9HbMRYg7M8qutCfmhFHC8oCUtrkf3vP8kvKUw4Q@mail.gmail.com>
 <CACj3i71JaxqjZ_qUvZSOu6gTeZhjm86VfA2asNZNppV2t6_wDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i71JaxqjZ_qUvZSOu6gTeZhjm86VfA2asNZNppV2t6_wDA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 11:39:00AM +0200, Jan Tulak wrote:
> And rather than submitting repeatedly new versions of the whole
> patch... how about this?
> 
>  *
>  *   value OPTIONAL
>  *     The actual value used in computations and for creating the filesystem.
>  *     It is filled with user input and anything you write here now is

I think its easier to read if you are clear from the start user input is
optional, and so a default value is used first, and use input overrides
these initial system defaults.

>  *     overwritten if the user specifies the subopt. But he does not,
> then whatever

"But he does not", I guess you meant, "But if he does not"...

>  *     you put there is used as the default. Can be omitted if the default
>  *     is 0.

Hm, how about:

The actual value used in computations for creating the filesystem.
This is initialized with sensible default values, if initialized to 0
the value is considered disabled. User input can optionally override
default values. If the field is a string and not a number, the value
is set to a positive non-zero number when user input has been supplied.

>  *     (If the field is a string and not a number, this value is set to
>  *     a positive non-zero number on an user input.)
> 
> And for the commit message, a bit shortened version:
> 
> Add a new field int opt_params - value - which is the actual value
> used in computations and for creating the filesystem. It is filled
> with user input if the user specifies the subopt. But he does not,
> then whatever you put there is used as the default.

Modulo "But he does not"/ "but if no user input is not passed then
the originally set defaults will be used"

  Luis
