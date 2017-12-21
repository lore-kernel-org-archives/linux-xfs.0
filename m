Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbdLUIXo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Dec 2017 03:23:44 -0500
Date: Thu, 21 Dec 2017 16:23:42 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic/381: enable on systems which allows usernames
 that begin with digits
Message-ID: <20171221082342.GG5123@eguan.usersys.redhat.com>
References: <20171215204107.17690-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171215204107.17690-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Dec 15, 2017 at 12:41:07PM -0800, Luis R. Rodriguez wrote:
> Some systems are not allowing usernames prefixed with a number now, this
> test however relies on the assumption that you can end up with usernames
> of such type, given the purpose of the test is to ensure that xfs_quota
> can differentiate between UIDs and names beginning with numbers.
> 
> systemd >= 232 (circa 2017) no longer allows usernames starting with digits
> [0], there is a systemd exploit (CVE-2017-1000082 [1]) for why that was done,
> however even upstream shadow useradd also does not allow similar user types
> since shadow version v4.0.1 (circa 2007) [2] but there no easy way to check
> shadow's useradd's version.
> 
> You can still shoehorn in these types of users by manually editing files,
> but that's just shooting yourself on the foot given all the precautions
> taken now by userspace, so just check for the systemd version for now as
> requirement for running this test.
> 
> [0] https://github.com/systemd/systemd/issues/6237
> [1] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-1000082
> [2] https://github.com/shadow-maint/shadow/commit/9db6abfa42c946b4046f4b2fe67dc43ba862eb0e
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  README            |  7 +++++--
>  common/config     |  1 +
>  common/rc         | 42 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/381 |  1 +
>  4 files changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/README b/README
> index ed69332e774e..aff7bdae7cb4 100644
> --- a/README
> +++ b/README
> @@ -20,8 +20,11 @@ _______________________
>  - run make
>  - run make install
>  - create fsgqa test user ("sudo useradd fsgqa")
> -- create 123456-fsgqa test user ("sudo useradd 123456-fsgqa")
> -	
> +- Only on systems which allow usernames that start with a digit (older
> +  than  systemd 232 and/or has shadow older than v4.0.1), create the
> +  123456-fsgqa test user:
> +    sudo useradd 123456-fsgqa
> +

IMHO, this doc update is sufficient, generic/381 already _notrun if
there's no 123456-fsgqa user present because of

_require_user 123456-fsgqa

And we don't rely on any version check in fstests, usually we check on
the actual behavior, e.g. actually mkfs & mount the fs to see if the
current kernel and userspace support a given feature.

Thanks,
Eryu
