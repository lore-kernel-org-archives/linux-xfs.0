Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75603B776C
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 20:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900061; cv=none; b=uZY+70Uw/MOUwIoLZMvS3Ii6KichXsUpmkVN4APLdOYbvUh4kJEJAV//2wDYqCPorbFERkBXS7AXPNu+Okkxf/07zHlO+KmgAh1yolqMcFHe7LhCxjmsCJVEK7fp5IzTfq9q+elMWPeCqtffQViJ+F3PHggY/9qUwl0E/gZaFmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900061; c=relaxed/simple;
	bh=VeJJLB+63BYurJcXNGrxsF6XEniUptKumTIXqw380NI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RGiJqphS0OBjC/yhoHJqN//51pQluDcA54R82ATMN3VuuioZW1tkyavfJcKG9Izz2VkNgagrlEhrOleSCvORMLDRQLyWHep/bGNKsh8+mUnmlLKwjJTmVbF1aMkrdlFuv6hUaMeSKdx2obUo3Yr/jnXvS/4019F0L54RhJ4Vh90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=KYvFjVGe; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ouDSGWs+; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="KYvFjVGe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ouDSGWs+"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CF6CD7A016A;
	Tue,  8 Sep 2026 16:40:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 08 Sep 2026 16:40:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1788900058;
	 x=1788986458; bh=65lMZ5OMMDsbD7AboNqxbbzrTy76TcVlKx3wtQmLwfw=; b=
	KYvFjVGe/ajiXZG7IMMHf4RIMU6D8KFz+TOhy7ieL3UA5dZSEqlDyC7HP7uD26Fs
	mHmFwH31zzkWtK0x5tDeJgkrC0xEsN0DjeT17xuiR0PYO0EoRCsbxTLhxpaWfQcw
	EOqUzQfWCcwZpLHTTuovMlvjD8PZ4pREVT0ClRYy55vNrTjEj4DrZ7vUK5XgGhvT
	ddr3v9984cjjhAf9NjRVhu0eodu0UEAsAtNEH1/DhR07FbbQrK7R9TZwSEE9l/IK
	2u2xhWcdJeSX5yWJCATCxTmAOGPE+Pe5ZMgqRQdQyr+RrSKBTAy8wciabDRS7uZC
	u82oESykc3QFK4zeUUx1TA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1788900058; x=
	1788986458; bh=65lMZ5OMMDsbD7AboNqxbbzrTy76TcVlKx3wtQmLwfw=; b=o
	uDSGWs+tQv1wgEtGxxLloxrZMkcu9id0ZgHNnDzdrIgnjs3A00ccx+4eSsXUiA6f
	+Lg0nFxOZ7vlKVHd2SB1s9UYVtX4DtUtlqeYL6XQXpZGzXqO4DCGl9XFPzwi2+og
	71U2bjsp2RG3OvgyZu+bdTaXHl9x1v3Qkt4kBpx8r74xi48+S+nw93+zdyYGvWPz
	u87LaqWbDfcNWxmBe+8eLlwLNnNDbuZnWzWjGBWP2fLiZc1xrzNGLmwajnZgU3XM
	AtkS1QDWN6a/wUCqsISsscQpQXlocViXHvdUC7RWnrcFXhhTXSuVZWZ+hQKjmWTC
	cHbFRn1pwHxl4ytyUdy9Q==
X-ME-Sender: <xms:2nKgavR36GrDomy6wUVCUBKf2NK--WW6Ww2uFyxLJqd0JnoW37xSTA>
    <xme:2nKgarVYmvtQMoC_UmQCtwncAEZVpQ71EVpb-XVpGdGoQ-HOgUXbuZCjWjx2VozCH
    Wm6U-R-HO75KH9Fla9dQ1uuYLWt50x0m54manBQzzm1RqPtb73Kz1sU>
X-ME-Received: <xmr:2nKgahZxZmIZo0Sgz399rQ-VlRyPy4w-dGyxZiRkuVr-aTpQRhJr23VSPzUK6T8IyHPbs_N2ItOM79uIawDFQQcx>
X-ME-Proxy-Cause: dmFkZTFWPwUtZrzRz8iHYSV7tHZVPDbuS6MIfOGGp7DaIV5PK02QuPhFVOMWUiMurSlu8D
    /eVeTfFYw4JlUXUG19sFJ6EoQmEa4iKnPpdrPIoETiF5AIXrGzrxFpeTC0+VyewkZTZVob
    hf0F9mU1vffLVwejDoQSUcXB2cMIH/ZjEjcIx4wOP6DygtWKBstfPcNS4sukTg5qMkLEaQ
    80L0KXYbvdaV8WLMfp/JQGkKI/2Ueb6DWpgsTctHT0So8VrLcVQ6WDbWe3QRZS1qHsxjeK
    Hh83ateE9Nu6tpyOMs27D/zF3/aluomvcJXoRjjpnQ7pC3XZ4xy1/y6KyavRYVBkdPqtJi
    VcGege4VAaIHhIK8NjBv+jh2W2TlvheAPJQ/E8IrYAHKAMb2+mtCT4KBUyoLPSeVF8P9tE
    TYzoHaIdY8M7zbSTyBhE7l2XZmTAmO9BiTp16jRy0sP17NHaB30qhMRvV2pzqG2NjzOMI7
    EGaW+aRtzq/WZhN2cqUrE+N64lrbrG6lQqyHjsXiNGAGr3PbmXQm3lI5l3NuIukDc+eEUz
    1PbkIdRioiCs5bbotYH0Xim0ASAYxv5Q5nFCkxCCNEPCSjpVoJlaMfu9uaphtDJlQcw0Aj
    bqtil5hYIRjMn9kb+U1OZmJcVxeNHKU0yBAi8leBvyudUiwA1Q5fYaVp2D7g
