Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F143A5E97
	for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780077732; cv=none; b=SEelRzXUeGlt7KJxPbeajk2tIi7FgCNSL91l7B/wplMtMgm0DCFdBNsaZM3C5XnWGgZygVecEb8i2hzVQ9uIeyGkAeh8j13d3Jular8i99V2D9QDSd0Ly4fo2eAeLlVFffCEoVdZME2mWV7eSFerUdBfetdv/UsOHY+4oBvkC3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780077732; c=relaxed/simple;
	bh=hkLWTJKyDmsMa/Zf0X8aKNnpil9wZCCJ+Ywu5MJQCPE=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Rx8bBnOzm/XBFmJ8nFLyDWjo+D5DZwQ4Q3t2rJgCrxDI9VJvIj9VRzacMQyI8QJyBHvNo2Lo9t8W9AoQunn4AIgI9YKrMtFxcLCElbQvbi10hKUIwgC4W5gPncJdcvcFFGz/c5eJojs83TUosb4+RV9jh+TsEi1DgG1vPXxyU6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 94599180F2C1;
	Fri, 29 May 2026 20:01:55 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id no2DIZPUGWrUAj0AKEJqOA
	(envelope-from <lukas@herbolt.com>); Fri, 29 May 2026 20:01:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 29 May 2026 20:01:55 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
 linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/5] Add option to use default config file.
In-Reply-To: <20260528051040.GH6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
 <20260528051040.GH6078@frogsfrogsfrogs>
Message-ID: <58a188ce948dc7b02da9175ba97e8297@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-05-28 07:10, Darrick J. Wong wrote:
> On Mon, May 25, 2026 at 09:57:47AM +0200, Lukas Herbolt wrote:
>> Hi,
>> Sending a v2 version trying to implement the changes suggested by
>> Carlos, Darrick, Eric and Dave. The default.conf is not installed
>> automatically but there is simple example file.
>> 
>> The order is now build-time < default-file < command line settings.
>> Some values like uuid,sunit,swidth sector size and block size are not
>> allowed to be set in the default config file and if set user is warned
>> about it and the value is reset to build-time default.
>> 
>> I moved setting of some values in cli_params and setting of 
>> mkfs_default_params
>> into new bld_dft struct as If I get it correctly we were basically 
>> setting
>> some of the default values on two places. It also  resulted in cleanup 
>> of
>> unused parameters from some validate_* functions.
> 
> This looks mostly good, but I have a couple of suggestions to improve
> the ergonomics for distributors:
> 
> 1. Make it so that mkfs.xfs itself can spit out a configuration file
> based on the "bld_dft" object.  Then we can always generate the
> "default.conf" file with something as simple as:
> 
> $ mkfs.xfs --write-defaults /root/my.conf
> $ cat /root/my.conf
> [metadata]
> rmapbt=1
> ...
> 
> Obviously this requires some careful thought about what exactly the
> printing function will actually emit -- my guess is that the only 
> things
> worth printing are filesystem features and the default fsxattr values
> that get written into the rootdir, since the device geometry will
> change.

Make sense, but I would then remove the example file, also this comes to 
the
fact while some (HW geometry) stuff are ignored in the default file. I 
would
not allow user to set sector size sunit/swidth from the default file. 
The question
is should we just exit with some info and calling usage() or set it to 
default
and warn about it?

> 
> 2. Make xfs_db/xfs_info emit a similar configuration file based on an
> existing filesystem.  Anyone needing to create many feature-for-feature
> replicas of an existing filesystem will now have a much easier time 
> than
> encoding options into a shell script.
> 
> # xfs_info -c 'writecfg' /my/rad/fs > /root/rad.conf
> # mkfs.xfs -c options=/root/rad.conf /dev/sda
> # mkfs.xfs -c options=/root/rad.conf /dev/sdb
> ...
> 
> (maybe add an xfs_admin option to call xfs_{db,info} too?)
> 
> What do you think?
> 

I guess xfs_{db,info} option which would be used in xfs_admin makes 
sense.
But again here comes a question should we emit exact copy or leave HW
geometry aside?



-- 
-lhe
