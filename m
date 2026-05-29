Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC31397E91
	for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 18:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780077974; cv=none; b=qosODZXW/h1PdELfVSeR77ywpefNeK60I970xz+TxUhqXe2irebTAyTXXn3ZJ+0mOuoXPRpzvPWDkJCx0+ps9NI0YQyTALnk/nzgExD0FmxZ2cE5ZZkLAEyurs/7h5gneZuBgGceRqEB7vBSJ3g9wNKt+0/Chsd7437J14n9wTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780077974; c=relaxed/simple;
	bh=T8xyhWPp+JKHwKStTi3CP0yDHF4ZB9nlismtm2Uhc/c=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=TnilV6+tY0hyAJg8CwphzuxJvfqCJphSjZU8xfcU4erDDQAsqk6dbgDmhPXnyVRYuEiWWvQd2F9CeoBz+Ho8PLNV1QCLJio8pi3EnZ54BhFyFy5Zr9ZZwb7pIVRdfxOD7LvutJ5ByUUIRFIXqFNiAHPJFD9rl0ipCbwEsn8ZOwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id B4D3B180F2C1;
	Fri, 29 May 2026 20:06:08 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id 0fZ4KZDVGWp8Az0AKEJqOA
	(envelope-from <lukas@herbolt.com>); Fri, 29 May 2026 20:06:08 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 29 May 2026 20:06:08 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
 linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/5] xfsprogs: mkfs.xfs add default configuration
 file.
In-Reply-To: <20260528045653.GD6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
 <20260525075752.4159504-3-lukas@herbolt.com>
 <20260528045653.GD6078@frogsfrogsfrogs>
