Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4438F14B07E;
	Tue, 30 Jul 2024 03:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309911; cv=none; b=ueryJMzHy+Om5rL5riHvNK2yDJk6te1Hnqkhye/6jlcYfoHzxVCwIaHvuE1moRGvruASCpHyx9YlRqs82zX3RNTrvU5DDhYYUukZ+D7ALc+rBA7cQF6nnjyFP8fE5vO9U+9iC+XDutlMWBJ1oECk+chFX20rFG5nHFQdZ+ysvtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309911; c=relaxed/simple;
	bh=RZB/b45UPD7u+LonAKNKIdLUWboOv7At3DFODRHkTkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kuaUa5XeDHN1v88SFpkVFYgi9aWFE2u/qh5Rt43VVx8Sv7SbG3tOVCnLS+NpRgWgP9QfiXiRWR8Du6D2E0Ii6CWKSPDjo6GZGtEiUf2CQVJ9+lXmlhIx+IROoVAMLQPdrIAK3DzKPkXTwWXjlY8CRqphUxtJU9QdPbCO/mG7bOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5PgM5NG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5PgM5NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75F8C32786;
	Tue, 30 Jul 2024 03:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309908;
	bh=RZB/b45UPD7u+LonAKNKIdLUWboOv7At3DFODRHkTkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q5PgM5NGKlzuDhaqLHfBNXogKkIrAyzyjIDsRPES5WHiwKmgwwChgoiI5JwJLkPah
	 xdJOq4m0ek7n5dd3zyNnEH7j4ol60n8W3YX0LmHM10jDAFMcK8j41JENYsRNNad68G
	 rl/68bzxpHVdPJ9C/oqRD7XPBzN4K3EiW6kMe812drXNoGj3+kjRKM3sFYw/GHpOgO
	 JZ5t8DlM+4a8sviqTbevyiCKs8a1tK3tEsrJefxGQDFALdY/UTqJE/9K/aN9ROh2Cr
	 I159RgVFJGG8x80o1si+2HVKJdimsvvnFmm4UbtGZgtQL2pCrQubX+SfxCfXegssy7
	 lfeAzu5dmlh1A==
Date: Mon, 29 Jul 2024 20:25:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v30.9] fstests: xfs filesystem properties
Message-ID: <20240730032508.GA6337@frogsfrogsfrogs>
References: <20240730031030.GA6333@frogsfrogsfrogs>
 <172230948293.1545890.16907565259543283790.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172230948293.1545890.16907565259543283790.stgit@frogsfrogsfrogs>

On Mon, Jul 29, 2024 at 08:19:43PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> It would be very useful if system administrators could set properties for a
> given xfs filesystem to control its behavior.  This we can do easily and
> extensibly by setting ATTR_ROOT (aka "trusted") extended attributes on the root
> directory.  To prevent this from becoming a weird free for all, let's add some
> library and tooling support so that sysadmins simply run the xfs_property
> program to administer these properties.

Heh, I forgot to cc the patchbomb coverletter -- this is an RFC, not for
merging at this time.

--D
