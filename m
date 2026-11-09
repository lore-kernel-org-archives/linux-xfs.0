Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794259528;
	b=WQkiBYyETJpMb+WVaPaFkrdHd5F8KPxx/BBq5nZT+TpVtAmGfAJWXzFcOlFFd9cjIKuj
	 oUxdJXuY4cFBkVgoMG++V8QYEWl2ovs+PStnQATlaVqfeOHDDaAfIJDLFv69AVbcmWGNz
	 rXmwzGwwyampDLpx4rVy+Cs3IPhTWqLBya6MwbsC5ctGFzT6uWxXBfoSeSdKNVokprwLP
	 XLz++TeO9Oz2E0PdGrryEYHqxuzktjmu5xJaNe9gi5IhhIq05YNRnUBPIQMNuthKuQInE
	 /DnQoE4Ry9QcK95GwpxgJzl2qIED07yLiRijoQTieYv0eSLYhabZ2xc/oLMatk87t+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794259528;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=w8qNrcDRfviGzp/W12lskg8vzOSQtPqvZ6RLRwKq4K4=;
	b=r/XrANujoDb+KZMWHiYbTgPIEdJ0Kh1jV/QNDYOM18t5YVAf2OkCafn0Mb4jbioom5rF
	 /z3E2lSL95o8dnCQAIdGoDZ76bo6hEb75IFszzmuJxsZNtoEstEiCActNdZgYabYc8Cwj
	 IpprgwuT03EKEj3gFL1PDKNdIcXVLNgw/JlWKY3dt/scph9jVFePh/nJ0wgOr5b2EVChN
	 3ZfPth5ifCRNyxbmKJDxymJD7L0lsz4qDXJJlcT4BOsD5AQTsLOSg+DhKxLljeTugidNl
	 UUnWDt608bmBrFpOZo2/qhZPo0u6tLEuCmlBTtE3To9qeFEu7mXkZql16ZigCArrVhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JnxUazb2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121C6606A31C;
	Mon,  9 Nov 2026 21:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JnxUazb2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E841F008A1;
	Mon,  9 Nov 2026 21:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794259527;
	bh=w8qNrcDRfviGzp/W12lskg8vzOSQtPqvZ6RLRwKq4K4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JnxUazb2agVqg+Egq+201b4OaPUtKhmE783usTE22/2j3j5vRZxo8H0Jdigg7PxEa
	 U5Sv0D99j0FgWEsXzJFqt2HtNhobQAJO0KAt8oNk/06l9F+2ICoeXACuMW0j0oBZQ4
	 R9ZWMGU3CeKloFq8n0BsG5/E65EcdhSCdtza3zpPFef0t3FnCWCZfQelbKmmh8Vu3R
	 JTv1fIa4tvbJkGs2zo99QNcKxH351/NskDAblz8NBgtrwXKKZZBUE590VgypjTU45E
	 CncXFG++ycJVm2dfT+StR1w/Yv898aHTZc70MXoHAlixNiM184Q1PT5hqb4PeS3j5I
	 mMC0bmGWDnWog==
Date: Tue, 10 Nov 2026 08:25:18 +1100
From: Dave Chinner <dgc@kernel.org>
To: Shengzhuo Wei <me@cherr.cc>
Cc: Carlos Maiolino <cem@kernel.org>, Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: bound node entries on path shifts
Message-ID: <avI6PtE8RdHWz8QE@dread>
References: <20261108-twin-20261106-fs-xfs-da-node-v1-0-0d4bd47938ba@cherr.cc>
 <20261108-twin-20261106-fs-xfs-da-node-v1-1-0d4bd47938ba@cherr.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-twin-20261106-fs-xfs-da-node-v1-1-0d4bd47938ba@cherr.cc>

On Sun, Nov 08, 2026 at 03:49:58AM +0800, Shengzhuo Wei wrote:
> The da-node verifier uses the larger of the directory and attribute
> geometry limits, so an attribute node can pass verification with more
> entries than its buffer holds.  xfs_da3_path_shift() can load such a node
> without passing through the lookup path's geometry check, then index
> btree[] beyond the buffer.
> 
> Bound the count against args->geo->node_ents before indexing the entries
> and report filesystem corruption if it exceeds that limit.

These checks belong in the context of xfs_da3_header_check(),
not randomly placed in the code -after- calls to
xfs_da3_header_check().

-Dave.
-- 
Dave Chinner
dgc@kernel.org
