Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403249;
	b=Au+uccImHo/1/koOQgqyzH1X9Us9dbKabyTX0DIq90YkGK9aeHA7KTnEoL81QfW7YK4M
	 Mk9+uWKz0KGqwPn1TbLeN6RPuMIKUOVBTE7Rf/7B+Wv2EbqTJlZpg2oS4e5X3ApKp60Yj
	 mB++fdNZPar8w/BcQK/iarxy07qQUPu1YeFvJqiNGLg+9p1WZ1oaM39uC+oLu6+ufvaHI
	 baB62li1qTj4c4P7yX1q6yYkRu5Em8lkuPdIvVIR2mkVJlKJ9OAjVOqmCWmnScOWsZNWL
	 9TuWHu4Ei2TrXD/wCF7pYJ4IcZetxnvmtFa991upsCqeT+4U6P5vGkwkS23eVd4+Jsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403249;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=eyDqS/O3c0kqK8TrfNnSDeEA8RqYuMsPMyYIE/Q0Xfo=;
	b=miti/4tqN0hzh317PPqeaUGLj5QkhPNEislZYFDyqRFioTPeLlAOoguwN/QYpd/ZNkQD
	 1iFAV6SAQbvuk2OuW72t3MxZwCV0A5HxdaUKiMGDK26vWdmXwDLq1g5TC4sZAWWaa4ygX
	 GbTRBIN/Y4s1YSKwllTypYijqbwsebVDi9tYF3irIHBxSCoRgNXHP98rArybeIn3ezTU4
	 2dUHkU92m5niVJ4xStma1yi/c1DgjNkhByu9hHRT7i3yPOVh7yNVfVj4Z69BxTFbld6pd
	 YAgd0oPXXwdSYWEcqLD316VjPQhEZPM5FJ9P1TliVdiFf1qzqqWzusau7MFHyg/TIyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=jFJwHuZ1;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF5E606A333;
	Mon, 23 Nov 2026 03:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEF5E606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=jFJwHuZ1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=eyDqS/O3c0kqK8TrfNnSDeEA8RqYuMsPMyYIE/Q0Xfo=;
	b=jFJwHuZ1HFJzl9OR+ovjErymF3nyLSyzvVZ3QHhK32cktbkWzxOB7p3Jqgj1/Y
	e91Ij7P/Tio3xYvwi3AhlsptEchbUgiH9N6uNS0qHVBBiPwo3pDqePHrZFCzu/Hm
	thZXLMr9tzJeFjqEFQx8umJRX3NLKOIAUmTCaXdwwwfLk=