Message-ID: <0d22256726d82e3e4d0c91e9b15bd2af@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-05-28 06:56, Darrick J. Wong wrote:
> On Mon, May 25, 2026 at 09:57:49AM +0200, Lukas Herbolt wrote:
>> Various users may prefer different default values. Having a default 
>> config
>> file will allow them to utilize it without the need specifying 
>> configuration
>> file on command line. The behavior is: build time options are 
>> overwritten
>> by the default config file and this options can be overwritten either 
>> by
>> command line options or by config file.
>> 
>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>> ---
>>  include/builddefs.in      |   1 +
>>  mkfs/Makefile             |   2 +
>>  mkfs/default.conf.example |  10 ++++
>>  mkfs/xfs_mkfs.c           | 113 
>> ++++++++++++++++++++++++++++++++------
>>  4 files changed, 108 insertions(+), 18 deletions(-)
>>  create mode 100644 mkfs/default.conf.example
>> 
>> diff --git a/include/builddefs.in b/include/builddefs.in
>> index 3b52d1afd703..bafea70af8ea 100644
>> --- a/include/builddefs.in
>> +++ b/include/builddefs.in
>> @@ -59,6 +59,7 @@ PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
>>  PKG_LOCALE_DIR	= @datadir@/locale
>>  PKG_DATA_DIR	= @datadir@/@pkg_name@
>>  MKFS_CFG_DIR	= @datadir@/@pkg_name@/mkfs
>> +MKFS_SYSCFG_DIR = @sysconfdir@/mkfs.xfs.d
>>  PKG_STATE_DIR	= @localstatedir@/lib/@pkg_name@
>> 
>>  
>> XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP=$(PKG_STATE_DIR)/xfs_scrub_all_media.stamp
>> diff --git a/mkfs/Makefile b/mkfs/Makefile
>> index fb1473324cde..468d2ab7896e 100644
>> --- a/mkfs/Makefile
>> +++ b/mkfs/Makefile
>> @@ -11,6 +11,7 @@ XFS_PROTOFILE = xfs_protofile.py
>>  HFILES =
>>  CFILES = proto.c xfs_mkfs.c
>>  CFGFILES = \
>> +	default.conf.example \
>>  	dax_x86_64.conf \
>>  	lts_4.19.conf \
>>  	lts_5.4.conf \
>> @@ -21,6 +22,7 @@ CFGFILES = \
>>  	lts_6.12.conf \
>>  	lts_6.18.conf
>> 
>> +LCFLAGS += -DMKFS_CFG_DIR=\"$(MKFS_CFG_DIR)\" 
>> -DMKFS_SYSCFG_DIR=\"$(MKFS_SYSCFG_DIR)\"
>>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
>>  	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
>>  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
>> diff --git a/mkfs/default.conf.example b/mkfs/default.conf.example
>> new file mode 100644
>> index 000000000000..ab418eab000d
>> --- /dev/null
>> +++ b/mkfs/default.conf.example
>> @@ -0,0 +1,10 @@
>> +# Default config file example.
>> +#[metadata]
>> +#bigtime=1
>> +#crc=1
>> +
>> +#[inode]
>> +#sparse=1
>> +
>> +#[naming]
>> +#parent=1
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 349afe65c9fc..bff7d078901c 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -44,6 +44,11 @@
>>   */
>>  #define WHACK_SIZE (128 * 1024)
>> 
>> +/*
>> + * Default configuration file which can keep distro specific values.
>> + */
>> +#define MKFS_DEFAULT_CFGFILE   MKFS_SYSCFG_DIR "/default.conf"
>> +
>>  /*
>>   * XXX: The configured block and sector sizes are defined as global 
>> variables so
>>   * that they don't need to be passed to getnum/cvtnum().
>> @@ -5800,7 +5805,8 @@ cfgfile_parse(
>>  		}
>>  		exit(1);
>>  	}
>> -	printf(_("Parameters parsed from config file %s successfully\n"),
>> +	if  (strcmp(cli->cfgfile, MKFS_DEFAULT_CFGFILE) != 0)
> 
> No need   ^^ for double spaces here.
> 
>> +		printf(_("Parameters parsed from config file %s successfully.\n"),
>>  		cli->cfgfile);
>>  }
>> 
>> @@ -5953,6 +5959,75 @@ check_rt_meta_prealloc(
>>  	mp->m_finobt_nores = false;
>>  }
>> 
>> +static void
>> +check_ignored_opt(
>> +	struct cli_params	*dflt,
>> +	const char		*section,
>> +	const char		*key)
>> +{
>> +	bool need_warn = false;
>> +	if (strcmp(section, "metadata") == 0 && strcmp(key, "uuid") == 0) {
>> +		if (!platform_uuid_is_null(&dflt->uuid)) {
>> +			platform_uuid_clear(&dflt->uuid);
>> +			need_warn = true;
>> +		}
>> +	}
>> +
>> +	if (strcmp(section, "data") == 0) {
>> +		if (strcmp(key, "sunit") == 0 || strcmp(key, "su") == 0) {
>> +	                dflt->dsunit = 0;
>> +	                dflt->dsu = NULL;
>> +                        need_warn = true;
> 
> Weird indenting here...
> 
>> +		}
>> +
>> +		if (strcmp(key, "swidth") == 0 || strcmp(key, "sw") == 0) {
>> +			dflt->dswidth = 0;
>> +			dflt->dsw = 0;
>> +			need_warn = true;
>> +		}
>> +	}
>> +
>> +	if (strcmp(section, "sector") == 0 && strcmp(key, "size") == 0) {
>> +			dflt->sectorsize = XFS_MIN_SECTORSIZE;
>> +                        need_warn = true;
> 
> ...and here...
> 
>> +	}
>> +
>> +	if (strcmp(section, "block") == 0 && strcmp(key, "size") == 0) {
>> +			dflt->blocksize  = 1 << XFS_DFL_BLOCKSIZE_LOG;
>> +                        need_warn = true;
> 
> ...and here.
> 
>> +	}
>> +
>> +	if (need_warn)
>> +		fprintf(stderr,
>> +		_("'%s' in section '%s' ignored in default config file\n"),
>> +		key, section);
>> +}
> 
> Why do the disk geometry options get a specific warning vs. all the
> other parameters that one might set in the defaults config file and 
> then
> override?
> 
Mostly motivated by Dave's reply. I think we should just inform the user
that some things cannot be set in the default file, but that's for 
discussion.

Thank you for indentation fixes!
-- 
-lhe
