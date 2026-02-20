Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC1B337B97
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 10:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771582118; cv=none; b=NAK6jNMwf8aXoDK9NRg+r6XNSgyjw3EC7Ca1jjhCrMEsBRFdeIh4gzFDFhacMyev6U83ns3KNQmkwazfiHSIkEV3JblijkLt/byNe2W/gkb5qXc21hJt8e25/vDM0bvaSLBnoJ94xTjybKpKMwT/z3jEKNS2Qn8xeJs0fT7d4lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771582118; c=relaxed/simple;
	bh=XWwLHdUyhebPJACVUV6EjAM44WQ6O69L/5Jw/JN/wh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7KMnTEaw5f9HyZjMp7i5pWOKluoCqXRS2LEFidNE6QbR/WkMzUKizMoG3eF/WJtqyPsjCXZxkCviD9zMaVo8zCrbJt6GPRaQGgRc/ILD5MhP22VA1jrMEsv2UdrOJaFQ2pHeX2HHmwRwgnQQTmzc5Lv+kIUzKYMR23H4kjf6y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CFE1givt; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CFE1givt"
Date: Fri, 20 Feb 2026 10:08:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771582110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tDGJbI5FE8OyurRsiUKK7fUsDEFmbQate1+4YcD99o=;
	b=CFE1givtQqWIkgpUoykKYf0ZibeD6kxuIu8KPMJi1urMTEkYxiL9t1mA+WjPJ8a6ISnluW
	Ao/a0OlZC18fs3Z6PaadaAOCuz4G5ccBYj5MfPeRgP0vkjoVCwbXh7QjwFRtOsl5HjN+JB
	thrd5F8gIpvJ0cY6Um/Nw+s4dSzcgjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Cc: Andres Freund <andres@anarazel.de>, djwong@kernel.org, 
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, ritesh.list@gmail.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, Luis Chamberlain <mcgrof@kernel.org>, 
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, 
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <sjuplc6ud6ym3qyn7qmhzpr3jzjxpf6wcza3s2cenvmwwibbxr@aorfpiuxf7qy>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> Hi all,
> 
> Atomic (untorn) writes for Direct I/O have successfully landed in kernel
> for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
> remains a contentious topic, with previous discussions often stalling due to
> concerns about complexity versus utility.
> 

Hi,

Thanks a lot everyone for the input on this topic. I would like to
summarize some of the important points discussed here so that it could
be used as a reference for the talk and RFCs going forward:

- There is a general consensus to add atomic support to buffered IO
  path.

- First step is to add support to RWF_WRITETHROUGH as initially proposed
  by Dave Chinner.

  Semantics of RWF_WRITETHROUGH (based on my understanding):
  
  * Immediate Writeback Initiation: When RWF_WRITETHROUGH is used with a
    buffered write, the kernel will immediately initiate the writeback of
    the data to storage. We use page cache to serialize overlapping
    writes.
  
  Folio Lock -> Copy data to the page cache -> Initiate and complete writeback -> Unlock folio
  
  * Synchronous I/O Behavior: The I/O operation will behave synchronously
    from the application's perspective. This means the system call
    will block until the write operation has been submitted to the device.
    Any I/O errors will be reported directly to the caller. (Similar to Direct I/O)
  
  * No Inherent Data Integrity Guarantees: Unlike RWF_DSYNC,
    RWF_WRITETHROUGH itself does not inherently guarantee that the data
    has reached non-volatile storage.

- Once we have writethrough infrastructure is in place, we layer in
  atomic support to buffered IO path. But they will require more
  guarantees such as no short copies, using stable pages during
  writeback, etc.

Feel free to add/correct the above points.

--
Pankaj