Received: from [IPV6:2409:8900:1fd4:b208:1e0e:657f:3fe8:68fc] (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgB3lRyyrQNr7GOJHA--.54075S2;
	Mon, 23 Nov 2026 11:06:29 +0800 (CST)
Message-ID: <6d054adc-5b6d-4a1c-b9e5-b32916e06abe@163.com>
Date: Mon, 23 Nov 2026 11:06:26 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Hyunchul Lee <hyc.lee@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>,
 Andrey Albershteyn <aalbersh@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>,
 Dave Chinner <dgc@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev,
 linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-4-koray.fra@gmail.com>
 <1ebbb85f-3515-4c45-a850-8039aad93800@163.com>
 <DN265Y2EAGQV.1ZD49JSIDMME5@gmail.com>
Content-Language: en-US
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <DN265Y2EAGQV.1ZD49JSIDMME5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgB3lRyyrQNr7GOJHA--.54075S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Wr48Gr18Zw4Duryrury7trb_yoW3Gw48p3
	95CF4jkay8Jry3Can2q3ZIgayFvr4fCF4UZFy5tF18ZF9xtrn3W3ykKryfKFyUursakw1U
	Way2v39xCrW3Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UZiSLUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6hU0-msDrbVSSQAA3e



在 2026/11/23 08:38, koraynilay 写道:
> On Sun Nov 22, 2026 at 1:49 PM CET, liubaolin wrote:
>>
>>
>> 在 2026/11/22 08:08, koraynilay 写道:
>>> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
>>> modern xflags (FS_XFLAG_*) fileattr API with masks.
>>>
>>> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT and add them to
>>> FS_XFLAG_COMMON (and add FS_COMPR_FL and FS_ENCRYPT_FL to FS_COMMON_FL)
>>> to be used in this API switch.
>>>
>>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
>>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>>> ---
>>>    fs/file_attr.c           |  8 +++++
>>>    fs/ntfs/file.c           | 63 +++++++++++++++++++---------------------
>>>    include/linux/fileattr.h |  6 ++--
>>>    include/uapi/linux/fs.h  |  2 ++
>>
>> Hi koraynilay,
>>      One suggestion on the patch split: would it make sense to put the
>> new COMPR/ENCRYPT xflags and their VFS handling in a separate patch
>> before the NTFS conversion?
>>      The changes to include/uapi/linux/fs.h, include/linux/fileattr.h
>> and fs/file_attr.c introduce generic fileattr support, and the
>> COMMON mask changes also affect other filesystems.
>>      Keeping those changes together in a VFS patch would make the API
>> and compatibility aspects easier to review.
>>      The following NTFS patch could then focus on using the new flags
>> while preserving the existing NTFS behaviour.
> 
> Hi Baolin and thanks for the feedback,
> for now I put them in the same patch since they're not many lines of
> code changes, but I now also had to add NOCOMP, maybe I'll split it in
> the next version.
> 
>> Thanks,
>> Baolin.
>>
>>>    4 files changed, 44 insertions(+), 35 deletions(-)
>>> [...]
>>>    	if (err)
>>>    		return err;
>>>    
>>> -	if (fileattr_has_fsx(fa))
>>> -		return -EOPNOTSUPP;
>>> -
>>> -	/* chattr passes the unchanged read-only flags back to us too. */
>>> -	if (NInoCompressed(ni) || NInoWofCompressed(ni))
>>> -		readonly |= FS_COMPR_FL;
>>> -	if (NInoEncrypted(ni))
>>> -		readonly |= FS_ENCRYPT_FL;
>>> -	if ((fa->flags ^ readonly) & (FS_COMPR_FL | FS_ENCRYPT_FL))
>>> -		return -EOPNOTSUPP;
>>> -	allowed |= readonly;
>>> -
>>> -	/* Case folding is a read-only, mount-wide property. */
>>> -	if (!NVolCaseSensitive(ni->vol))
>>> -		allowed |= FS_CASEFOLD_FL;
>>> -	if (fa->flags & ~allowed)
>> Hi koraynilay,
>>      There is another case worth keeping in mind when replacing this check:
>>      fileattr_fill_flags() only translates a subset of FS_*_FL bits,
>> so some unsupported flags will not appear in fsx_xflags.
>>     For example, a direct SETFLAGS request containing only FS_NOCOW_FL
>> produces fsx_xflags == 0. On a normal file on a case-sensitive mount,
>> the new check would accept that request.
>>     If the file already has persistent NODUMP set, the request would also
>> clear it, since the setter rebuilds linuxflags without NODUMP and writes
>> it back to the EA. The current code rejects the request and leaves the
>> existing attributes unchanged.
>>
>>     Would it be possible to keep validating fa->flags when flags_valid is
>> set, in addition to the xflags check?
> 
> We could, but the objective is to have filesystems that implement the
> new _masks API use only xflags.

Hi koraynilay,
    That makes sense, and I'm fine with NTFS using only xflags.
Could we still make sure that legacy SETFLAGS requests with flags 
unsupported by NTFS are rejected rather than silently accepted after 
conversion?

Thanks,
Baolin.

> 
>> Thanks,
>> Baolin.
>>
>>
>>> +	/*
>>> +	 * When userspace uses file_[gs]etattr(), VFS already checks and fails
>>> +	 * with -EOPNOTSUPP if rw_mask & ro_mask != 0 and rw_mask & ~allowed,
>>> +	 * but for FS_IOC_SETFLAGS and FS_IOC_FSSETXATTR VFS can't check for
>>> +	 * allowed flags as these ioctls don't support fsx_xflags_{rw,ro}_mask,
>>> +	 * so we need to check for unsupported flags anyway.
>>> +	 */
>>> +	if (!fa->has_masks &&
>>> +	    ((fa->fsx_xflags & ~NTFS_RW_XFLAGS) ||
>>> +	     fa->fsx_extsize || fa->fsx_projid || fa->fsx_cowextsize))
>>>    		return -EOPNOTSUPP;
>>
>> Hi koraynilay,
>>      Could we keep the existing handling of read-only attributes
>> for legacy SETFLAGS callers here?
>>      On a case-insensitive NTFS mount, the VFS carries over
>> FS_XFLAG_CASEFOLD from the current attributes, since it is not in
>> FS_XFLAG_COMMON.
>> This check would then reject it because CASEFOLD is not in
>> NTFS_RW_XFLAGS, so even chattr +d would fail with EOPNOTSUPP.
>>      The unchanged COMPR/ENCRYPT bits that chattr reads with GETFLAGS and
>> passes back with SETFLAGS would also be rejected on compressed/encrypted
>> files.
>>      Allowing those existing read-only attributes to be passed back
>> unchanged  would let users continue setting and clearing the persistent
>> flags through chattr,as they can today.
>>
>> Thanks,
>> Baolin.
> 
> Since I wasn't quite satisfied with this version, I'm working on a
> revisited v2, that is hopefully cleaner and fixes these bugs and the
> ones reported by sashiko.
> 
> Thanks,
> koraynilay
> 
> 
>>>    
>>>    	forced_immutable = ntfs_is_forced_immutable(vi);
>>> -	if (!(fa->flags & FS_IMMUTABLE_FL) && forced_immutable)
>>> +	if (!(fa->fsx_xflags & FS_XFLAG_IMMUTABLE) && forced_immutable)
>>>    		return -EPERM;
>>>    
>>> -	if (fa->flags & FS_IMMUTABLE_FL) {
>>> +	if (fa->fsx_xflags & FS_XFLAG_IMMUTABLE) {
>>>    		new_fl |= S_IMMUTABLE;
>>>    		/* Do not persist an immutable bit derived from the mount. */
>>>    		if (!forced_immutable ||
>>>    		    (ni->linuxflags & NTFS_LINUXFLAGS_IMMUTABLE))
>>>    			linuxflags |= NTFS_LINUXFLAGS_IMMUTABLE;
>>>    	}
>>> -	if (fa->flags & FS_APPEND_FL) {
>>> +	if (fa->fsx_xflags & FS_XFLAG_APPEND) {
>>>    		new_fl |= S_APPEND;
>>>    		linuxflags |= NTFS_LINUXFLAGS_APPEND;
>>>    	}
>>> -	if (fa->flags & FS_NODUMP_FL)
>>> +	if (fa->fsx_xflags & FS_XFLAG_NODUMP)
>>>    		linuxflags |= NTFS_LINUXFLAGS_NODUMP;
>>> -	if (fa->flags & FS_NOATIME_FL) {
>>> +	if (fa->fsx_xflags & FS_XFLAG_NOATIME) {
>>>    		new_fl |= S_NOATIME;
>>>    		linuxflags |= NTFS_LINUXFLAGS_NOATIME;
>>>    	}
>>> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
>>> index 4faa40febf11..219e7c8eb601 100644
>>> --- a/include/linux/fileattr.h
>>> +++ b/include/linux/fileattr.h
>>> @@ -7,12 +7,14 @@
>>>    #define FS_COMMON_FL \
>>>    	(FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
>>>    	 FS_NODUMP_FL |	FS_NOATIME_FL | FS_DAX_FL | \
>>> -	 FS_PROJINHERIT_FL | FS_VERITY_FL)
>>> +	 FS_PROJINHERIT_FL | FS_VERITY_FL | FS_COMPR_FL | \
>>> +	 FS_ENCRYPT_FL)
>>>    
>>>    #define FS_XFLAG_COMMON \
>>>    	(FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
>>>    	 FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
>>> -	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
>>> +	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_COMPR | \
>>> +	 FS_XFLAG_ENCRYPT)
>>>    
>>>    /* Read-only inode flags */
>>>    #define FS_XFLAG_RDONLY_MASK \
>>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>>> index e40806b3a69c..09fc7e066485 100644
>>> --- a/include/uapi/linux/fs.h
>>> +++ b/include/uapi/linux/fs.h
>>> @@ -275,6 +275,8 @@ struct file_attr {
>>>    #define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
>>>    
>>>    #define FS_XFLAG_PROJID		0x00100000	/* project ID */
>>> +#define FS_XFLAG_COMPR		0x00200000	/* Compress file */
>>> +#define FS_XFLAG_ENCRYPT	0x00400000	/* Encrypted file */
>>>    #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>>>    
>>>    /* the read-only stuff doesn't really belong here, but any other place is
> 

