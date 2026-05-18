Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9151B48B365
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779113239; cv=none; b=PWSnU5gt9NWuoiC+d+gXxS0IrmN5uxsQrdWR9SFfS2mCOHTFPYN4xBUPnjPUdvlapsA1fIwFaaNnoDPtcZG37aTH7D39SMu2dyGcdCEFi8kBs2PikByvzfc0NAwf5ymgMAolUZEfgj8bilZLSvL/Gz0w+0ahR61bjFUNEaOtRVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779113239; c=relaxed/simple;
	bh=xfCo3mXPLsa8+GeNfd1kwjcXlm7xOefDTnZWDjGbT1A=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=VnC/pDLBJZqfyVkeRXLzu4PsM2YHn2Qx5fjJyxsrdks/hBbqUfNnZoTj345ZnTJcJQrCip5Mdw+rCr3m6oy3GxpfnEvZ1qge+CEVxphflJpNwzvY8rP3AkMzul5pmKI8PblAKygEXIsZkW9KtHdhl8JJEv8aqiH9ZVI67abnyRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id BD7D0180F2C6;
	Mon, 18 May 2026 16:07:02 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id pJ2tKQYdC2rqfy8AKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 18 May 2026 16:07:02 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 18 May 2026 16:07:02 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: Dave Chinner <dgc@kernel.org>
Cc: djwong@kernel.org, sandeen@sandeen.net, aalbersh@kernel.org,
 linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] xfsprogs: mkfs.xfs add default configuration
 file.
In-Reply-To: <agZcSv04h0E1Tu0a@dread>
References: <20260514143716.893814-2-lukas@herbolt.com>
 <20260514143716.893814-3-lukas@herbolt.com> <agZcSv04h0E1Tu0a@dread>
Message-ID: <a798a7f9e94caa7a284e223275faa32e@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

>> +[block]
>> +#size = 4096
> 
> Why do we need a config file that contains all the current defaults
> commented out? We don't do this for the command line conf files we
> ship, so this just seems like unnecessary maintenance overhead to
> me...

That might be unnecessary overhead and we might go just with the
example file placed in /usr/share/

---
# xfs_admin -d /usr/share/xfsprogs/mkfs/lts_6.12.conf
And to reset mkfs behaviour back to built in defaults:
# xfs_admin -d clear
---

>> +
>> +[metadata]
>> +#crc = 1
>> +#finobt = 1
>> +#inobtcount = 1
>> +#rmapbt = 1
>> +#reflink = 1
>> +#bigtime = 1
>> +#metadir = 0
>> +#autofsck = 0
>> +
>> +[inode]
>> +#align = 1
>> +# The default value is 25% for filesystems under 1TB,#5% for 
>> filesystems under
>> +# 50TB and 1% for filesystems over 50TB.
>> +#
>> +#maxpct = 25
>> +#size = 512
>> +#perblock = 8
>> +#attr = 2
>> +#projid32bit = 1
>> +#sparse = 1
>> +#nrext64 = 1
>> +#exchange = 1
>> +
>> +[data]
>> +# -1 = autodetect (use CPU count only on solid-state devices), 0 = 
>> disabled
>> +#concurrency = -1
> 
> Not sure I like this way saying "autotune". This should match the
> existing conf file behaviour to override the default. i.e. 0 turns
> it off, 1 = autodetect, "nr_cpus" = autodetect", any other positive
> value is the minimum concurrency value.
> 
> IMO we should be exactly consistent with the CLI options here so
> that we don't need special parsing code just for the default
> options.
> 
Noted, auto|autodetect is more descriptive than -1.


