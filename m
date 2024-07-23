Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBD2208A0;
	Tue, 23 Jul 2024 13:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721741958; cv=none; b=MTYbGRhBCC13pwO3BlPVBMNFswLgrMC6YiAlLazbIzDd4Sj7BZzvyS8Hnc/LyJuNe4H0NHaWmRWIrdDI39tMnyuqblNXI0UhBW7rLmbv1yca5bHfpHqUj72LoBg2NnWN63NWjpw7XRMOa7H4r9N4LrL4621yYp+qcsO1441fvrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721741958; c=relaxed/simple;
	bh=R7nMFRX8BYwxqiuPvKKAQqLY9/4YpEQoFaUxlpxUrXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqtdSQv8nwh00TujKFJ0AE4G8WjwAkp+KxAnZdtHjmFl7OK/7cJApE+AlvirkqhTccItiSp5cQaiZnn7UjlInKJjOJfh9i5z3Oj0U5ecWrP106vo1yaSoktww1LcJEd+IfGCMNPTaT+xhYQW2kdT8/+smZuyOnw8jw0VmBQipbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0673668AA6; Tue, 23 Jul 2024 15:39:05 +0200 (CEST)
Date: Tue, 23 Jul 2024 15:39:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: RFC: don't fail tests when mkfs options collide
Message-ID: <20240723133904.GA20005@lst.de>
References: <20240723000042.240981-1-hch@lst.de> <20240723035016.GB3222663@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723035016.GB3222663@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 22, 2024 at 11:50:16PM -0400, Theodore Ts'o wrote:
> Yeah, it's a bit of a mess.  It's not been an issue for ext4 because
> mkfs.ext4 allows options specified later in the command-line to
> override earlier ones.

At least in my case it's not really by overriding.  E.g. if I force
an allocation group (or block group in extN terms) to a specific size
and then want a log that is larger than that, changing the AG size
is generally a bad idea, and a clear warning to the user is simply the
better interface.

> There's a third possibility, which is sometimes the test might
> explicitly want the mkfs options to be merged together.  For example,
> in the ext4/4k configuration we have "-b 4096", while the ext4/1k
> confiuration option we might have "-b 1024".  And we might want to
> have that *combined* with a test which is enabling fscrypt feature, so
> we can test fscrypt with a 4k block size, as well as fsvrypt with a 1k
> blocksize.
> 
> That being said, that doesn't always make sense, and sometimes the
> combination doesn't make any sense.

Merging the options is what we're currently doing, and it works ok
most of the time.  The question is what to do when it doesn't.

