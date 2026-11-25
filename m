Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.35.52.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795638114;
	b=oFgEEGYUz73+gHLUs8tn5ELUppzJDdBt/Pyim7VrWgQwEyhtyw0PiaWdKUcFV3n9NZF4
	 S7lEmuIHoRx+JRlJmQlcRAzMFFpSSf2ND+t+66GlgqSGD5kr97KyYmIxksQxUTknKrqkv
	 kVQ2PnhaKsOsf8IS3MYP31izJqfEeP81yrpjaOavTpK99PSui5iT+aaOA3ttCiGVouf+F
	 T6Mk5QgiDAL509CKvXEmk9FRNhT+1M+iUyHTPTq6712zFcM+IqmgfGJEDiUhacHmm7sdh
	 LLBJMYT+6l6Lqt2gRZKVJ6Fq81zm6wYJGjEMspGRAAHPM64X6OYD94H3/d6EHGAFXKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795638114;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:X-Operating-System:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=SMuvUMmcd51+aQ9L+bd+zME39Xeb4Mz81XJwG9MwcCE=;
	b=DuEMK+miYJJaI8K/561E/4h2gWJe4bwwuXcE9y1C2hXqRfm/oklCRMHqDfTCAm0SsRX3
	 0sN59duttB4dWrUwm5K+VsISFmmkXP9g2QgE5DONcz0swEu1rvaiHlQSUt6j9ovg57+Sk
	 Ig4Yx/R00lKFvtUmEVIt1bEDVrdLFC3JOOOPvDIqKvNaLVz4XvhncVWbxdHtJfzk+1qBD
	 rq2Rn9ztvzFqXRInQtz+znB/hs7tlQ5fD+VL1Oo9gNsrmyBQAkCW1bAxAx2Pgy5Tsj6yC
	 TdGsEVEdDDJhOSymoJgtr8BHD5+XAtHEOutOHCq3FLgEA1OuzBqHNqGgW7YGJGfx75A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gunderson.no;
	spf=pass smtp.mailfrom=gunderson.no;
	dkim=pass header.d=gunderson.no header.i=@gunderson.no header.a=rsa-sha256 header.s=legacy header.b=po1JIVWC;
	arc=none smtp.remote-ip=193.35.52.50
Received: from pannekake.samfundet.no (pannekake.samfundet.no [193.35.52.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183DB606A68C
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 20:21:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 183DB606A68C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gunderson.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.a=rsa-sha256 header.s=legacy header.b=po1JIVWC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gunderson.no; s=legacy; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SMuvUMmcd51+aQ9L+bd+zME39Xeb4Mz81XJwG9MwcCE=; b=po1JIVWChG9KzvAk/f7S1Y5Y7d
	Y6lFtamIHMOxaN+Bz2hl6h0778pDKVHk87htFuhWHywXFOFP5ZP/fJCl2XEvUynuBoic4Ulagsite
	q7iQDq5p7V5/aIHqzwjjn0FPogg6k5agGb4I2oJWpGLyPuBOH0i4Y4w7COPJZLA/40zCPZzNMWYbp
	Qc3maKNcL37mIp1zxJbh9hFTnapmaE/WR5lXW6DJjMOamnYKPBfxCg6IIQenUKfUjk2id6GAU3ZWG
	Q+3xNq67Fourqo+oTdNcmSCinHTiBILO/cPCyOD2fIGG/+KaN3ELh+fa5BFElBcZruok6AIQHJW23
	2SnDKPMQ==;
Received: from sesse by pannekake.samfundet.no with local (Exim 4.98.2)
	(envelope-from <steinar+bounces@gunderson.no>)
	id 1xWJGb-00000004TyR-0VbL;
	Wed, 25 Nov 2026 21:07:23 +0100
Date: Wed, 25 Nov 2026 21:06:57 +0100
From: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Hung I/O
Message-ID: <qysdhvymyqqjfxxw3phjqgvpzufnrebgjukdehpmbhsov6475z@no5x7lcenlbd>
X-Operating-System: Linux 7.3.6 on a x86_64
References: <sh2gykmlybrlf77d6mp76pddecwl47pxoookx2sbo74y6ffme4@gcu2kqu7q4o2>
 <awc-vvNFH3vfYLWv@dread>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <awc-vvNFH3vfYLWv@dread>

On Thu, Nov 26, 2026 at 07:02:06AM +1100, Dave Chinner wrote:
> can you post the entire dmesg output from 'echo w >
> /proc/sysrq-trigger' and 'echo l > /proc/sysrq-trigger' to capture
> all the currently blocked and running processes when the hang
> happens.

Sure. I'll recreate the issue, it shouldn't take forever; but it takes a
while to get the system back to working again so that I can send email :-)

Some possibly relevant data points:

 - It happens even without writes to the mmap-ed file.
 - Changing the file system to ext4 gives the same problem
   (stack traces show jbd2).
 - Using a raw block device does _not_ give the same problem.

>> Any ideas? It appears to be fairly easily reproducible, so I can do more
>> debugging if need be (although it's a production machine, so not too much
>> rebooting would be fine).
> Start with getting all the blocked tasks and building a dependency
> map of which tasks are stuck behind others. That will narrow down
> whether this is some internal deadlock in the filesystem or whether
> the lower layers of the stack have lost a bunch of IO completions...

OK, I'll see what I can find out.

/* Steinar */
-- 
Homepage: https://www.sesse.net/
