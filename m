Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5C5442388;
	Tue,  1 Sep 2026 20:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788294570; cv=none; b=DHDd+PUEf7VoHobdeFJsDgVb8lkvRb/5BV/Rp/l8OVyABHxGnjp+8yk2qBlmRDzl8FFRv3sD2pwrzBmozNseWgEOpf0gkd9NVz3jwNAoYr1G3ZcV+F1qxCxDSPmQwCWoinOZj/t/tLI6DSC5wvTZSZryjAZ3GtM875hG8Tsrpig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788294570; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7SIOhGcuwGOJjCa903UcS7riAMQD0GP/dsmH2XnqY27gDmZRCyAw9HxdXlNgiCWrNBr/7B1j9920xVT6B7JhUwpH9EwoToEk/FhAesC39YO3jnbdxyvdb8JMwtOoPjWYNacIaL+Xi/CowLqiEusk+nlu3kE5cWM2UhB0hWtGnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHnc9AkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHnc9AkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E891F000E9;
	Tue,  1 Sep 2026 20:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788294568;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GHnc9AkMu8ce9n+HMBvbAn8Krm1Gsxh5hDD1NQ1ORMazndd1HS5Sx8sLT4L0ZVE85
	 CjFJ/EADfsbbqTS6ffNi/Tftm43kSBjFiscGjTIImubwVFY7HfXlidLB/pZhTRnliN
	 a4XWeiCk73rMN8fgQfKvj8ArcdQnl/BKJVWrgjwLh5Ze909jVnfMlyygkCQ0ws2z+u
	 ww1ByKFUujuPbPMQYWK8uTlkh/ALd36LoWiM9JuqcNk52ddaFNHjyu1rmKl9v6Azrg
	 C6tsysr8aheQGci7u4LU1KK9m+vZKCbkcBNcRqrRXQ3xxq2Am7n9VmXEBsBxvuCPYh
	 X9AChjoqqLvjA==
Date: Wed, 2 Sep 2026 04:29:22 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 11/13] fstests: verify exportfs file handles on cloned
 filesystems
Message-ID: <apc0FKW7Zuez4SeB@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <7afe9c82cce1540ea0f8cc1f3d1306c24b6cc84d.1784949155.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7afe9c82cce1540ea0f8cc1f3d1306c24b6cc84d.1784949155.git.asj@kernel.org>

