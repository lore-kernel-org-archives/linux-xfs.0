Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751185AbdCPXdk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 19:33:40 -0400
Date: Fri, 17 Mar 2017 00:20:00 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 14/22] mkfs: rename defaultval to flagval in opts
Message-ID: <20170316232000.GW28800@wotan.suse.de>
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170315160017.27805-15-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170315160017.27805-15-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 15, 2017 at 05:00:09PM +0100, Jan Tulak wrote:
> The old name 'defaultval' was misleading - it is not the default value,
> but the value the option has when used as a flag by an user.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -189,7 +189,7 @@ unsigned int		sectorsize;
> @@ -223,7 +223,7 @@ struct opt_params {
>  		}		conflicts [MAX_CONFLICTS];
>  		long long	minval;
>  		long long	maxval;
> -		long long	defaultval;
> +		long long	flagval;

David suggested that in the future the config value(mkfs.xfs.conf) will override
the defaultval, in this case since you are renaming this, just want to be sure
the new name we choose can fit its later use also with the config. Perhaps
userval ?

  Luis
