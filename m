Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37918 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753845AbdLMCL2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 21:11:28 -0500
Date: Tue, 12 Dec 2017 21:11:24 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/9] generic/381: use username fsgqa-381
Message-ID: <20171213021124.ok3me6bpvfa4mgmo@thunk.org>
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213004519.29340-2-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 12, 2017 at 04:45:11PM -0800, Luis R. Rodriguez wrote:
> Some systems are not allowing usernames prefixed with a number now.
> One can however use numbers as a postfix so use that.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  README                |  2 +-
>  tests/generic/381     | 16 ++++++++--------
>  tests/generic/381.out |  4 ++--
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/README b/README
> index ed69332e774e..e05142be1a87 100644
> --- a/README
> +++ b/README
> @@ -20,7 +20,7 @@ _______________________
>  - run make
>  - run make install
>  - create fsgqa test user ("sudo useradd fsgqa")
> -- create 123456-fsgqa test user ("sudo useradd 123456-fsgqa")
> +- create fsgqa-381 test user ("sudo useradd fsgqa-381")

I'd suggest using the username "fsgqa2" so that other tests that want
to use a second username can do so using a more logically name username.

       	 		     	- Ted
