Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64485B21A
	for <linux-xfs@vger.kernel.org>; Sun, 26 Apr 2026 06:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777184934; cv=none; b=cLGTofV6++oC5SP48md6bgG+ZaYkYRFj7zC3bkc7LI6d0okI8ZSQRem5ZRelz1DXhW33SVDtF/WVJC18oc+ou3q0rNJGFMMhFTgiEe9cKLBmYcqcCnH9+hkfMa8rn+/MdpWH9OvlWsed/+sIzUSFnLHvKN3yQIkl0fI3Op05Rls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777184934; c=relaxed/simple;
	bh=GKc5fn8cAxo8vOQ+6BrowLOsE4kaG2euF9Gx/fTWt4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t8KWw44HCoxUl68ngE4hzdCLjZtYReqgaXCREP3g4pcE4kcBN7hpOr7Oa+j7/CdgIIQ/ROIop02SpW4T1dt1cjAAt7GrCAF0r7SaXfkf/P7N6MlB5XvesJaYVmgyLGqOMAaEZ54Nhfo3AKAGz9meVH03yyiRoAW9t3A38QS24kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oeKpelTn; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oeKpelTn"
Message-ID: <4315ac3f-cf0b-484b-a925-0e539a1bfff2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777184930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JecWUIgfgo7vZ7f5H1X7xSHgikkXOcpBTnzxsEo47VM=;
	b=oeKpelTn3SEdQjNofPzNjchTQ282h8U4yiWj96kKTabjaqhLGJO1yla4fwHjol7GfJhrjs
	1DdV08Xq6QbhqhdTo0VAKLsO7wYZ0lM2VodBO1TJb/KlpwBvjOd8oN33HFCoUINhD+XVSj
	4p73a/VbMHkjnUqcnOtXlyQi+jrkEto=
Date: Sun, 26 Apr 2026 08:28:42 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/3] xfs: add a sysfs entry to enable write zeroes even
 if HW does not support it
To: Christoph Hellwig <hch@infradead.org>,
 Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
 "Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
 gost.dev@samsung.com, andres@anarazel.de, kundan.kumar@samsung.com,
 cem@kernel.org
References: <20260420105539.3644999-1-p.raghav@samsung.com>
 <20260420105539.3644999-4-p.raghav@samsung.com>
 <aet1u528eM5jQyCG@infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aet1u528eM5jQyCG@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 4/24/26 15:52, Christoph Hellwig wrote:
> On Mon, Apr 20, 2026 at 12:55:39PM +0200, Pankaj Raghav wrote:
>> From: Lukas Herbolt <lukas@herbolt.com>
>>
>> Add a xfs sysfs entry that will not return ENOTSUPP for
>> FALLOC_FL_WRITE_ZEROES flag in fallocate even if the hardware does not
>> support deallocate on write zeroes. This is useful for testing this
>> feature independent of the HW underneath.
> 
> I don't think it is.  We can easily test this using a loop or scsi_debug
> device.  And in fact should by adding an xfstests that uses such
> synthetic devices.
> 

This makes sense. Also this avoids adding hardware specific knobs in the filesystem.

--
Pankaj
