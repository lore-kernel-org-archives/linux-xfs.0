Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F07C6F06B;
	Mon, 30 Dec 2024 02:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735526589; cv=none; b=iXsovd02/bxmJ8w6axx2Dd4BHiCtP7so1DikjaZcG5gj/CN6Mgd5nuqZlSSXFFWGF+/iYYaorXrzdSIVMvGxcNM75Lh7VjHRmAwtG72Jm2PmWEfNCs/o2SVsNVbsWRmqmxPGXmuMAQDOPYskYFNl6KDgG6fPIh3OHg8hMvVYzpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735526589; c=relaxed/simple;
	bh=j9UPxJlpvxPHHozK/j1OcuSI311/PUsDOa01WO2oMok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FCNmQAfT/BlYlsKhAJ4GBKTv6oTOabN4l1mJyrDpjpXHf9GzwycUtRWbTxNwtLLt3XPqfnvqcYhmhjjIytUJucPEwfyCxDIs1eRMH51PIcwF/g86Pcx/Y5UIMr7a/U4ZFuOFuwFeXw08728LAErVMxxhEzkzESckcBS8fDwJ3Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZmT/qmFo; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZmT/qmFo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=Tq9GnCMNnxG1WV8S5jNZPc+dC713oXnisAqmZ/wwyR0=;
	b=ZmT/qmFoDVCFYJym51NVnbUEWPOGHcQ7FNEtfMOe/cATpVSv9VfAeMZDDnFLLz
	r/FSDUQoqO6KJWlh1waQIgl3QZ0DV0priK4iHy2I08nVBoZJcCEKHTdyfbF+JO/2
	xhVXCwaSV47+Wdnpr+tAoOeWG9HAok+FACf292GCebyLQ=
Received: from [10.42.12.6] (unknown [116.128.244.169])
	by gzsmtp3 (Coremail) with SMTP id PigvCgC3AcmMCHJn30eIHQ--.42567S2;
	Mon, 30 Dec 2024 10:42:21 +0800 (CST)
Message-ID: <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
Date: Mon, 30 Dec 2024 10:42:20 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <Z3B48799B604YiCF@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PigvCgC3AcmMCHJn30eIHQ--.42567S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXrWDuw1DZF1kXr45JF1kKrg_yoW5uF4kpr
	W3KaykKF4DGr4fA34qya1xX3yFqrW8K3y5ur4Fgr97Cwn8XF1SqF42vF1Y9ry8Cr1xt3Wj
	qrWI9FZru3WDAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U20PhUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiTwLFnWdyAN3TcQAAs-



On 2024/12/29 06:17, Dave Chinner wrote:
> On Sat, Dec 28, 2024 at 03:37:41PM +0800, Chi Zhiling wrote:
>>
>>
>> On 2024/12/27 05:50, Dave Chinner wrote:
>>> On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
>>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>>
>>>> Using an rwsem to protect file data ensures that we can always obtain a
>>>> completed modification. But due to the lock, we need to wait for the
>>>> write process to release the rwsem before we can read it, even if we are
>>>> reading a different region of the file. This could take a lot of time
>>>> when many processes need to write and read this file.
>>>>
>>>> On the other hand, The ext4 filesystem and others do not hold the lock
>>>> during buffered reading, which make the ext4 have better performance in
>>>> that case. Therefore, I think it will be fine if we remove the lock in
>>>> xfs, as most applications can handle this situation.
>>>
>>> Nope.
>>>
>>> This means that XFS loses high level serialisation of incoming IO
>>> against operations like truncate, fallocate, pnfs operations, etc.
>>>
>>> We've been through this multiple times before; the solution lies in
>>> doing the work to make buffered writes use shared locking, not
>>> removing shared locking from buffered reads.
>>
>> You mean using shared locking for buffered reads and writes, right?
>>
>> I think it's a great idea. In theory, write operations can be performed
>> simultaneously if they write to different ranges.
> 
> Even if they overlap, the folio locks will prevent concurrent writes
> to the same range.
> 
> Now that we have atomic write support as native functionality (i.e.
> RWF_ATOMIC), we really should not have to care that much about
> normal buffered IO being atomic. i.e. if the application wants
> atomic writes, it can now specify that it wants atomic writes and so
> we can relax the constraints we have on existing IO...

Yes, I'm not particularly concerned about whether buffered I/O is 
atomic. I'm more concerned about the multithreading performance of 
buffered I/O.

Last week, it was mentioned that removing i_rwsem would have some 
impacts on truncate, fallocate, and PNFS operations.

(I'm not familiar with pNFS, so please correct me if I'm wrong.)

My understanding is that the current i_rwsem is used to protect both
the file's data and its size. Operations like truncate, fallocate,
and PNFS use i_rwsem because they modify both the file's data and its 
size. So, I'm thinking whether it's possible to use i_rwsem to protect 
only the file's size, without protecting the file's data.

So operations that modify the file's size need to be executed 
sequentially. For example, buffered writes to the EOF, fallocate 
operations without the "keep size" requirement, and truncate operations, 
etc, all need to hold an exclusive lock.

Other operations require a shared lock because they only need to access
the file's size without modifying it.

> 
>> So we should track all the ranges we are reading or writing,
>> and check whether the new read or write operations can be performed
>> concurrently with the current operations.
> 
> That is all discussed in detail in the discussions I linked.

Sorry, I overlooked some details from old discussion last time.
It seems that you are not satisfied with the effectiveness of
range locks.


Best regards,
Chi Zhiling

