Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42573 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964834AbeFNQTS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 12:19:18 -0400
Date: Thu, 14 Jun 2018 18:19:17 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/2] mkfs: remove notion of config "type"
Message-ID: <20180614161917.GA7508@wotan.suse.de>
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <8c2a5a07-5d47-48a1-1593-e93eb0fb883a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c2a5a07-5d47-48a1-1593-e93eb0fb883a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jun 13, 2018 at 02:37:01PM -0500, Eric Sandeen wrote:
> -static inline const char *default_type_str(enum default_params_type type)
> -{
> -	switch (type) {
> -	case DEFAULTS_BUILTIN:
> -		return _("package built-in definitions");
> -	case DEFAULTS_CONFIG:
> -		return _("package default config file");
> -	case DEFAULTS_CLI_CONFIG:
> -		return _("CLI supplied file");
> -	}
> -	return _("Unkown\n");
> -}

>  
> -	printf(_("Default configuration sourced from %s\n"),
> -	       default_type_str(dft.type));

The above is really the reason to the type stuff, and it was also why
I added it, as otherwise we had to allocate a string for the old way of
supplying that data. So really this is about the *source*, the type enum
stuff is just a way to implement it without dealing with complexities
on the string.

So regardless of the type, the question is we are OK to loose the source
of where the config file info came from. I think it is important information
to get, but since it is not not information kept on the actual filesystem it is
information lost, and so really only useful for deployment time. But since
we are already printing the actual file used... it may suffice, and I do
agree I this does simplify things more.

Chinner had added that print line, I just tried to keep it around, if he's cool
with the removal of the source stuff now, then sure.

  Luis
