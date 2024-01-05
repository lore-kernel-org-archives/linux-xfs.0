Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4412D63E;
	Fri,  5 Jan 2024 13:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDMBM9ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26794C433C7;
	Fri,  5 Jan 2024 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704462693;
	bh=T4X+lN+P9RONOdyLp2e/BtDkpfreQmJkMg/ZffQYZeg=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=UDMBM9ZVjVWQICKkw4tElbWbS5/Q+dJv88JWHB7jvWC5miUqrJ3TSxSKnCgtKP8er
	 D4zKw7IneY7hnySKJ8eOv2vjwUFAzN9OL3rWFBw/CM3UIGxYDZfeE3ZD2AwwwkbP9w
	 1exSvt973XZ2NGMSmdWRazBnUWLmX5WjYWfVgIJqJcnK/1lQaLZkiHMYGWua2I3RnK
	 uuT8d3SSE2BRSkz4HO3gbWbNrEcJLtbkks5uae0PgQEb4mSVciYCZPIwhBxwaPneJy
	 4q6CFRppuZ+sucSATDECWJyVywsdKJsrILzs5hgAPVu8AZZlLLA3jGXEEY47abgx0w
	 tu9zcVM+8QmCw==
References: <20240102084357.1199843-1-chandanbabu@kernel.org>
 <20240102084357.1199843-3-chandanbabu@kernel.org>
 <20240102182733.GW361584@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 2/5] common/xfs: Add function to detect support for
 metadump v2
Date: Fri, 05 Jan 2024 12:33:11 +0530
In-reply-to: <20240102182733.GW361584@frogsfrogsfrogs>
Message-ID: <878r5351nj.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Jan 02, 2024 at 10:27:33 AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 02, 2024 at 02:13:49PM +0530, Chandan Babu R wrote:
>> This commit defines a new function to help detect support for metadump v2.
>> 
>> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
>> ---
>>  common/xfs | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>> 
>> diff --git a/common/xfs b/common/xfs
>> index 38094828..558a6bb5 100644
>> --- a/common/xfs
>> +++ b/common/xfs
>> @@ -698,6 +698,14 @@ _xfs_mdrestore() {
>>  	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
>>  }
>>  
>> +_scratch_metadump_v2_supported()
>> +{
>> +	$XFS_DB_PROG -c "help metadump" $SCRATCH_DEV | \
>> +		grep -q "Metadump version to be used"
>> +
>> +	return $?
>
> You don't need this; bash will retain the status code of the last
> process in the pipe as the result value.
>
> (Looks good to me otherwise.)
>

Ok. I will fix it up.

>> +}
>> +
>>  # Snapshot the metadata on the scratch device
>>  _scratch_xfs_metadump()
>>  {
>> -- 
>> 2.43.0
>> 
>> 


-- 
Chandan
