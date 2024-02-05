Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EBC1CA88
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 13:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707138779; cv=none; b=DlMS3Ak/uil3ktjFozFaew5AVG9N5dSJRqheGO+oXG7p7i/ScLZgrP/dd3JnJxO6/eS+pUcL7bD6Ymj9l79p5HEY+ZCOnhc247KmyEw/l6jWnlJoa0hyTlatIaTxH/VBV4f004rPrDl3V6+kkfyPhS/Q+J2WDvrRjMm2Ff4BV0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707138779; c=relaxed/simple;
	bh=UNk7UeFyh8C16GhOmfEAeGouSEaiTnK7BneyDGIkrk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=imq6vOTW7VWknYp4d+LW8B+sYLuwoum5Pm5ZH8sUPjsCPCX8BseMnU8dy+vb4+ubvLEjYDVIe+d/sFnEQtcXfPj6Gnc0PdvaMugVPvlxjn8+ESyBvTF/4jKV7pfABYVhdbfVcFKUn21C1tXxjHB25AiSib61DYB8EBzVNnOZAbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.31.7] (theinternet.molgen.mpg.de [141.14.31.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id F2C6F61E5FE04;
	Mon,  5 Feb 2024 14:12:43 +0100 (CET)
Message-ID: <39caab25-bf87-4a62-814d-b67f9c81a6e0@molgen.mpg.de>
Date: Mon, 5 Feb 2024 14:12:43 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [QUESTION] zig build systems fails on XFS V4 volumes
Content-Language: en-US
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <1b0bde1a-4bde-493c-9772-ad821b5c20db@molgen.mpg.de>
 <ZcAICW2o5pg7eVlM@dread.disaster.area>
From: Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <ZcAICW2o5pg7eVlM@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/24 22:56, Dave Chinner wrote:
> On Sat, Feb 03, 2024 at 06:50:31PM +0100, Donald Buczek wrote:
>> Dear Experts,
>>
>> I'm encountering consistent build failures with the Zig language from source on certain systems, and I'm seeking insights into the issue.
>>
>> Issue Summary:
>>
>>     Build fails on XFS volumes with V4 format (crc=0).
>>     Build succeeds on XFS volumes with V5 format (crc=1), regardless of bigtime value.
> 
> mkfs.xfs output for a successful build vs a broken build, please!
> 
> Also a description of the hardware and storage stack configuration
> would be useful.
> 
>>
>> Observations:
>>
>>     The failure occurs silently during Zig's native build process.
> 
> What is the actual failure? What is the symptoms of this "silent
> failure". Please give output showing how the failure is occurs, how
> it is detected, etc. From there we can work to identify what to look
> at next.
> 
> Everything remaining in the bug report is pure speculation, but
> there's no information provided that allows us to do anything other
> than speculate in return, so I'm just going to ignore it. Document
> the evidence of the problem so we can understand it - speculation
> about causes in the absence of evidence is simply not helpful....

I was actually just hoping that someone could confirm that the functionality, as visible from userspace, should be identical, apart from timing. Or, that someone might have an idea based on experience what could be causing the different behavior. This was not intended as a bug report for XFS.

But I'm grateful, of course, if you want to look deeper into it.

Through further investigation, I've pinpointed the discrepancy between functional and non-functional filesystems, narrowing it down from "V5 vs. V4" to "ftype=1 vs. ftype=0"

Detailed filesystem configurations and a comparison are available at https://owww.molgen.mpg.de/~buczek/zt/

Included are:

    test.sh: The main script setting up two XFS volumes and initiating the build process using build.sh.
    test.log: The output log from test.sh.
    build.log: Located in xfs_{ok,fail} directories, containing the build process outputs.
    cmp.sh and cmp.log: A script and its output for comparing xfs_ok and xfs_fail directories.

In build.sh there is a test which demonstrated the build failure: "stage3/lib" not produced.  After that test, the command which should produce stage3/lib is run again, this time with strace. The traces are in xfs_{ok,fail}/traces and the whole build directories in xfs_{ok,fail}/zig-0.11.0

There is also a script cmp.sh and its output cmp.log, which compares the xfs_ok and xfs_fail directories. It also produces traces.cmp.txt which is a (width 200) side by side comparison of the strace files.

The outcome has been be replicated across various CPU architectures and kernel versions.

Best regards,

  Donald


> 
> -Dave.

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

