Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9091A13C66F
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 17:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723050906; cv=none; b=It56Lvbb6m0jgBLud/teOwXH38yLLa0kmKHLgq/j+LzUJExWpqvDBCZ+4SZcMMNl+zq2fMCvh2+5EhpP/Fz2RW1oOY3HR/Au9Ed80llzZgPNZ+ADpukPlFBSgk/wxZHu9uyFdAoP5oV7nKUiz7W2bqmlD3gH7ex37B4nl1ESb/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723050906; c=relaxed/simple;
	bh=6seDGBuy3lllddGh1Odm/wKKIDwwINFGaxNf3YszI+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EXKCpARRLeFKy0pX+HoXAUo8gK2bXUKlv8wowRVlHUiwBI9/1EzUbrFzKb71K0SWzOOQXmcLCVP+m7+SE90SZFCFmJUc0St0WG6DFjAX+eckqR4N3385j/IAN23tfUjzYF/AdiJAC+R8A4b1mA+udnfzuRYjeoQqV6d0BNmmvCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=GZ5hzzs/; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="GZ5hzzs/"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9577A5CE9C4;
	Wed,  7 Aug 2024 12:07:38 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 9577A5CE9C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1723050458;
	bh=tsDmOa3Mk86Iu7vurKCtpr8tQYTHB9bzHAmOVLMqL0c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GZ5hzzs/gbW7b20uAmNuaT8LyMiz6OqkbdxJpnqu8UsbO0oJHd+DqXdA+Ie7fyddJ
	 AvVzHHUc+QE8Tzly4C2NrcPXPCa9NkCZ9Q39co4vZt6xGWVF4ISoePlV9cCTKswmIQ
	 NfAgbz8gDHtdKlrozmVfbonxWG8vTvKh/PqqWRl7wD0/p37G2ak/sO+hC2xdh/24Az
	 5x5bIRcoEmd4BwgItAmH/eYxQqfoinDT5S71B7ZH11TlFyY3Oxri8D0w0PF4kY7ltB
	 X2i9K1GyJ+jiG8FpxinFZRbyYjyC1neQywOGLG2vxdgA/+ZSYoKicNNuCfVEcdIMlj
	 oDrAqn9iE9/lA==
Message-ID: <40fa60fa-b7f0-40c8-87d6-c083b028c6c2@sandeen.net>
Date: Wed, 7 Aug 2024 12:07:37 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_db: release ip resource before returning from
 get_next_unlinked()
To: Bill O'Donnell <bodonnel@redhat.com>, "Darrick J. Wong"
 <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
References: <20240802222552.64389-1-bodonnel@redhat.com>
 <20240802232300.GK6374@frogsfrogsfrogs> <ZrDkx1gFEGDCvUmS@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <ZrDkx1gFEGDCvUmS@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/5/24 9:42 AM, Bill O'Donnell wrote:
> On Fri, Aug 02, 2024 at 04:23:00PM -0700, Darrick J. Wong wrote:
>> On Fri, Aug 02, 2024 at 05:25:52PM -0500, Bill O'Donnell wrote:
>>> Fix potential memory leak in function get_next_unlinked(). Call
>>> libxfs_irele(ip) before exiting.
>>>
>>> Details:
>>> Error: RESOURCE_LEAK (CWE-772):
>>> xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
>>> xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
>>> xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
>>> #   74|   	libxfs_buf_relse(ino_bp);
>>> #   75|
>>> #   76|-> 	return ret;
>>> #   77|   bad:
>>> #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
>>>
>>> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
>>> ---
>>>  db/iunlink.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/db/iunlink.c b/db/iunlink.c
>>> index d87562e3..3b2417c5 100644
>>> --- a/db/iunlink.c
>>> +++ b/db/iunlink.c
>>> @@ -72,6 +72,7 @@ get_next_unlinked(
>>>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
>>>  	ret = be32_to_cpu(dip->di_next_unlinked);
>>>  	libxfs_buf_relse(ino_bp);
>>> +	libxfs_irele(ip);
>>
>> I think this needs to cover the error return for libxfs_imap_to_bp too,
>> doesn't it?
> 
> I considered that, but there are several places in the code where the
> error return doesn't release the resource. Not that that's correct, but the
> scans didn't flag them. For example, in bmap_inflate.c, bmapinflate_f()
> does not release the resource and scans didn't flag it.

Upstream coverity scan does flag it, CID 1554242 (that CID actually covers
both instances of the leak).

-Eric

> Thanks-
> Bill
> 
> 
>>
>> --D
>>
>>>  
>>>  	return ret;
>>>  bad:
>>> -- 
>>> 2.45.2
>>>
>>
> 
> 

