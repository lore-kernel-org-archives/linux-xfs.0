Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48342 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755071AbeFNQk7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 12:40:59 -0400
Subject: Re: [PATCH 2/2] mkfs: remove notion of config "type"
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <8c2a5a07-5d47-48a1-1593-e93eb0fb883a@sandeen.net>
 <20180614161917.GA7508@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a327732b-b5ce-2fd2-0aa3-309d75c80675@sandeen.net>
Date: Thu, 14 Jun 2018 11:40:57 -0500
MIME-Version: 1.0
In-Reply-To: <20180614161917.GA7508@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 6/14/18 11:19 AM, Luis R. Rodriguez wrote:
> On Wed, Jun 13, 2018 at 02:37:01PM -0500, Eric Sandeen wrote:
>> -static inline const char *default_type_str(enum default_params_type type)
>> -{
>> -	switch (type) {
>> -	case DEFAULTS_BUILTIN:
>> -		return _("package built-in definitions");
>> -	case DEFAULTS_CONFIG:
>> -		return _("package default config file");
>> -	case DEFAULTS_CLI_CONFIG:
>> -		return _("CLI supplied file");
>> -	}
>> -	return _("Unkown\n");
>> -}
> 
>>  
>> -	printf(_("Default configuration sourced from %s\n"),
>> -	       default_type_str(dft.type));
> 
> The above is really the reason to the type stuff, and it was also why
> I added it, as otherwise we had to allocate a string for the old way of
> supplying that data. So really this is about the *source*, the type enum
> stuff is just a way to implement it without dealing with complexities
> on the string.
> 
> So regardless of the type, the question is we are OK to loose the source
> of where the config file info came from.

But we're not losing that; mkfs now says:

# mkfs.xfs -f -c myconfig /dev/sdb1 
Configuration file used for defaults: /etc/xfs/mkfs/myconfig
...

or

# mkfs.xfs -f /dev/sdb1 
Configuration file used for defaults: /etc/xfs/mkfs/default
...

so it explicitly tells the user what the source of defaults is.

I didn't see the point to telling the user "you used a commandline option so we
used your commandline option" after they typed a command line option.  ;)

> I think it is important information
> to get, but since it is not not information kept on the actual filesystem it is
> information lost, and so really only useful for deployment time. But since
> we are already printing the actual file used... it may suffice, and I do
> agree I this does simplify things more.
> 
> Chinner had added that print line, I just tried to keep it around, if he's cool
> with the removal of the source stuff now, then sure.

ok.

Thanks,
-Eric
 
>   Luis
> 