X-ME-Proxy: <xmx:2nKgah0gwfB4pFcfOZVCPMXQR6slRAn8_2QPjSjZVT1xbCrE-2SyKg>
    <xmx:2nKgajgIZxQTHwVHnU1C_f8EmKKCz5ZIm5zE54H7zBv1eJ9AnyXUng>
    <xmx:2nKgalbjy-w7h5SF6NoDFPwSbjEbBbf1Z0wLOUV_p0V9GSj4AXAhTQ>
    <xmx:2nKgajT2g0OinPNn9F70gm7VuxiBb1J3E2ICVc8FgLkO-7zLokEIIg>
    <xmx:2nKgajct-58bu1d58E0I9U-OqPbHVSL1Bp_OHUOXBCfh7D55DZ-_6OHS>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 16:40:58 -0400 (EDT)
Message-ID: <3493be44-7f0a-479e-84d4-381b97a4d050@sandeen.net>
Date: Tue, 8 Sep 2026 15:40:57 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfs: add xfs_error_report the ability to display an
 error code
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
References: <20260908145422.232985-1-cem@kernel.org>
 <20260908145422.232985-2-cem@kernel.org>
 <8a9d507c-f060-4f78-9035-5393b633df11@sandeen.net>
 <20260908170205.GG2619314@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260908170205.GG2619314@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/8/26 12:02 PM, Darrick J. Wong wrote:
> On Tue, Sep 08, 2026 at 11:53:57AM -0500, Eric Sandeen wrote:
>> On 9/8/26 9:54 AM, cem@kernel.org wrote:
>>> From: Carlos Maiolino <cem@kernel.org>
>>>
>>> Users could opt to request an error code to be printed now.
>>> This relies on errname() and CONFIG_SYMBOLIC_NAME without requiring it
>>> to be enabled.
>>> Report 'unkown error' If CONFIG_SYMBOLIC_NAME is not enabled or the
>>> user passes 0 as an error.
>>
>> s/SYMBOLIC_NAME/SYMBOLIC_ERRNAME/g
>>
>>> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
>>> ---
>>>  fs/xfs/xfs_error.c         | 13 ++++++++++---
>>>  fs/xfs/xfs_error.h         | 10 +++++-----
>>>  fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
>>>  fs/xfs/xfs_inode_item.c    |  3 ++-
>>>  fs/xfs/xfs_log_recover.c   |  3 ++-
>>>  fs/xfs/xfs_trans.c         |  2 +-
>>>  6 files changed, 26 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
>>> index dbd87e137694..3177ec58bb2e 100644
>>> --- a/fs/xfs/xfs_error.c
>>> +++ b/fs/xfs/xfs_error.c
>>> @@ -14,6 +14,7 @@
>>>  #include "xfs_error.h"
>>>  #include "xfs_sysfs.h"
>>>  #include "xfs_inode.h"
>>> +#include <linux/errname.h>
>>>  
>>>  #ifdef DEBUG
>>>  
>>> @@ -377,15 +378,21 @@ void
>>>  xfs_error_report(
>>>  	const char		*tag,
>>>  	int			level,
>>> +	int			error,
>>>  	struct xfs_mount	*mp,
>>>  	const char		*filename,
>>>  	int			linenum,
>>>  	xfs_failaddr_t		failaddr)
>>>  {
>>> +	const char *err_str = errname(error);
>>> +
>>> +	if (!err_str)
>>> +		err_str = "unknown error";
>>> +
>>>  	if (level <= xfs_error_level) {
>>>  		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
>>> -		"Internal error %s at line %d of file %s.  Caller %pS",
>>> -			    tag, linenum, filename, failaddr);
>>> +		"Internal error %s (%s) at line %d of file %s.  Caller %pS",
>>> +			    tag, err_str, linenum, filename, failaddr);
>> I might suggest making the printk conditional, rather than making err_str conditional.
>>
>> It might make the code messier, but the entire purpose of this change is to give
>> the user more information and a clearer view of what happened. Changing
>> "error 93 at line" to "error 93 (unknown error) at line" doesn't really do that,
>> and IMHO adds confusion and adds no value.
> 
> Oh, something like:
> 
> 	if (level <= xfs_error_level) {
> 		const char	*err_str = errname(error);
> 
> 		if (err_str)
> 			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
>  "Internal error %s (%s) at line...", tag, err_str, ...);
> 		else
> 			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
>  "Internal error %s (%d) at line...", tag, error, ...);
> 	}
> 
> Hm?

Yeah I think so. Messy code but better dmesg IMHO.

> I sorta like having the #define'd error name in the log message (e.g.
> "Internal error frogs (ENOENT) at line..." but tbh these days I just run
> errno(1) to translate an errno to a sentence fragment.
TBH I've lost track of what a tag vs an errno vs a string is, but I stand
by my observation that emitting "unknown error" when errname() returns null
seems like a net negative change. :)

-Eric