>> +	if (!cli->cfgfile) {
>> +		/*
>> +		 * No config file specified on the command line. Use the default
>> +		 * system-wide config file if it exists, otherwise do nothing.
>> +		 */
>> +		if (access(MKFS_DEFAULT_CFGFILE, F_OK) != 0)
>> +			return;
>> +		cli->cfgfile = MKFS_DEFAULT_CFGFILE;
>> +	}
> 
> This seems wrong to me. The defaults should always be parsed if the
> default file is present, whilst the CLI conf file should -overlay-
> the defaults like it currently does.
> 
> For example, the system might be set up for on, say 6.12-lts, so
> it's default is lts_6.12.conf. The user then has a custom config
> file for their cloud deployments that need some extra config (e.g.
> turns off rmapbt). i.e. they want all of the 6.12 configs except for
> one.
> 
> Instead of having to craft a config file for all the 6.12 defaults,
> they simple have "rmapbt=0" in a conf file and provide that on the
> CLI. Now they have a mkfs.xfs that defaults to 6.12-lts compatible
> filesystems, and when making their cloud images it simply applies
> a config overlay file via the command line.
> 
> When they upgrade all the systems to, say, 6.19-lts, they don't need
> to rewrite their custom overlay conf file - the system mkfs.xfs now
> defaults to 6.19-lts compatible filesystems, and their overlay conf
> file doesn't need changing. If they still need everything to use
> 6.12 comaptible filesystems, then they change the system default
> conf file, not their cloud-specific conf file.
> 
>> 
>> +	parsing_cfgfile = true;
>>  	error = ini_parse(cli->cfgfile, cfgfile_parse_ini, cli);
>> +	parsing_cfgfile = false;
>>  	if (error) {
>>  		if (error > 0) {
>>  			fprintf(stderr,
> 
> This is not how I envisiaged default config file setup to work for
> mkfs back when I rewrote all the parsing to be able to support
> config files. i.e.
> 
> commit 68344ba0f8cea778919e17958969b6c2459f890a
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Dec 6 17:14:27 2017 -0600
> 
>     mkfs: introduce default configuration structure
> 
>     mkfs has lots of options that require default values. Some of these
>     are centralised, but others aren't. Introduce a new structure
>     designed to hold default values for all the parameters that need
>     defaults in one place.
> 
>     This structure also provides a mechanism for providing mkfs 
> defaults
>     from a config file. This is not implemented in this series, but a
>     comment is left where it is expected this functionality will hook
>     in.
> 
>     Signed-Off-By: Dave Chinner <dchinner@redhat.com>
>     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> That comment is right at the start of the main() function:
> 
>         /*
>          * TODO: Sourcing defaults from a config file
>          *
>          * Before anything else, see if there's a config file with 
> different
>          * defaults. If a file exists in <package location>, read in 
> the new
>          * default values and overwrite them in the &dft structure. 
> This way the
>          * new defaults will apply before we parse the CLI, and the CLI 
> will
>          * still be able to override them. When more than one source is
>          * implemented, emit a message to indicate where the defaults 
> being
>          * used came from.
>          *
>          * printf(_("Default configuration sourced from %s\n"), 
> dft.source);
>          */
> 
>         /* copy new defaults into CLI parsing structure */
>         memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
>         memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
> 
> What the new defaults file code should be doing is parsing the
> defaults file into a new "struct cli_params" structure, then using
> the options parsed from the file to initialise the CLI parsing
> structure. i.e. I had intended the above code to be replaced with
> something like:
> 
> 	struct cli_params file_dfts { ....};
> ....
> 
>         /* Source defaults from a config file if it exists */
> 	file_dfts.config_file = MKFS_DEFAULT_CFGFILE;
>         memcpy(&cli.sb_feat, &file_dfts.sb_feat, sizeof(cli.sb_feat));
>         memcpy(&cli.fsx, &file_dfts.fsx, sizeof(cli.fsx));
> 	cfgfile_parse(&file_dfts);
> 
> 	/* Set up defaults for CLI parsing */
> 	intialise_cli_params(&cli, &file_dfts);
> 
> .....
> 
> and initialise_cli_params() looked something like:
> 
> initialise_cli_params(
> 	*cli,
> 	*default)
> {
>         /* copy feature fields into CLI parsing structure */
>         memcpy(&cli->sb_feat, &default->sb_feat, sizeof(cli->sb_feat));
>         memcpy(&cli->fsx, &default->fsx, sizeof(cli->fsx));
> 
> 	/*
> 	 * Check for parameters we shouldn't set in default conf
> 	 * files. e.g. device specific parameters like sector sizes,
> 	 * sunit/swidth, etc probably shouldn't be set in global
> 	 * default conf files. Warn and clear these parameters.
> 	 */
> 
> 	/*
> 	 * Iterate the parameters found in the default config file
> 	 * and set them as initial values for the CLI parameter
> 	 * parsing. CLI parsing will overwrite these.
> 	 */
> 	<exercise left to the reader>
> }
> 
> Now the CLI and cli conf file parsing should be able to be done
> pretty much as it is currently done. They should override the
> defaults as they currently do, and all existing scripts will behave
> as expected except for mkfs using different system-specified
> defaults.
> 
> -Dave.

Thanks for the example.
I should have read the comments more carefully, so if I get it right
the logic should be: default.file < cli.options < cli.options.file?

Thanks!

-- 
-lhe
